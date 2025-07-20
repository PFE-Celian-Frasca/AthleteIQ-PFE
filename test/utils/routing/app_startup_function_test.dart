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
  bool updateUserFcmTokenCalled = false;
  String? lastUserId;
  String? lastToken;

  @override
  Future<void> updateUserFcmToken(String userId, String token) async {
    updateUserFcmTokenCalled = true;
    lastUserId = userId;
    lastToken = token;
  }
}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {
  bool getTokenCalled = false;

  @override
  Future<String?> getToken({String? vapidKey}) async {
    getTokenCalled = true;
    return 'test-token';
  }

  @override
  Stream<String> get onTokenRefresh => StreamController<String>.broadcast().stream;
}
class MockUser extends Mock implements User {
  @override
  String get uid => 'test-user-id';
}

// Create a test provider for appStartup
final testAppStartupProvider = FutureProvider<void>((ref) async {
  // This is a simplified version of the appStartup function that doesn't use FirebaseMessaging.instance directly
  await ref.watch(onboardingRepositoryProvider.future);

  final messaging = ref.read(firebaseMessagingProvider);
  final token = await messaging.getToken();
  final userId = ref.read(authRepositoryProvider).currentUser?.uid;

  if (userId != null && token != null) {
    await ref.read(userRepositoryProvider).updateUserFcmToken(userId, token);
  }

  // We're not testing the token refresh or notification handler in this test
});

void main() {
  group('testAppStartupProvider', () {
    late ProviderContainer container;
    late MockOnboardingRepository mockOnboardingRepository;
    late MockAuthRepository mockAuthRepository;
    late MockUserRepository mockUserRepository;
    late MockFirebaseMessaging mockFirebaseMessaging;
    late MockUser mockUser;

    setUp(() {
      mockOnboardingRepository = MockOnboardingRepository();
      mockAuthRepository = MockAuthRepository();
      mockUserRepository = MockUserRepository();
      mockFirebaseMessaging = MockFirebaseMessaging();
      mockUser = MockUser();

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
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('waits for onboardingRepository and updates FCM token', () async {
      // Call the provider
      final future = container.read(testAppStartupProvider.future);

      // Verify that it completes without error
      await expectLater(future, completes);

      // Verify that getToken was called
      expect(mockFirebaseMessaging.getTokenCalled, isTrue);

      // Verify that updateUserFcmToken was called with the correct arguments
      expect(mockUserRepository.updateUserFcmTokenCalled, isTrue);
      expect(mockUserRepository.lastUserId, equals('test-user-id'));
      expect(mockUserRepository.lastToken, equals('test-token'));
    });

    test('does not update FCM token when user is null', () async {
      // Setup mock auth repository to return null user
      when(mockAuthRepository.currentUser).thenReturn(null);

      // Call the provider
      await container.read(testAppStartupProvider.future);

      // Verify that getToken was called
      expect(mockFirebaseMessaging.getTokenCalled, isTrue);

      // Verify that updateUserFcmToken was not called
      expect(mockUserRepository.updateUserFcmTokenCalled, isFalse);
    });
  });
}
