import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/parcours_service.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic>? _data;
  FakeDocumentSnapshot(this._data);
  @override
  bool get exists => _data != null;
  @override
  Map<String, dynamic>? data() => _data;
}

class FakeDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  Map<String, dynamic>? dataToReturn;
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    return FakeDocumentSnapshot(dataToReturn);
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

class FakeStorage extends Fake implements FirebaseStorage {}

class FakeRef extends Fake implements Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('getParcoursById returns ParcoursModel when exists', () async {
    final firestore = FakeFirestore();
    final storage = FakeStorage();
    final ref = FakeRef();
    final service = ParcoursService(firestore, storage, ref);

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

    final result = await service.getParcoursById('id');
    expect(result.toJson(), parcours.toJson());
  });
}
