import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/group_service.dart';

class FakeRef extends Fake implements Reference {
  bool putFileCalled = false;
  @override
  UploadTask putFile(File file, [SettableMetadata? metadata]) {
    putFileCalled = true;
    return FakeUploadTask();
  }

  @override
  Future<String> getDownloadURL() async {
    return 'url';
  }
}

class FakeStorage extends Fake implements FirebaseStorage {
  final FakeRef refObj = FakeRef();
  @override
  Reference ref([String? path]) => refObj;
}

class FakeUploadTask extends Fake implements UploadTask {}

void main() {
  test('addMemberToGroup updates members', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('groups').doc('gid').set({'members': <String>[]});
    final storage = FakeStorage();
    final service = GroupService(firestore, storage);
    await service.addMemberToGroup('gid', 'uid');
    final doc = await firestore.collection('groups').doc('gid').get();
    expect(doc.data()!['members'], contains('uid'));
  });
}
