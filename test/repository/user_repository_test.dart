import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import "../mocks/firebase_mocks.dart";

class FakeDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  bool updateCalled = false;
  Map<Object?, Object?>? updateData;
  @override
  Future<void> update(Map<Object?, Object?> data) async {
    updateCalled = true;
    updateData = data;
  }
}

class FakeCollection extends Fake implements CollectionReference<Map<String, dynamic>> {
  final FakeDoc docRef = FakeDoc();
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) => docRef;
}

class FakeFirestore extends Fake implements FirebaseFirestore {
  final FakeCollection collectionRef = FakeCollection();
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) => collectionRef;
}

void main() {
  test('isValidUrl returns true for valid url and false otherwise', () {
    final repo = UserRepository(MockFirebaseFirestore());
    expect(repo.isValidUrl('https://example.com'), isTrue);
    expect(repo.isValidUrl('not a url'), isTrue);
  });

  test('toggleFavoriteParcours updates user favorites', () async {
    final firestore = FakeFirestore();
    final repo = UserRepository(firestore);
    await repo.toggleFavoriteParcours('u', 'p', true);
    expect(firestore.collectionRef.docRef.updateCalled, isTrue);
    expect(firestore.collectionRef.docRef.updateData!.containsKey('fav'), isTrue);
  });
}
