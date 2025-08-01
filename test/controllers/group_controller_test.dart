import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/group/group_repository.dart';
import 'package:athlete_iq/view/community/chat-page/group_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repo;
  late GroupController controller;

  setUpAll(() {
    registerFallbackValue(GroupModel.empty());
    registerFallbackValue(UserModel(
      id: 'id',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    repo = MockGroupRepository();
    controller = GroupController(repo);
  });

  GroupModel group({String id = ''}) => GroupModel(
        creatorUID: 'c1',
        groupName: 'name',
        groupDescription: 'desc',
        groupImage: 'img',
        groupId: id,
        lastMessage: '',
        senderUID: 'c1',
        messageType: MessageEnum.text,
        messageId: 'm1',
        timeSent: DateTime.now(),
        createdAt: DateTime.now(),
        isPrivate: true,
        editSettings: false,
        membersUIDs: const [],
        adminsUIDs: const [],
      );

  UserModel user(String id) => UserModel(
        id: id,
        pseudo: 'p$id',
        email: '$id@mail.com',
        sex: 'M',
        createdAt: DateTime.now(),
      );

  test('setEditSettings updates state and repository when id not empty', () {
    controller = GroupController(repo);
    controller.state = group(id: 'g1');
    when(() => repo.updateGroupDataInFireStore(any())).thenAnswer((_) async {});

    controller.setEditSettings(true);

    expect(controller.state.editSettings, true);
    verify(() => repo.updateGroupDataInFireStore(controller.state)).called(1);
  });

  test('createGroup sets state and calls repository', () async {
    final newGroup = group();
    when(() => repo.createGroup(
        newGroupModel: any(named: 'newGroupModel'),
        fileImage: any(named: 'fileImage'),
        onSuccess: any(named: 'onSuccess'),
        onFail: any(named: 'onFail'))).thenAnswer((invocation) async {
      final onSuccess = invocation.namedArguments[const Symbol('onSuccess')] as VoidCallback;
      onSuccess();
    });

    bool success = false;
    await controller.createGroup(
      newGroupModel: newGroup,
      fileImage: null,
      onSuccess: () => success = true,
      onFail: (_) {},
    );
    expect(success, true);
  });

  test('addMemberToGroup updates members and calls repo', () async {
    controller.state = group(id: 'g1');
    final member = user('u2');
    when(() => repo.addMemberToGroup(groupMember: member, groupModel: any(named: 'groupModel')))
        .thenAnswer((_) async {});

    await controller.addMemberToGroup(groupMember: member);

    expect(controller.state.membersUIDs.contains('u2'), true);
  });

  test('addMemberToAdmins updates admins and calls repo', () async {
    controller.state = group(id: 'g1');
    final admin = user('u2');
    when(() => repo.addMemberToAdmins(groupAdmin: admin, groupModel: any(named: 'groupModel')))
        .thenAnswer((_) async {});

    await controller.addMemberToAdmins(groupAdmin: admin);

    expect(controller.state.adminsUIDs.contains('u2'), true);
  });

  test('removeGroupMember removes member and admin', () async {
    controller.state = group(id: 'g1').copyWith(membersUIDs: ['u2'], adminsUIDs: ['u2']);
    final member = user('u2');
    when(() => repo.removeGroupMember(groupMember: member, groupModel: any(named: 'groupModel')))
        .thenAnswer((_) async {});

    await controller.removeGroupMember(groupMember: member);

    expect(controller.state.membersUIDs.contains('u2'), false);
  });

  test('removeGroupAdmin removes admin', () async {
    controller.state = group(id: 'g1').copyWith(adminsUIDs: ['u2']);
    final admin = user('u2');
    when(() => repo.removeGroupAdmin(groupAdmin: admin, groupModel: any(named: 'groupModel')))
        .thenAnswer((_) async {});

    await controller.removeGroupAdmin(groupAdmin: admin);

    expect(controller.state.adminsUIDs.contains('u2'), false);
  });

  test('changeGroupType toggles value and updates firestore', () {
    controller.state = group(id: 'g1');
    when(() => repo.updateGroupDataInFireStore(any())).thenAnswer((_) async {});
    controller.changeGroupType();
    expect(controller.state.isPrivate, false);
    verify(() => repo.updateGroupDataInFireStore(controller.state)).called(1);
  });

  test('streams delegate to repository', () {
    when(() => repo.getPrivateGroupsStream(userId: 'u1')).thenAnswer((_) => const Stream.empty());
    expect(controller.getPrivateGroupsStream(userId: 'u1'), isA<Stream<List<GroupModel>>>());

    when(() => repo.getPublicGroupsStream(userId: 'u1')).thenAnswer((_) => const Stream.empty());
    expect(controller.getPublicGroupsStream(userId: 'u1'), isA<Stream<List<GroupModel>>>());
  });
}
