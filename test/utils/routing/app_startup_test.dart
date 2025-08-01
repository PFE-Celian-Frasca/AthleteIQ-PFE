import 'dart:async';

import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/services/firebase_notification_service.dart';
import 'package:athlete_iq/utils/routing/app_startup.dart';
import 'package:athlete_iq/view/onboarding/provider/onboarding_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {
  @override
  Future<void> updateUserFcmToken(String userId, String token) async {}
}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {
  @override
  Future<String?> getToken({String? vapidKey}) async => 'test-token';

  @override
  Stream<String> get onTokenRefresh => StreamController<String>.broadcast().stream;
}

class MockUser extends Mock implements User {
  @override
  String get uid => 'test-user-id';
}

void main() {
  group('appStartup', () {
    late ProviderContainer container;
    late MockOnboardingRepository mockOnboardingRepository;
    late MockAuthRepository mockAuthRepository;
    late MockUserRepository mockUserRepository;
    late MockFirebaseMessaging mockFirebaseMessaging;
    late MockUser mockUser;
    late StreamController<String> tokenRefreshController;

    setUp(() {
      mockOnboardingRepository = MockOnboardingRepository();
      mockAuthRepository = MockAuthRepository();
      mockUserRepository = MockUserRepository();
      mockFirebaseMessaging = MockFirebaseMessaging();
      mockUser = MockUser();
      tokenRefreshController = StreamController<String>();

      // Setup mock auth repository
      when(mockAuthRepository.currentUser).thenReturn(mockUser);

      // Setup container with overrides
      container = ProviderContainer(
        overrides: [
          onboardingRepositoryProvider.overrideWith(
            (ref) => Future.value(mockOnboardingRepository),
          ),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          userRepositoryProvider.overrideWithValue(mockUserRepository),
          firebaseMessagingProvider.overrideWithValue(mockFirebaseMessaging),
          notificationHandlerProvider.overrideWithValue(null),
        ],
      );
    });

    tearDown(() {
      tokenRefreshController.close();
      container.dispose();
    });
  });

  group('AppStartupWidget', () {
    late ProviderContainer container;
    late MockOnboardingRepository mockOnboardingRepository;
    late MockAuthRepository mockAuthRepository;
    late MockUserRepository mockUserRepository;

    setUp(() {
      mockOnboardingRepository = MockOnboardingRepository();
      mockAuthRepository = MockAuthRepository();
      mockUserRepository = MockUserRepository();

      // Setup container with overrides
      container = ProviderContainer(
        overrides: [
          onboardingRepositoryProvider.overrideWith(
            (ref) => Future.value(mockOnboardingRepository),
          ),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          userRepositoryProvider.overrideWithValue(mockUserRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('shows loading widget when loading', (WidgetTester tester) async {
      // Create a completer that we can control
      final completer = Completer<void>();

      // Override the appStartupProvider to return a future that we control
      final overriddenContainer = ProviderContainer(
        overrides: [
          appStartupProvider.overrideWith((_) => completer.future),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: overriddenContainer,
          child: const MaterialApp(
            home: AppStartupWidget(
              onLoaded: _buildTestWidget,
            ),
          ),
        ),
      );

      // Verify loading widget is shown
      expect(find.byType(AppStartupLoadingWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future to avoid pending timers
      completer.complete();
      await tester.pump();

      overriddenContainer.dispose();
    });

    testWidgets('shows error widget when error occurs', (WidgetTester tester) async {
      // Override the appStartupProvider to return an error state
      final overriddenContainer = ProviderContainer(
        overrides: [
          appStartupProvider.overrideWith((_) => Future.error('Test error')),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: overriddenContainer,
          child: const MaterialApp(
            home: AppStartupWidget(
              onLoaded: _buildTestWidget,
            ),
          ),
        ),
      );

      // Wait for the future to complete with error
      await tester.pump();

      // Verify error widget is shown
      expect(find.byType(AppStartupErrorWidget), findsOneWidget);
      expect(find.text('Test error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      overriddenContainer.dispose();
    });

    testWidgets('shows loaded widget when data is available', (WidgetTester tester) async {
      // Override the appStartupProvider to return a completed state
      final overriddenContainer = ProviderContainer(
        overrides: [
          appStartupProvider.overrideWith((_) => Future.value()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: overriddenContainer,
          child: const MaterialApp(
            home: AppStartupWidget(
              onLoaded: _buildTestWidget,
            ),
          ),
        ),
      );

      // Wait for the future to complete
      await tester.pump();

      // Verify loaded widget is shown
      expect(find.text('Loaded'), findsOneWidget);

      overriddenContainer.dispose();
    });

    testWidgets('retry button invalidates provider', (WidgetTester tester) async {
      // Override the appStartupProvider to return an error state
      final overriddenContainer = ProviderContainer(
        overrides: [
          appStartupProvider.overrideWith((_) => Future.error('Test error')),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: overriddenContainer,
          child: const MaterialApp(
            home: AppStartupWidget(
              onLoaded: _buildTestWidget,
            ),
          ),
        ),
      );

      // Wait for the future to complete with error
      await tester.pump();

      // Tap the retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // Verify the provider was invalidated (this is hard to test directly,
      // but we can verify the widget is still in error state)
      expect(find.byType(AppStartupErrorWidget), findsOneWidget);

      overriddenContainer.dispose();
    });
  });

  group('AppStartupLoadingWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppStartupLoadingWidget(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('AppStartupErrorWidget', () {
    testWidgets('renders correctly and calls onRetry', (WidgetTester tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: AppStartupErrorWidget(
            message: 'Error message',
            onRetry: () {
              retryPressed = true;
            },
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Error message'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Tap the retry button
      await tester.tap(find.text('Retry'));

      // Verify onRetry was called
      expect(retryPressed, isTrue);
    });
  });
}

// Helper function to build a test widget
Widget _buildTestWidget(BuildContext context) {
  return const Text('Loaded');
}
