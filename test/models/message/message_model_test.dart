import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/enums/enums.dart';

void main() {
  group('MessageModel', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      final message = MessageModel(
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        message: 'Hello!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        messageId: 'msg_1',
        isSeen: false,
        repliedMessage: 'Hi!',
        repliedTo: 'Jane Doe',
        repliedMessageType: MessageEnum.text,
        reactions: ['like', 'love'],
        isSeenBy: ['123', '456'],
        deletedBy: ['789'],
      );

      expect(message.senderUID, '123');
      expect(message.senderName, 'John Doe');
      expect(message.senderImage, 'image_url');
      expect(message.message, 'Hello!');
      expect(message.messageType, MessageEnum.text);
      expect(message.timeSent, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(message.messageId, 'msg_1');
      expect(message.isSeen, false);
      expect(message.repliedMessage, 'Hi!');
      expect(message.repliedTo, 'Jane Doe');
      expect(message.repliedMessageType, MessageEnum.text);
      expect(message.reactions, ['like', 'love']);
      expect(message.isSeenBy, ['123', '456']);
      expect(message.deletedBy, ['789']);
    });

    // Vérifie le comportement avec un message vu
    test('handles seen message correctly', () {
      final message = MessageModel(
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        message: 'Hello!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        messageId: 'msg_2',
        isSeen: true,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
        reactions: [],
        isSeenBy: ['123'],
        deletedBy: [],
      );

      expect(message.isSeen, true);
      expect(message.isSeenBy, ['123']);
    });

    // Vérifie le comportement avec un message supprimé
    test('handles deleted message correctly', () {
      final message = MessageModel(
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        message: 'Hello!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        messageId: 'msg_3',
        isSeen: false,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
        reactions: [],
        isSeenBy: [],
        deletedBy: ['123'],
      );

      expect(message.deletedBy, ['123']);
    });

    // Vérifie le comportement avec un message sans réaction
    test('handles message without reactions correctly', () {
      final message = MessageModel(
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        message: 'Hello!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        messageId: 'msg_4',
        isSeen: false,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
        reactions: [],
        isSeenBy: [],
        deletedBy: [],
      );

      expect(message.reactions.isEmpty, true);
    });

    // Vérifie le comportement avec une date d'envoi future
    test('handles future timeSent gracefully', () {
      final message = MessageModel(
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        message: 'Hello!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2025-10-01T12:00:00Z'),
        messageId: 'msg_5',
        isSeen: false,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
        reactions: [],
        isSeenBy: [],
        deletedBy: [],
      );

      expect(message.timeSent.isAfter(DateTime.now()), true);
    });
  });
}