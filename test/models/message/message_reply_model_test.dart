import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/message/message_reply_model.dart';
import 'package:athlete_iq/enums/enums.dart';

void main() {
  group('MessageReplyModel', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      const reply = MessageReplyModel(
        message: 'Hello!',
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        messageType: MessageEnum.text,
        isMe: true,
      );

      expect(reply.message, 'Hello!');
      expect(reply.senderUID, '123');
      expect(reply.senderName, 'John Doe');
      expect(reply.senderImage, 'image_url');
      expect(reply.messageType, MessageEnum.text);
      expect(reply.isMe, true);
    });

    // Vérifie le comportement avec un message vide
    test('handles empty message gracefully', () {
      const reply = MessageReplyModel(
        message: '',
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        messageType: MessageEnum.text,
        isMe: false,
      );

      expect(reply.message, '');
    });

    // Vérifie le comportement avec un type de message spécifique
    test('handles specific message type correctly', () {
      const reply = MessageReplyModel(
        message: 'Image sent',
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: 'image_url',
        messageType: MessageEnum.image,
        isMe: true,
      );

      expect(reply.messageType, MessageEnum.image);
    });

    // Vérifie le comportement avec un utilisateur différent
    test('handles different sender correctly', () {
      const reply = MessageReplyModel(
        message: 'Hi!',
        senderUID: '456',
        senderName: 'Jane Doe',
        senderImage: 'image_url',
        messageType: MessageEnum.text,
        isMe: false,
      );

      expect(reply.senderUID, '456');
      expect(reply.senderName, 'Jane Doe');
      expect(reply.isMe, false);
    });

    // Vérifie le comportement avec une image de l'expéditeur vide
    test('handles empty sender image gracefully', () {
      const reply = MessageReplyModel(
        message: 'Hello!',
        senderUID: '123',
        senderName: 'John Doe',
        senderImage: '',
        messageType: MessageEnum.text,
        isMe: true,
      );

      expect(reply.senderImage, '');
    });

    test('parses valid JSON correctly', () {
      const json = {
        'message': 'Hello!',
        'senderUID': '123',
        'senderName': 'John Doe',
        'senderImage': 'image_url',
        'messageType': 'text',
        'isMe': true,
      };

      final reply = MessageReplyModel.fromJson(json);

      expect(reply.message, 'Hello!');
      expect(reply.senderUID, '123');
      expect(reply.senderName, 'John Doe');
      expect(reply.senderImage, 'image_url');
      expect(reply.messageType, MessageEnum.text);
      expect(reply.isMe, true);
    });

    test('throws an error when required fields are missing', () {
      const json = {
        'message': 'Hello!',
        'senderUID': '123',
      };

      expect(() => MessageReplyModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('parses JSON with different message types correctly', () {
      const json = {
        'message': 'Image sent',
        'senderUID': '123',
        'senderName': 'John Doe',
        'senderImage': 'image_url',
        'messageType': 'image',
        'isMe': false,
      };

      final reply = MessageReplyModel.fromJson(json);

      expect(reply.messageType, MessageEnum.image);
      expect(reply.isMe, false);
    });
  });
}
