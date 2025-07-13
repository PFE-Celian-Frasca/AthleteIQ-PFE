import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/parcours_service.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeStorage extends Fake implements FirebaseStorage {}

class FakeRef extends Fake implements Ref {}

void main() {
  test('getParcoursById returns ParcoursModel when exists', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('parcours').doc('id').set({'dummy': 1});
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
    await firestore.collection('parcours').doc('id').set(parcours.toJson());

    final result = await service.getParcoursById('id');
    expect(result.toJson(), parcours.toJson());
  });
}
