import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/firebase_mocks.dart';
import 'package:mockito/mockito.dart';

class FakeAuth extends Fake implements FirebaseAuth {
  bool signInCalled = false;
  bool signOutCalled = false;
  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    signInCalled = true;
    return MockUserCredential();
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
}
