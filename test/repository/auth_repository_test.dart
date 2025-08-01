import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/firebase_mocks.dart';
import '../mocks/failing_mocks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeUser extends Fake implements User {
  bool sendEmailVerificationCalled = false;
  bool verifyBeforeUpdateEmailCalled = false;
  bool updatePasswordCalled = false;
  bool reauthenticateCalled = false;
  bool deleteCalled = false;

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? settings]) async {
    sendEmailVerificationCalled = true;
  }

  @override
  Future<void> verifyBeforeUpdateEmail(String email, [ActionCodeSettings? settings]) async {
    verifyBeforeUpdateEmailCalled = true;
  }

  @override
  Future<void> updatePassword(String password) async {
    updatePasswordCalled = true;
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    reauthenticateCalled = true;
    return MockUserCredential();
  }

  @override
  Future<void> delete() async {
    deleteCalled = true;
  }
}

class FakeAuth extends Fake implements FirebaseAuth {
  bool signInCalled = false;
  bool signOutCalled = false;
  bool signUpCalled = false;
  bool resetPasswordCalled = false;
  bool authChangesCalled = false;

  final FakeUser user = FakeUser();

  @override
  User? get currentUser => user;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    signInCalled = true;
    return MockUserCredential();
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    signUpCalled = true;
    return MockUserCredential();
  }

  @override
  Future<void> sendPasswordResetEmail(
      {required String email, ActionCodeSettings? actionCodeSettings}) async {
    resetPasswordCalled = true;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Stream<User?> authStateChanges() {
    authChangesCalled = true;
    return Stream<User?>.value(user);
  }
}

void main() {
  test('signIn calls FirebaseAuth.signInWithEmailAndPassword', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.signIn(email: 'a', password: 'b');
    expect(auth.signInCalled, isTrue);
  });

  test('signOut calls FirebaseAuth.signOut', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.signOut();
    expect(auth.signOutCalled, isTrue);
  });

  test('signUp calls FirebaseAuth.createUserWithEmailAndPassword', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.signUp(email: 'a', password: 'b');
    expect(auth.signUpCalled, isTrue);
  });

  test('resetPassword calls FirebaseAuth.sendPasswordResetEmail', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.resetPassword('a');
    expect(auth.resetPasswordCalled, isTrue);
  });

  test('sendEmailVerification calls User.sendEmailVerification', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.sendEmailVerification();
    expect(auth.user.sendEmailVerificationCalled, isTrue);
  });

  test('updateEmail calls User.verifyBeforeUpdateEmail', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.updateEmail('new@example.com');
    expect(auth.user.verifyBeforeUpdateEmailCalled, isTrue);
  });

  test('updatePassword calls User.updatePassword', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.updatePassword('pass');
    expect(auth.user.updatePasswordCalled, isTrue);
  });

  test('reauthenticate calls User.reauthenticateWithCredential', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.reauthenticate('e', 'p');
    expect(auth.user.reauthenticateCalled, isTrue);
  });

  test('deleteAccount calls User.delete', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    await repo.deleteAccount();
    expect(auth.user.deleteCalled, isTrue);
  });

  test('authStateChanges returns current user stream', () async {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    final user = await repo.authStateChanges().first;
    expect(user, auth.user);
    expect(auth.authChangesCalled, isTrue);
  });

  test('currentUser exposes FirebaseAuth.currentUser', () {
    final auth = FakeAuth();
    final repo = AuthRepository(auth);
    expect(repo.currentUser, auth.user);
  });

  test('methods throw formatted exceptions on failure', () async {
    final auth = ThrowAuth();
    final repo = AuthRepository(auth);
    await expectLater(repo.signIn(email: 'e', password: 'p'), throwsException);
    await expectLater(repo.signUp(email: 'e', password: 'p'), throwsException);
    await expectLater(repo.signOut(), throwsException);
    await expectLater(repo.resetPassword('e'), throwsException);
    await expectLater(repo.sendEmailVerification(), throwsException);
    await expectLater(repo.updateEmail('e'), throwsException);
    await expectLater(repo.updatePassword('p'), throwsException);
    await expectLater(repo.reauthenticate('e', 'p'), throwsException);
    await expectLater(repo.deleteAccount(), throwsException);
  });

  test('authStateChanges propagates errors', () async {
    final auth = ThrowAuth();
    final repo = AuthRepository(auth);
    await expectLater(repo.authStateChanges().first, throwsException);
  });

  test('providers can be overridden', () {
    final auth = MockFirebaseAuth();
    final container = ProviderContainer(overrides: [
      firebaseAuthProvider.overrideWithValue(auth),
      authRepositoryProvider.overrideWith((ref) => AuthRepository(auth)),
    ]);
    expect(container.read(firebaseAuthProvider), auth);
    expect(container.read(authRepositoryProvider), isA<AuthRepository>());
  });
}
