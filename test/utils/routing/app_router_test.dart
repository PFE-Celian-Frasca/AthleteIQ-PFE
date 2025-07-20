import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/utils/routing/app_router.dart';
import 'package:athlete_iq/utils/routing/app_startup.dart';
import 'package:athlete_iq/view/onboarding/provider/onboarding_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  group('AppRouter Tests', () {
    late MockAuthRepository mockAuthRepository;
    late MockOnboardingRepository mockOnboardingRepository;
    late ProviderContainer container;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      final mockUser = MockUser();
      mockOnboardingRepository = MockOnboardingRepository();

      // Setup default behavior for mocks
      when(() => mockOnboardingRepository.isOnboardingComplete()).thenReturn(true);
      when(() => mockAuthRepository.authStateChanges()).thenAnswer((_) => Stream.value(null));
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      when(() => mockUser.emailVerified).thenReturn(false);

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          // Use a different approach for FutureProvider
          onboardingRepositoryProvider.overrideWith((_) => Future.value(mockOnboardingRepository)),
          appStartupProvider.overrideWith((_) => Future.value()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should create GoRouter instance', () {
      final router = container.read(goRouterProvider);
      expect(router, isA<GoRouter>());
    });
  });
}
