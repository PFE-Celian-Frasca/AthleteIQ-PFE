import 'package:athlete_iq/enums/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/providers/groupe/group_chat_state.dart';
import 'package:athlete_iq/models/group/group_model.dart';

void main() {
  group('GroupChatState', () {
    // Vérifie la création correcte avec des valeurs valides
    test('creates state with valid values', () {
      final groupDetails = GroupModel(
        creatorUID: "123",
        groupName: "Test Group",
        groupDescription: "This is a test group",
        groupImage: "image_url",
        groupId: "1",
        lastMessage: "Hello World",
        senderUID: '123',
        messageType: MessageEnum.text,
        messageId: 'msg_1',
        timeSent: DateTime(2023, 10, 1, 12, 0),
        createdAt: DateTime(2023, 10, 1, 10, 0),
        isPrivate: true,
        editSettings: true,
        membersUIDs: ['123', '456'],
        adminsUIDs: ['123'],
      );
      final state = GroupChatState(
        groupDetails: groupDetails,
        isLoading: false,
        error: null,
      );

      expect(state.groupDetails.groupId, '1');
      expect(state.groupDetails.groupName, 'Test Group');
      expect(state.isLoading, false);
      expect(state.error, null);
    });

    // Vérifie la gestion de l'état de chargement
    test('handles loading state correctly', () {
      final groupDetails = GroupModel(
        creatorUID: "123",
        groupName: "Test Group",
        groupDescription: "This is a test group",
        groupImage: "image_url",
        groupId: "1",
        lastMessage: "Hello World",
        senderUID: '123',
        messageType: MessageEnum.text,
        messageId: 'msg_1',
        timeSent: DateTime(2023, 10, 1, 12, 0),
        createdAt: DateTime(2023, 10, 1, 10, 0),
        isPrivate: true,
        editSettings: true,
        membersUIDs: ['123', '456'],
        adminsUIDs: ['123'],
      );
      final state = GroupChatState(
        groupDetails: groupDetails,
        isLoading: true,
        error: null,
      );

      expect(state.isLoading, true);
    });

    // Vérifie la gestion des erreurs
    test('handles error state correctly', () {
      final groupDetails = GroupModel(
        creatorUID: "123",
        groupName: "Test Group",
        groupDescription: "This is a test group",
        groupImage: "image_url",
        groupId: "1",
        lastMessage: "Hello World",
        senderUID: '123',
        messageType: MessageEnum.text,
        messageId: 'msg_1',
        timeSent: DateTime(2023, 10, 1, 12, 0),
        createdAt: DateTime(2023, 10, 1, 10, 0),
        isPrivate: true,
        editSettings: true,
        membersUIDs: ['123', '456'],
        adminsUIDs: ['123'],
      );
      final state = GroupChatState(
        groupDetails: groupDetails,
        isLoading: false,
        error: 'An error occurred',
      );

      expect(state.error, 'An error occurred');
    });

    // Vérifie la gestion des détails de groupe vides
    test('handles empty group details gracefully', () {
      final groupDetails = GroupModel(
        creatorUID: "",
        groupName: "",
        groupDescription: "",
        groupImage: "",
        groupId: "",
        lastMessage: "",
        senderUID: '',
        messageType: MessageEnum.text,
        messageId: '',
        timeSent: DateTime(0),
        createdAt: DateTime(0),
        isPrivate: false,
        editSettings: false,
        membersUIDs: [],
        adminsUIDs: [],
      );
      final state = GroupChatState(
        groupDetails: groupDetails,
        isLoading: false,
        error: null,
      );

      expect(state.groupDetails.groupId, '');
      expect(state.groupDetails.groupName, '');
    });
  });
}
