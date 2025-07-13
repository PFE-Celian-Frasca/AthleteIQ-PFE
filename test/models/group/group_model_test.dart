import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/enums/enums.dart';

void main() {
  group('GroupModel', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      final group = GroupModel(
        creatorUID: '123',
        groupName: 'Test Group',
        groupDescription: 'Description of the group',
        groupImage: 'image_url',
        groupId: 'group_1',
        lastMessage: 'Hello World',
        senderUID: '456',
        messageType: MessageEnum.text,
        messageId: 'msg_1',
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        createdAt: DateTime.parse('2023-10-01T10:00:00Z'),
        isPrivate: true,
        editSettings: false,
        membersUIDs: ['123', '456'],
        adminsUIDs: ['123'],
      );

      expect(group.creatorUID, '123');
      expect(group.groupName, 'Test Group');
      expect(group.groupDescription, 'Description of the group');
      expect(group.groupImage, 'image_url');
      expect(group.groupId, 'group_1');
      expect(group.lastMessage, 'Hello World');
      expect(group.senderUID, '456');
      expect(group.messageType, MessageEnum.text);
      expect(group.messageId, 'msg_1');
      expect(group.timeSent, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(group.createdAt, DateTime.parse('2023-10-01T10:00:00Z'));
      expect(group.isPrivate, true);
      expect(group.editSettings, false);
      expect(group.membersUIDs, ['123', '456']);
      expect(group.adminsUIDs, ['123']);
    });

    // Vérifie le comportement avec un groupe vide
    test('handles empty group correctly', () {
      final group = GroupModel.empty();

      expect(group.creatorUID, '');
      expect(group.groupName, '');
      expect(group.groupDescription, '');
      expect(group.groupImage, '');
      expect(group.groupId, '');
      expect(group.lastMessage, '');
      expect(group.senderUID, '');
      expect(group.messageType, MessageEnum.text);
      expect(group.messageId, '');
      expect(group.timeSent.isBefore(DateTime.now()), true);
      expect(group.createdAt.isBefore(DateTime.now()), true);
      expect(group.isPrivate, true);
      expect(group.editSettings, true);
      expect(group.membersUIDs.isEmpty, true);
      expect(group.adminsUIDs.isEmpty, true);
    });

    // Vérifie le comportement avec des valeurs vides
    test('handles empty values gracefully', () {
      final group = GroupModel(
        creatorUID: '',
        groupName: '',
        groupDescription: '',
        groupImage: '',
        groupId: '',
        lastMessage: '',
        senderUID: '',
        messageType: MessageEnum.text,
        messageId: '',
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        createdAt: DateTime.parse('2023-10-01T10:00:00Z'),
        isPrivate: false,
        editSettings: false,
        membersUIDs: [],
        adminsUIDs: [],
      );

      expect(group.creatorUID, '');
      expect(group.groupName, '');
      expect(group.groupDescription, '');
      expect(group.groupImage, '');
      expect(group.groupId, '');
      expect(group.lastMessage, '');
      expect(group.senderUID, '');
      expect(group.membersUIDs.isEmpty, true);
      expect(group.adminsUIDs.isEmpty, true);
    });

    // Vérifie le comportement avec un groupe privé
    test('handles private group correctly', () {
      final group = GroupModel(
        creatorUID: '123',
        groupName: 'Private Group',
        groupDescription: 'This is a private group',
        groupImage: 'private_image_url',
        groupId: 'private_group_1',
        lastMessage: 'Welcome',
        senderUID: '456',
        messageType: MessageEnum.text,
        messageId: 'msg_2',
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        createdAt: DateTime.parse('2023-10-01T10:00:00Z'),
        isPrivate: true,
        editSettings: true,
        membersUIDs: ['123', '456'],
        adminsUIDs: ['123'],
      );

      expect(group.isPrivate, true);
      expect(group.editSettings, true);
    });

    // Vérifie le comportement avec un groupe public
    test('handles public group correctly', () {
      final group = GroupModel(
        creatorUID: '123',
        groupName: 'Public Group',
        groupDescription: 'This is a public group',
        groupImage: 'public_image_url',
        groupId: 'public_group_1',
        lastMessage: 'Hello Everyone',
        senderUID: '456',
        messageType: MessageEnum.text,
        messageId: 'msg_3',
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        createdAt: DateTime.parse('2023-10-01T10:00:00Z'),
        isPrivate: false,
        editSettings: false,
        membersUIDs: ['123', '456', '789'],
        adminsUIDs: ['123', '456'],
      );

      expect(group.isPrivate, false);
      expect(group.editSettings, false);
    });
  });
}
