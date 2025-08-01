import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeRef extends Fake implements Reference {
  @override
  Future<void> delete() async {}
}

class FakeStorage extends Fake implements FirebaseStorage {
  @override
  Reference ref([String? path]) => FakeRef();
}

class TestGroupService extends GroupService {
  // ignore: use_super_parameters
  TestGroupService(FirebaseFirestore f, FirebaseStorage s) : super(f, s);
  @override
  Future<String> uploadGroupImage(String groupId, File imageFile) async => 'url';
}

void main() {
  test('addMemberToGroup updates members', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('groups').doc('gid').set({'members': <String>[]});
    final storage = FakeStorage();
    final service = TestGroupService(firestore, storage);
    await service.addMemberToGroup('gid', 'uid');
    final doc = await firestore.collection('groups').doc('gid').get();
    expect(doc.data()!['members'], contains('uid'));
  });

  test('provider and stream methods', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final service = TestGroupService(firestore, storage);

    final group = GroupModel.empty().copyWith(
      creatorUID: 'u1',
      groupId: 'gid',
      groupName: 'public',
      groupDescription: 'd',
      isPrivate: false,
      membersUIDs: const ['u1'],
      adminsUIDs: const [],
      createdAt: DateTime.now(),
    );
    final data = group.toJson()..['members'] = group.membersUIDs;
    await firestore.collection('groups').doc('gid').set(data);

    final container = ProviderContainer(overrides: [groupService.overrideWithValue(service)]);
    expect(container.read(groupService), service);

    expect(await service.getUserGroupsStream('u1').first, isA<List<GroupModel>>());
    expect(await service.listPublicGroupsStream().first, isA<List<GroupModel>>());
    expect(await service.getGroupDetailsStream('gid').first, isA<GroupModel>());
    await service.toggleGroupNotifications('gid', true);
  });

  test('other group operations execute', () async {
    final firestore = FakeFirebaseFirestore();
    final storage = FakeStorage();
    final service = TestGroupService(firestore, storage);

    final group = GroupModel.empty().copyWith(
      creatorUID: 'c',
      groupName: 'name',
      groupDescription: 'desc',
      groupId: '',
      groupImage: '',
      lastMessage: '',
      senderUID: 's',
      messageType: MessageEnum.text,
      messageId: '',
      timeSent: DateTime.now(),
      createdAt: DateTime.now(),
      isPrivate: false,
      editSettings: true,
      membersUIDs: [],
      adminsUIDs: [],
    );

    await service.createGroup(group);
    final id = (await firestore.collection('groups').get()).docs.first.id;

    final file = File('${Directory.systemTemp.path}/f');
    await file.writeAsString('x');
    await service.updateGroupImage(id, file);

    await service.updateGroup(group.copyWith(groupId: id, groupName: 'new'));
    final fetched = await service.getUserGroupById(id);
    expect(fetched.groupName, 'new');

    await firestore.collection('groups').doc(id).update({'members': <String>[]});
    await service.addMemberToGroup(id, 'u1');
    await service.removeMemberFromGroup(id, 'u1');

    await service.updateGroupPrivacySettings(id, true);
    await service.moderateGroupContent(id, 'mid', true);

    expect(await service.listAllGroups(), isNotEmpty);
    expect(await service.searchGroups('new'), isNotEmpty);

    final msgRef = firestore.collection('groups').doc(id).collection('messages').doc('mid');
    await msgRef.set(MessageModel(
      senderUID: 's',
      senderName: 'n',
      senderImage: '',
      message: 'm',
      messageType: MessageEnum.text,
      timeSent: DateTime.now(),
      messageId: 'mid',
      isSeen: false,
      repliedMessage: '',
      repliedTo: '',
      repliedMessageType: MessageEnum.text,
      reactions: const [],
      isSeenBy: const [],
      deletedBy: const [],
    ).toJson());

    final stream = service.getGroupMessagesStream(id);
    expect(await stream.first, isNotEmpty);

    await service.addReaction(id, 'mid', 'u', '👍');
    await service.removeReaction(id, 'mid', 'u');
    await service.markMessageAsRead(id, 'mid', 'u');

    await service.deleteGroup(id);
    expect((await firestore.collection('groups').get()).docs, isEmpty);
  });
}
