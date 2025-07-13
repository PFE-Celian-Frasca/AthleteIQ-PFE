import 'package:athlete_iq/providers/groupe/group_details/group_details_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/services/group_service.dart';

class _FakeGroupService implements GroupService {
  _FakeGroupService(this._group);

  final GroupModel _group;

  @override
  Stream<GroupModel> getGroupDetailsStream(String groupId) =>
      Stream.value(_group);

  // Les autres méthodes de GroupService sont ignorées
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('groupDetailsProvider renvoie le GroupModel attendu', () async {
    // 1. Données de référence
    const groupId = 'group_1';
    final group = GroupModel(
      creatorUID: '123',
      groupName: 'Group 1',
      groupDescription: 'Description',
      groupImage: 'img.png',
      groupId: groupId,
      lastMessage: 'Hello',
      senderUID: '123',
      messageType: MessageEnum.text,
      messageId: 'msg_1',
      timeSent: DateTime(2024, 1, 1, 12),
      createdAt: DateTime(2024, 1, 1, 10),
      isPrivate: false,
      editSettings: false,
      membersUIDs: ['123', '456'],
      adminsUIDs: ['123'],
    );

    // 2. Container avec override du provider groupService
    final container = ProviderContainer(overrides: [
      groupService.overrideWithValue(_FakeGroupService(group)),
    ]);
    addTearDown(container.dispose);

    // 3. Lecture de la première valeur émise
    final result = await container.read(groupDetailsProvider(groupId).future);

    // 4. Assertion
    expect(result, equals(group));
  });
}