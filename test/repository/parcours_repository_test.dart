import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/enums/enums.dart';
import "package:mockito/mockito.dart";
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mocks/firebase_mocks.dart';

class FakeDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  Map<Object?, Object?>? updatedData;
  Map<String, dynamic>? dataToReturn;
  bool getCalled = false;

  @override
  Future<void> update(Map<Object?, Object?> data) async {
    updatedData = data;
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    getCalled = true;
    return FakeDocumentSnapshot(dataToReturn);
  }
}

class FakeCollection extends Fake implements CollectionReference<Map<String, dynamic>> {
  final FakeDoc docRef = FakeDoc();
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) {
    return docRef;
  }
}

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic>? _data;
  FakeDocumentSnapshot(this._data);

  @override
  bool get exists => _data != null;

  @override
  Map<String, dynamic>? data() => _data;
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

  test('updateParcours updates Firestore document', () async {
    final firestore = FakeFirestore();
    final storage = MockFirebaseStorage();
    final repo = ParcoursRepository(firestore, storage);

    final parcours = ParcoursModel(
      id: 'id',
      owner: 'o',
      title: 't',
      type: ParcourVisibility.private,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
    );

    await repo.updateParcours(parcours);
    expect(firestore.collectionRef.docRef.updatedData, parcours.toJson());
  });

  test('getParcoursById returns ParcoursModel when document exists', () async {
    final firestore = FakeFirestore();
    final storage = MockFirebaseStorage();
    final repo = ParcoursRepository(firestore, storage);

    final parcours = ParcoursModel(
      id: 'id',
      owner: 'o',
      title: 't',
      type: ParcourVisibility.private,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
    );
    firestore.collectionRef.docRef.dataToReturn = parcours.toJson();

    final result = await repo.getParcoursById('id');
    expect(result.toJson(), parcours.toJson());
    expect(firestore.collectionRef.docRef.getCalled, isTrue);
  });
}
