import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/group_service.dart';

class FakeDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  bool updateCalled = false;
  Map<Object?, Object?>? updateData;
  bool setCalled = false;
  Map<String, dynamic>? setData;
  @override
  Future<void> update(Map<Object?, Object?> data) async {
    updateCalled = true;
    updateData = data;
  }

  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) async {
    setCalled = true;
    setData = data;
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
    final firestore = FakeFirestore();
    final storage = FakeStorage();
    final service = GroupService(firestore, storage);
    await service.addMemberToGroup('gid', 'uid');
    expect(firestore.collectionRef.docRef.updateCalled, isTrue);
  });
}
