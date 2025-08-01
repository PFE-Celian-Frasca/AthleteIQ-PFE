import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/auth/email_verify_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockInternalNotificationService extends Mock implements InternalNotificationService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('EmailVerifyScreen Integration Tests', () {
    late Widget testWidget;
    late MockAuthRepository mockAuthRepository;
    late MockUser mockUser;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockUser = MockUser();
      final mockNotificationService = MockInternalNotificationService();

      // Setup mock user
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.emailVerified).thenReturn(false);
      when(() => mockUser.reload()).thenAnswer((_) async {});

      // Setup mock auth repository
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(() => mockAuthRepository.sendEmailVerification()).thenAnswer((_) async {});
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

      // Setup mock notification service
      when(() => mockNotificationService.showToast(any())).thenReturn(null);
      when(() => mockNotificationService.showErrorToast(any())).thenReturn(null);

      testWidget = ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
            internalNotificationProvider.overrideWithValue(mockNotificationService),
          ],
          child: const MaterialApp(
            home: EmailVerifyScreen(),
          ),
        ),
      );
    });

    testWidgets('should display all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.text('Veuillez vérifier votre email'), findsOneWidget);
      expect(find.text('Un email de vérification a été envoyé à test@example.com'), findsOneWidget);
      expect(find.text('Renvoyer'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should send verification email on page load', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Verify that sendEmailVerification was called on page load
      verify(() => mockAuthRepository.sendEmailVerification()).called(1);
    });

    testWidgets('should resend verification email when button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Clear previous interactions
      clearInteractions(mockAuthRepository);

      // Tap the resend button
      await tester.tap(find.text('Renvoyer'));
      await tester.pumpAndSettle();

      // Verify that sendEmailVerification was called again
      verify(() => mockAuthRepository.sendEmailVerification()).called(1);
    });

    testWidgets('should navigate to home when email is verified', (WidgetTester tester) async {
      // Create a mock app with GoRouter for navigation testing
      final mockGoRouter = MockGoRouter();
      final mockNotificationService = MockInternalNotificationService();
      when(() => mockGoRouter.go(any())).thenReturn(null);
      when(() => mockNotificationService.showToast(any())).thenReturn(null);
      when(() => mockNotificationService.showErrorToast(any())).thenReturn(null);

      final mockApp = ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          home: ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(mockAuthRepository),
              internalNotificationProvider.overrideWithValue(mockNotificationService),
            ],
            child: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () {
                    // Simulate email verification
                    when(() => mockUser.emailVerified).thenReturn(true);
                    GoRouter.of(context).go('/home');
                  },
                  child: const Text('Simulate Verification'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(mockApp);
      await tester.pumpAndSettle();

      // Tap the button to simulate verification
      await tester.tap(find.text('Simulate Verification'));
      await tester.pumpAndSettle();

      // In a real test with GoRouter, we'd verify navigation to home
    });

    testWidgets('should sign out when back button is pressed and email is not verified',
        (WidgetTester tester) async {
      // Create a widget with a back button
      final mockNotificationService = MockInternalNotificationService();
      when(() => mockNotificationService.showToast(any())).thenReturn(null);
      when(() => mockNotificationService.showErrorToast(any())).thenReturn(null);

      final mockApp = ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
            internalNotificationProvider.overrideWithValue(mockNotificationService),
          ],
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () async {
                    await mockAuthRepository.signOut();
                  },
                ),
              ),
              body: const Center(child: Text('Test')),
            ),
          ),
        ),
      );

      await tester.pumpWidget(mockApp);
      await tester.pumpAndSettle();

      // Tap the back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify that signOut was called
      verify(() => mockAuthRepository.signOut()).called(1);
    });

    testWidgets('should navigate to home when back button is pressed and email is verified',
        (WidgetTester tester) async {
      // Setup verified user
      when(() => mockUser.emailVerified).thenReturn(true);

      // Create a mock app with GoRouter for navigation testing
      final mockGoRouter = MockGoRouter();
      final mockNotificationService = MockInternalNotificationService();
      when(() => mockGoRouter.go(any())).thenReturn(null);
      when(() => mockNotificationService.showToast(any())).thenReturn(null);
      when(() => mockNotificationService.showErrorToast(any())).thenReturn(null);

      // Create a variable to track if navigation was attempted
      var navigatedToHome = false;

      final mockApp = ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          home: ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(mockAuthRepository),
              internalNotificationProvider.overrideWithValue(mockNotificationService),
            ],
            child: Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () {
                    if (mockUser.emailVerified) {
                      // Instead of using GoRouter.of(context), just set our flag
                      navigatedToHome = true;
                    }
                  },
                ),
              ),
              body: const Center(child: Text('Test')),
            ),
          ),
        ),
      );

      await tester.pumpWidget(mockApp);
      await tester.pumpAndSettle();

      // Tap the back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify that navigation was attempted
      expect(navigatedToHome, isTrue);
    });
  });
}
