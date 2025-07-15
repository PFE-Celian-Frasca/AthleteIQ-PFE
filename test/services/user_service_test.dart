import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

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
    expect(await firestore.collection('users').doc('id').get(), isA<DocumentSnapshot>().having((d) => d.exists, 'exists', false));
  });
}
