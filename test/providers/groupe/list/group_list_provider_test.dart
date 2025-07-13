import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/providers/groupe/list/group_list_provider.dart';
import 'package:athlete_iq/services/group_service.dart';

class _FakeGroupService implements GroupService {
  _FakeGroupService(this._groups);

  final List<GroupModel> _groups;

  @override
  Stream<List<GroupModel>> getUserGroupsStream(String userId) =>
      Stream.value(_groups);

  // Si GroupService a d’autres méthodes, on les ignore pour ce test :
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('groupListStreamProvider renvoie la liste de groupes attendue', () async {
    // 1. Données de test
    final groups = [
      GroupModel(
        creatorUID: '123',
        groupName: 'Group 1',
        groupDescription: 'Description 1',
        groupImage: 'image_url_1',
        groupId: '1',
        lastMessage: 'Hello',
        senderUID: '123',
        messageType: MessageEnum.text,
        messageId: 'msg_1',
        timeSent: DateTime(2023, 10, 1, 12),
        createdAt: DateTime(2023, 10, 1, 10),
        isPrivate: true,
        editSettings: true,
        membersUIDs: ['123', '456'],
        adminsUIDs: ['123'],
      ),
    ];

    // 2. Container Riverpod avec override du provider `groupService`
    final container = ProviderContainer(overrides: [
      groupService.overrideWithValue(_FakeGroupService(groups)),
    ]);
    addTearDown(container.dispose);

    // 3. Lecture de la première valeur émise par le StreamProvider
    final result =
    await container.read(groupListStreamProvider('123').future);

    // 4. Vérification
    expect(result, equals(groups));
  });
}