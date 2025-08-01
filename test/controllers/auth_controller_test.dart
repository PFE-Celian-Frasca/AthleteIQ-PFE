import 'package:athlete_iq/view/auth/auth_controller.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUserAuth extends Mock implements User {}

class MockInternalNotificationService extends Mock implements InternalNotificationService {}

void main() {
  late ProviderContainer container;
  late MockAuthRepository authRepository;
  late MockUserRepository userRepository;
  late MockInternalNotificationService notification;

  setUpAll(() {
    registerFallbackValue(UserModel(
      id: 'id',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    authRepository = MockAuthRepository();
    userRepository = MockUserRepository();
    notification = MockInternalNotificationService();

    container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      userRepositoryProvider.overrideWithValue(userRepository),
      internalNotificationProvider.overrideWithValue(notification),
    ]);
    addTearDown(container.dispose);
  });

  group('AuthController', () {
    test('signIn success sets loading states and calls repository', () async {
      when(() =>
              authRepository.signIn(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async {});

      final states = <bool>[];
      container.listen(authControllerProvider, (p, n) => states.add(n), fireImmediately: true);

      await container.read(authControllerProvider.notifier).signIn(email: 'e', password: 'p');

      expect(states, [false, true, false]);
      verify(() => authRepository.signIn(email: 'e', password: 'p')).called(1);
      verifyNever(() => notification.showErrorToast(any()));
    });

    test('signIn error shows notification', () {
      when(() =>
              authRepository.signIn(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => container.read(authControllerProvider.notifier).signIn(email: 'x', password: 'y'),
        throwsA(isA<FirebaseAuthException>()),
      );

      verify(() => notification.showErrorToast('Aucun utilisateur trouvé pour cet email.'))
          .called(1);
    });

    test('signUp creates user on success', () async {
      final mockUser = MockUserAuth();
      when(() => userRepository.checkIfPseudoExist(any())).thenAnswer((_) async => false);
      when(() =>
              authRepository.signUp(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async {});
      when(() => authRepository.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('u1');
      when(() => userRepository.createUser(any())).thenAnswer((_) async {});

      await container.read(authControllerProvider.notifier).signUp(
            email: 'a',
            password: 'b',
            pseudo: 'p',
            sex: 'M',
          );

      verify(() => userRepository.createUser(any())).called(1);
    });

    test('signUp fails when pseudo exists', () {
      when(() => userRepository.checkIfPseudoExist('dup')).thenAnswer((_) async => true);

      expect(
        () => container.read(authControllerProvider.notifier).signUp(
              email: 'a',
              password: 'b',
              pseudo: 'dup',
              sex: 'F',
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('sendEmailVerification calls repository and resets state', () async {
      when(() => authRepository.sendEmailVerification()).thenAnswer((_) async {});
      final states = <bool>[];
      container.listen(authControllerProvider, (p, n) => states.add(n), fireImmediately: true);

      await container.read(authControllerProvider.notifier).sendEmailVerification();

      expect(states, [false, true, false]);
      verify(() => authRepository.sendEmailVerification()).called(1);
    });

    test('sendEmailVerification error notifies', () {
      when(() => authRepository.sendEmailVerification()).thenThrow(Exception('err'));

      expect(
        () => container.read(authControllerProvider.notifier).sendEmailVerification(),
        throwsA(isA<Exception>()),
      );

      verify(() => notification.showErrorToast('Exception: err')).called(1);
    });
  });
}
