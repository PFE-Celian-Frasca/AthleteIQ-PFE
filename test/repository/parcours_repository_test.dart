import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import "package:mockito/mockito.dart";
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mocks/firebase_mocks.dart';

class FakeDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  Map<Object?, Object?>? updatedData;
  @override
  Future<void> update(Map<Object?, Object?> data) async {
    updatedData = data;
  }
}

class FakeCollection extends Fake implements CollectionReference<Map<String, dynamic>> {
  final FakeDoc docRef = FakeDoc();
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) {
    return docRef;
  }
}

class FakeFirestore extends Fake implements FirebaseFirestore {
  final FakeCollection collectionRef = FakeCollection();
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return collectionRef;
  }
}

void main() {
  test('updateParcoursById updates Firestore document', () async {
    final firestore = FakeFirestore();
    final storage = MockFirebaseStorage();

    final repo = ParcoursRepository(firestore, storage);
    await repo.updateParcoursById('id', {'a': 1});

    expect(firestore.collectionRef.docRef.updatedData, {'a': 1});
  });
}
