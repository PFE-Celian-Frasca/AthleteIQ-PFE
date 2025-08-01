import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/group/group_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_iq/models/message/last_message_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import '../mocks/firebase_mocks.dart';
import '../mocks/failing_mocks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestGroupRepository extends GroupRepository {
  TestGroupRepository(super.firestore);
  GroupModel? updated;
  @override
  Future<void> updateGroupDataInFireStore(GroupModel groupModel) async {
    updated = groupModel;
  }
}

void main() {
  test('addMemberToGroup adds member id', () async {
    final repo = TestGroupRepository(MockFirebaseFirestore());
    final group = GroupModel.empty();
    final user = UserModel(id: 'u1', pseudo: 'p', email: 'e', sex: 'M', createdAt: DateTime.now());

    await repo.addMemberToGroup(groupMember: user, groupModel: group);
    expect(repo.updated!.membersUIDs.contains('u1'), isTrue);
  });

  test('addMemberToAdmins adds admin id', () async {
    final repo = TestGroupRepository(MockFirebaseFirestore());
    final group = GroupModel.empty();
    final user = UserModel(id: 'u1', pseudo: 'p', email: 'e', sex: 'M', createdAt: DateTime.now());

    await repo.addMemberToAdmins(groupAdmin: user, groupModel: group);
    expect(repo.updated!.adminsUIDs.contains('u1'), isTrue);
  });

  test('removeGroupMember removes member and admin id', () async {
    final repo = TestGroupRepository(MockFirebaseFirestore());
    final group = GroupModel.empty().copyWith(membersUIDs: ['u1'], adminsUIDs: ['u1']);
    final user = UserModel(id: 'u1', pseudo: 'p', email: 'e', sex: 'M', createdAt: DateTime.now());

    await repo.removeGroupMember(groupMember: user, groupModel: group);
    expect(repo.updated!.membersUIDs.contains('u1'), isFalse);
    expect(repo.updated!.adminsUIDs.contains('u1'), isFalse);
  });

  test('removeGroupAdmin removes admin id', () async {
    final repo = TestGroupRepository(MockFirebaseFirestore());
    final group = GroupModel.empty().copyWith(adminsUIDs: ['u1']);
    final user = UserModel(id: 'u1', pseudo: 'p', email: 'e', sex: 'M', createdAt: DateTime.now());

    await repo.removeGroupAdmin(groupAdmin: user, groupModel: group);
    expect(repo.updated!.adminsUIDs.contains('u1'), isFalse);
  });

  test('setGroupModel delegates to updateGroupDataInFireStore', () async {
    final repo = TestGroupRepository(MockFirebaseFirestore());
    final group = GroupModel.empty();

    await repo.setGroupModel(group);
    expect(repo.updated, isNotNull);
  });

  test('updateGroupDataInFireStore updates Firestore document', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = GroupRepository(firestore);
    final group = GroupModel.empty().copyWith(groupId: 'gid', groupName: 'name');
    await firestore.collection('groups').doc('gid').set(group.toJson());
    final updated = group.copyWith(groupName: 'new');
    await repo.updateGroupDataInFireStore(updated);
    final doc = await firestore.collection('groups').doc('gid').get();
    expect(doc.data()!['groupName'], 'new');
  });

  test('createGroup adds document and calls onSuccess', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = GroupRepository(firestore);
    var success = false;
    final model = GroupModel.empty().copyWith(creatorUID: 'u');
    await repo.createGroup(
      newGroupModel: model,
      fileImage: null,
      onSuccess: () => success = true,
      onFail: (_) {},
    );
    final docs = await firestore.collection('groups').get();
    expect(docs.docs, isNotEmpty);
    expect(success, isTrue);
  });

  test('getPrivateGroupsStream filters by member and privacy', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = GroupRepository(firestore);
    final group = GroupModel.empty().copyWith(groupId: 'g', membersUIDs: ['u'], isPrivate: true);
    await firestore.collection('groups').doc('g').set(group.toJson());
    final result = await repo.getPrivateGroupsStream(userId: 'u').first;
    expect(result.length, 1);
  });

  test('getPublicGroupsStream returns public groups', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = GroupRepository(firestore);
    final group = GroupModel.empty().copyWith(groupId: 'g', isPrivate: false);
    await firestore.collection('groups').doc('g').set(group.toJson());
    final result = await repo.getPublicGroupsStream(userId: 'u').first;
    expect(result.length, 1);
  });

  test('getGroupsStream returns user groups', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = GroupRepository(firestore);
    final group = GroupModel.empty().copyWith(groupId: 'g', membersUIDs: ['u']);
    await firestore.collection('groups').doc('g').set(group.toJson());
    final result = await repo.getGroupsStream('u').first;
    expect(result.first.groupId, 'g');
  });

  test('getChatsListStream returns chat list', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = GroupRepository(firestore);
    final chat = LastMessageModel(
      senderUID: 'u',
      contactUID: 'c',
      contactName: 'n',
      contactImage: '',
      message: 'm',
      messageType: MessageEnum.text,
      timeSent: DateTime.now(),
      isSeen: false,
    );
    await firestore.collection('users').doc('u').collection('chats').doc('c').set(chat.toJson());
    final result = await repo.getChatsListStream('u').first;
    expect(result.first.message, 'm');
  });

  test('deleteAllGroupsForUser deletes owned groups and leaves others', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = GroupRepository(firestore);
    final own = GroupModel.empty().copyWith(groupId: 'g1', adminsUIDs: ['u'], membersUIDs: ['u']);
    final other = GroupModel.empty().copyWith(
      groupId: 'g2',
      adminsUIDs: ['u', 'x'],
      membersUIDs: ['u', 'x'],
    );
    await firestore.collection('groups').doc('g1').set(own.toJson());
    await firestore.collection('groups').doc('g2').set(other.toJson());
    await repo.deleteAllGroupsForUser('u');
    final doc1 = await firestore.collection('groups').doc('g1').get();
    final doc2 = await firestore.collection('groups').doc('g2').get();
    expect(doc1.exists, isFalse);
    expect(doc2.data()!['membersUIDs'], isNot(contains('u')));
    expect(doc2.data()!['adminsUIDs'], isNot(contains('u')));
  });

  test('methods throw formatted exceptions on Firestore failure', () async {
    final firestore = ThrowFirestore();
    final repo = GroupRepository(firestore);
    final group = GroupModel.empty().copyWith(groupId: 'g');
    await expectLater(repo.updateGroupDataInFireStore(group), throwsException);
    await expectLater(repo.setGroupModel(group), throwsException);
    var failed = false;
    await repo.createGroup(
      newGroupModel: group,
      fileImage: null,
      onSuccess: () {},
      onFail: (_) => failed = true,
    );
    expect(failed, isTrue);
    expect(() => repo.getPrivateGroupsStream(userId: 'u'), throwsException);
    expect(() => repo.getPublicGroupsStream(userId: 'u'), throwsException);
    expect(() => repo.getGroupsStream('u'), throwsException);
    expect(() => repo.getChatsListStream('u'), throwsException);
    await expectLater(repo.deleteAllGroupsForUser('u'), throwsException);
  });

  test('provider returns repository with override', () {
    final firestore = FakeFirebaseFirestore();
    final container = ProviderContainer(
      overrides: [groupRepositoryProvider.overrideWithValue(GroupRepository(firestore))],
    );
    expect(container.read(groupRepositoryProvider), isA<GroupRepository>());
  });
}
