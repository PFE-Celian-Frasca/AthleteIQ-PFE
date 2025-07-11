import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/firebase_mocks.dart';
import 'package:mockito/mockito.dart';

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

  final FakeUser user = FakeUser();

  @override
  User? get currentUser => user;

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    signInCalled = true;
    return MockUserCredential();
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    signUpCalled = true;
    return MockUserCredential();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email, ActionCodeSettings? actionCodeSettings}) async {
    resetPasswordCalled = true;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
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
}
