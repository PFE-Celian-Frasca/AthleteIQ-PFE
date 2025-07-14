import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class ThrowFirestore extends Fake implements FirebaseFirestore {
  final Exception exception;
  ThrowFirestore([Exception? exception]) : exception = exception ?? Exception('firestore error');

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    throw exception;
  }
}

class ThrowStorage extends Fake implements FirebaseStorage {
  final Exception exception;
  ThrowStorage([Exception? exception]) : exception = exception ?? Exception('storage error');

  @override
  Reference ref([String? path]) {
    throw exception;
  }
}

class ThrowAuth extends Fake implements FirebaseAuth {
  final Exception exception;
  ThrowAuth([Exception? exception]) : exception = exception ?? Exception('auth error');

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) {
    throw exception;
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) {
    throw exception;
  }

  @override
  Future<void> signOut() => Future.error(exception);

  @override
  Future<void> sendPasswordResetEmail({required String email, ActionCodeSettings? actionCodeSettings}) => Future.error(exception);

  @override
  User? get currentUser => ThrowUser(exception);

  @override
  Stream<User?> authStateChanges() => Stream<User?>.error(exception);
}

class ThrowUser extends Fake implements User {
  final Exception exception;
  ThrowUser(this.exception);

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? settings]) => Future.error(exception);

  @override
  Future<void> verifyBeforeUpdateEmail(String email, [ActionCodeSettings? settings]) => Future.error(exception);

  @override
  Future<void> updatePassword(String password) => Future.error(exception);

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) => Future.error(exception);

  @override
  Future<void> delete() => Future.error(exception);
}
