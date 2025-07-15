import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeRef extends Fake implements Reference {
  @override
  UploadTask putFile(File file, [SettableMetadata? metadata]) {
    return FakeUploadTask();
  }

  @override
  Future<String> getDownloadURL() async => 'url';

  @override
  Future<void> delete() async {}
}

class FakeUploadTask extends Fake implements UploadTask {}

class TestUserService extends UserService {
  // ignore: use_super_parameters
  TestUserService(FirebaseFirestore f, FirebaseStorage s) : super(f, s);
  @override
  Future<String> uploadUserProfileImage(String userId, File imageFile) async => 'url';
}

class FakeStorage extends Fake implements FirebaseStorage {
  final FakeRef refObj = FakeRef();
  @override
  Reference ref([String? path]) => refObj;
}

void main() {
  test('provider exposes UserService', () {
    final container = ProviderContainer(overrides: [
      userServiceProvider.overrideWithValue(TestUserService(FakeFirebaseFirestore(), FakeStorage()))
    ]);
    expect(container.read(userServiceProvider), isA<UserService>());
  });
  test('checkPseudoExists returns true when user exists', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').add({'pseudo': 'pseudo'});
    final storage = FakeStorage();
    final service = TestUserService(firestore, storage);

    final exists = await service.checkPseudoExists('pseudo');
    expect(exists, isTrue);
  });

  test('crud and search operations run', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final service = TestUserService(firestore, storage);

    final user = UserModel(
      id: 'id',
      pseudo: 'p',
      email: 'e@e.com',
      sex: 'M',
      createdAt: DateTime.now(),
    );
    await service.createUser(user);
    expect((await service.getUserData('id')).pseudo, 'p');

    final file = File('${Directory.systemTemp.path}/f')..writeAsStringSync('x');
    await service.updateUserImage('id', file);

    await service.updateUserData(user.copyWith(pseudo: 'p2'));
    expect((await service.getUserData('id')).pseudo, 'p2');

    await service.blockUser('id', 'b');
    await service.unblockUser('id', 'b');

    await service.toggleFavoriteParcours('id', 'pid', true);
    await service.toggleFavoriteParcours('id', 'pid', false);

    final list = await service.searchUsers('p2');
    expect(list.length, 1);

    await service.deleteUser('id');
    expect(await firestore.collection('users').doc('id').get(),
        isA<DocumentSnapshot>().having((d) => d.exists, 'exists', false));
  });

  test('streams and pagination work', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final service = TestUserService(firestore, storage);

    for (var i = 0; i < 11; i++) {
      await firestore.collection('users').doc('u$i').set({
        'id': 'u$i',
        'pseudo': 'p$i',
        'email': 'e$i@e.com',
        'sex': 'M',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    expect(await service.listAllUsersStream().first, hasLength(11));

    final firstPage = await service.loadMoreUsers(limit: 10);
    expect(firstPage, hasLength(10));
    final secondPage = await service.loadMoreUsers(limit: 10);
    expect(secondPage, hasLength(1));

    service.resetPagination();
    expect(await service.loadMoreUsers(limit: 5), hasLength(5));

    await firestore.collection('users').doc('stream').set({
      'id': 'stream',
      'pseudo': 'stream',
      'email': 's@s.com',
      'sex': 'M',
      'createdAt': DateTime.now().toIso8601String(),
    });
    expect(await service.getUserStream('stream').first, isA<UserModel>());
    expect(() => service.getUserStream('none').first, throwsException);
  });
}
