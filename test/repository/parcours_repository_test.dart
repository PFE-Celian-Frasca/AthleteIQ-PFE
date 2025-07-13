import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../mocks/firebase_mocks.dart';

void main() {
  test('updateParcoursById updates Firestore document', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('parcours').doc('id').set({});
    final storage = MockFirebaseStorage();

    final repo = ParcoursRepository(firestore, storage);
    await repo.updateParcoursById('id', {'a': 1});

    final doc = await firestore.collection('parcours').doc('id').get();
    expect(doc.data()!['a'], 1);
  });

  test('updateParcours updates Firestore document', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('parcours').doc('id').set({});
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
    final doc = await firestore.collection('parcours').doc('id').get();
    expect(doc.data(), parcours.toJson());
  });

  test('getParcoursById returns ParcoursModel when document exists', () async {
    final firestore = FakeFirebaseFirestore();
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
    await firestore.collection('parcours').doc('id').set(parcours.toJson());

    final result = await repo.getParcoursById('id');
    expect(result.toJson(), parcours.toJson());
  });
}
