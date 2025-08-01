import 'dart:async';
import 'dart:io';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../mocks/firebase_mocks.dart';
import '../mocks/failing_mocks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';

class FakeReference extends Fake implements Reference {
  FakeReference([this._path]);
  final String? _path;
  String? uploaded;
  bool deleted = false;
  String downloadURL = '';

  @override
  UploadTask putString(
    String data, {
    PutStringFormat format = PutStringFormat.raw,
    SettableMetadata? metadata,
  }) {
    uploaded = data;
    return FakeUploadTask(FakeTaskSnapshot(this));
  }

  @override
  Future<String> getDownloadURL() async => downloadURL;

  @override
  Future<void> delete() async {
    deleted = true;
  }

  @override
  Reference child(String path) => this;

  @override
  String get fullPath => _path ?? '';
}

class FakeStorage extends Fake implements FirebaseStorage {
  FakeReference refInstance = FakeReference();
  String? lastPath;

  @override
  Reference ref([String? path]) {
    lastPath = path;
    return refInstance;
  }
}

class FakeTaskSnapshot extends Fake implements TaskSnapshot {
  FakeTaskSnapshot(this._ref);
  final Reference _ref;

  @override
  Reference get ref => _ref;
}

class FakeUploadTask extends Fake implements UploadTask {
  FakeUploadTask(this._snapshot);
  final TaskSnapshot _snapshot;

  @override
  Future<R> then<R>(FutureOr<R> Function(TaskSnapshot) onValue, {Function? onError}) {
    try {
      return Future.value(onValue(_snapshot));
    } catch (e, s) {
      if (onError != null) return Future.error(e, s);
      rethrow;
    }
  }
}

class TestParcoursRepository extends ParcoursRepository {
  TestParcoursRepository(super.db, super.storage);
  List<LocationDataModel> gps = const [LocationDataModel(latitude: 1, longitude: 2)];

  @override
  Future<List<LocationDataModel>> getParcoursGPSData(String parcoursId) async => gps;
}

void main() {
  test('updateParcoursById updates Firestore document', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('parcours').doc('id').set({});
    final storage = MockFirebaseStorage();

    final repo = TestParcoursRepository(firestore, storage);
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
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);

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

  test('addParcours stores file and document', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    final parcours = ParcoursModel(
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
    final loc = [const LocationDataModel(latitude: 1, longitude: 2)];
    await repo.addParcours(parcours, loc);
    final docs = await firestore.collection('parcours').get();
    expect(docs.docs.length, 1);
    expect(storage.refInstance.uploaded, isNotNull);
  });

  test('deleteParcours removes firestore doc and storage file', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    await firestore.collection('parcours').doc('p').set({'a': 1});
    await repo.deleteParcours('p');
    final doc = await firestore.collection('parcours').doc('p').get();
    expect(doc.exists, isFalse);
    expect(storage.refInstance.deleted, isTrue);
  });

  test('deleteAllParcoursForUser removes all user parcours', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    await firestore.collection('parcours').doc('1').set({'owner': 'u'});
    await firestore.collection('parcours').doc('2').set({'owner': 'u'});
    await repo.deleteAllParcoursForUser('u');
    final snapshot = await firestore.collection('parcours').get();
    expect(snapshot.docs, isEmpty);
  });

  test('getParcoursGPSData loads location list from url', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final server = await HttpServer.bind('localhost', 0);
    server.listen((req) async {
      req.response.headers.contentType = ContentType.json;
      req.response.write('[{"latitude":1,"longitude":2}]');
      await req.response.close();
    });
    storage.refInstance.downloadURL = 'http://localhost:${server.port}/data.json';
    final repo = ParcoursRepository(firestore, storage);
    final result = await repo.getParcoursGPSData('id');
    expect(result.first.latitude, 1);
    await server.close(force: true);
  });

  test('getParcoursWithGPSData combines data and gps', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final server = await HttpServer.bind('localhost', 0);
    server.listen((req) async {
      req.response.headers.contentType = ContentType.json;
      req.response.write('[{"latitude":1,"longitude":2}]');
      await req.response.close();
    });
    storage.refInstance.downloadURL = 'http://localhost:${server.port}/d.json';
    final repo = ParcoursRepository(firestore, storage);
    final parcours = ParcoursModel(
      id: 'p',
      owner: 'o',
      title: 't',
      type: ParcourVisibility.public,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
      parcoursDataUrl: 'url',
    );
    await firestore.collection('parcours').doc('p').set(parcours.toJson());
    final result = await repo.getParcoursWithGPSData('p');
    expect(result.parcours.id, 'p');
    expect(result.gpsData.length, 1);
    await server.close(force: true);
  });

  test('streamParcoursWithGPSData emits updates', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final server = await HttpServer.bind('localhost', 0);
    server.listen((req) async {
      req.response.headers.contentType = ContentType.json;
      req.response.write('[{"latitude":1,"longitude":2}]');
      await req.response.close();
    });
    storage.refInstance.downloadURL = 'http://localhost:${server.port}/d.json';
    final repo = ParcoursRepository(firestore, storage);
    final parcours = ParcoursModel(
      id: 'p',
      owner: 'o',
      title: 't',
      type: ParcourVisibility.public,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
      parcoursDataUrl: 'url',
    );
    await firestore.collection('parcours').doc('p').set(parcours.toJson());
    final sub = repo.streamParcoursWithGPSData('p');
    final first = await sub.first;
    expect(first.parcours.id, 'p');
    await server.close(force: true);
  });

  test('getPublicParcoursStream filters by type', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    final parcours = ParcoursModel(
      id: 'p',
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
    await firestore.collection('parcours').doc('p').set(parcours.toJson());
    final result = await repo.getPublicParcoursStream().first;
    expect(result.length, 1);
  });

  test('getPrivateParcoursStream returns private parcours of user', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    final parcours = ParcoursModel(
      id: 'p',
      owner: 'u',
      title: 't',
      type: ParcourVisibility.private,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
    );
    await firestore.collection('parcours').doc('p').set(parcours.toJson());
    final result = await repo.getPrivateParcoursStream('u').first;
    expect(result.length, 1);
  });

  test('getSharedParcoursStream combines owner and shared', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    final ownerParcours = ParcoursModel(
      id: 'p1',
      owner: 'u',
      title: 't',
      type: ParcourVisibility.shared,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
    );
    final shared = ownerParcours.copyWith(id: 'p2', owner: 'x', shareTo: ['u']);
    await firestore.collection('parcours').doc('p1').set(ownerParcours.toJson());
    await firestore.collection('parcours').doc('p2').set(shared.toJson());
    final result = await repo.getSharedParcoursStream('u').first;
    expect(result.length, 2);
  });

  test('getFavoritesParcoursStream returns user favorites', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    final parcours = ParcoursModel(
      id: 'p',
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
    await firestore.collection('parcours').doc('p').set(parcours.toJson());
    final user = UserModel(
      id: 'u',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
      fav: const ['p'],
    );
    await firestore.collection('users').doc('u').set(user.toJson());
    final result = await repo.getFavoritesParcoursStream('u').first;
    expect(result.length, 1);
  });

  test('getParcoursStream combines all streams', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final repo = TestParcoursRepository(firestore, storage);
    final publicParcours = ParcoursModel(
      id: 'pub',
      owner: 'u',
      title: 't',
      type: ParcourVisibility.public,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(),
      createdAt: DateTime.now(),
      vm: 0,
      totalDistance: 0,
    );
    final privateParcours = publicParcours.copyWith(id: 'priv', type: ParcourVisibility.private);
    final sharedParcours = publicParcours.copyWith(
      id: 's',
      type: ParcourVisibility.shared,
      owner: 'x',
      shareTo: ['u'],
    );
    await firestore.collection('parcours').doc('pub').set(publicParcours.toJson());
    await firestore.collection('parcours').doc('priv').set(privateParcours.toJson());
    await firestore.collection('parcours').doc('s').set(sharedParcours.toJson());
    final user = UserModel(
      id: 'u',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
      fav: const ['pub'],
    );
    await firestore.collection('users').doc('u').set(user.toJson());
    final result = await repo.getParcoursStream('u').first;
    expect(result.length, 4);
  });

  test('methods throw formatted exceptions on failure', () async {
    final firestore = ThrowFirestore();
    final storage = ThrowStorage();
    final repo = ParcoursRepository(firestore, storage);
    final parcours = ParcoursModel(
      id: 'id',
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
    await expectLater(repo.addParcours(parcours, const []), throwsException);
    await expectLater(repo.deleteParcours('id'), throwsException);
    await expectLater(repo.deleteAllParcoursForUser('u'), throwsException);
    await expectLater(repo.updateParcours(parcours), throwsException);
    await expectLater(repo.updateParcoursById('id', {}), throwsException);
    await expectLater(repo.getParcoursById('id'), throwsException);
    await expectLater(repo.getParcoursGPSData('id'), throwsException);
    await expectLater(repo.streamParcoursWithGPSData('id').first, throwsA(isNotNull));
    expect(() => repo.getPublicParcoursStream(), throwsException);
    expect(() => repo.getPrivateParcoursStream('u'), throwsException);
    expect(() => repo.getSharedParcoursStream('u'), throwsException);
    expect(() => repo.getFavoritesParcoursStream('u'), throwsException);
    expect(() => repo.getParcoursStream('u'), throwsException);
  });

  test('providers return overridden instances', () {
    final firestore = FakeFirebaseFirestore();
    final storage = MockFirebaseStorage();
    final container = ProviderContainer(
      overrides: [
        firebaseFirestoreProvider.overrideWithValue(firestore),
        firebaseStorageProvider.overrideWithValue(storage),
        parcoursRepositoryProvider.overrideWith((ref) => ParcoursRepository(firestore, storage)),
      ],
    );
    expect(container.read(firebaseStorageProvider), storage);
    expect(container.read(parcoursRepositoryProvider), isA<ParcoursRepository>());
  });
}
