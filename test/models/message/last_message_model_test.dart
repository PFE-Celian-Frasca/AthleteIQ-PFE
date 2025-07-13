import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/message/last_message_model.dart';
import 'package:athlete_iq/enums/enums.dart';

void main() {
  group('LastMessageModel', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      final message = LastMessageModel(
        senderUID: '123',
        contactUID: '456',
        contactName: 'John Doe',
        contactImage: 'image_url',
        message: 'Hello!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        isSeen: false,
      );

      expect(message.senderUID, '123');
      expect(message.contactUID, '456');
      expect(message.contactName, 'John Doe');
      expect(message.contactImage, 'image_url');
      expect(message.message, 'Hello!');
      expect(message.messageType, MessageEnum.text);
      expect(message.timeSent, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(message.isSeen, false);
    });

    // Vérifie le comportement avec un message vu
    test('handles seen message correctly', () {
      final message = LastMessageModel(
        senderUID: '123',
        contactUID: '456',
        contactName: 'Jane Doe',
        contactImage: 'image_url',
        message: 'Hi!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        isSeen: true,
      );

      expect(message.isSeen, true);
    });

    // Vérifie le comportement avec un message vide
    test('handles empty message gracefully', () {
      final message = LastMessageModel(
        senderUID: '123',
        contactUID: '456',
        contactName: 'John Doe',
        contactImage: 'image_url',
        message: '',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        isSeen: false,
      );

      expect(message.message, '');
    });

    // Vérifie le comportement avec un type de message spécifique
    test('handles specific message type correctly', () {
      final message = LastMessageModel(
        senderUID: '123',
        contactUID: '456',
        contactName: 'John Doe',
        contactImage: 'image_url',
        message: 'Image sent',
        messageType: MessageEnum.image,
        timeSent: DateTime.parse('2023-10-01T12:00:00Z'),
        isSeen: false,
      );

      expect(message.messageType, MessageEnum.image);
    });

    // Vérifie le comportement avec une date d'envoi future
    test('handles future timeSent gracefully', () {
      final message = LastMessageModel(
        senderUID: '123',
        contactUID: '456',
        contactName: 'John Doe',
        contactImage: 'image_url',
        message: 'Hello!',
        messageType: MessageEnum.text,
        timeSent: DateTime.parse('2025-10-01T12:00:00Z'),
        isSeen: false,
      );

      expect(message.timeSent.isAfter(DateTime.now()), true);
    });
  });
}