import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/parcours_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';

class FakeStorageRef extends Fake implements Reference {
  @override
  Future<void> delete() async {}
  @override
  UploadTask putString(String data,
      {PutStringFormat format = PutStringFormat.raw,
      SettableMetadata? metadata}) =>
      FakeUploadTask();
  @override
  Future<String> getDownloadURL() async => 'url';
}

class FakeUploadTask extends Fake implements UploadTask {
  @override
  Future<TaskSnapshot> whenComplete(void Function() action) async {
    action();
    return FakeTaskSnapshot();
  }
}

class FakeTaskSnapshot extends Fake implements TaskSnapshot {
  @override
  Reference get ref => FakeStorageRef();
}

class FakeStorage extends Fake implements FirebaseStorage {
  @override
  Reference ref([String? path]) => FakeStorageRef();
}

class FakeUserRepo extends Fake implements UserRepository {
  bool called = false;
  @override
  Future<void> toggleFavoriteParcours(
      String userId, String parcoursId, bool isFav) async {
    called = true;
  }
}

class FakeRef extends Fake implements Ref {
  final repo = FakeUserRepo();
  @override
  T read<T>(ProviderListenable<T> provider) {
    if (identical(provider, userRepositoryProvider)) {
      return repo as T;
    }
    throw UnimplementedError();
  }
}

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

  test('update and delete parcours', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final ref = FakeRef();
    final service = ParcoursService(firestore, storage, ref);

    final parcours = ParcoursModel(
      id: 'pid',
      owner: 'o',
      title: 't',
      type: ParcourVisibility.public,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
    );
    await firestore.collection('parcours').doc('pid').set(parcours.toJson());

    await service.updateParcours(parcours.copyWith(title: 'new'));
    expect((await firestore.collection('parcours').doc('pid').get()).data()!['title'], 'new');

    await firestore.collection('users').doc('u').set({'fav': ['pid']});
    await service.deleteParcours('pid');
    expect(await firestore.collection('parcours').doc('pid').get(), isA<DocumentSnapshot>().having((d) => d.exists, 'exists', false));
  });
}
