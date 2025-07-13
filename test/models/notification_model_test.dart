import 'package:athlete_iq/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationModel', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      final notification = NotificationModel(
        id: '1',
        userId: '123',
        title: 'Nouvelle notification',
        body: 'Vous avez un nouveau message.',
        isRead: false,
        createdAt: DateTime.parse('2023-10-01T12:00:00Z'),
      );

      expect(notification.id, '1');
      expect(notification.userId, '123');
      expect(notification.title, 'Nouvelle notification');
      expect(notification.body, 'Vous avez un nouveau message.');
      expect(notification.isRead, false);
      expect(notification.createdAt, DateTime.parse('2023-10-01T12:00:00Z'));
      expect(notification.readAt, null);
      expect(notification.relatedContentId, null);
      expect(notification.type, 'generic');
    });

    // Vérifie le comportement avec une notification lue
    test('handles read notification correctly', () {
      final notification = NotificationModel(
        id: '2',
        userId: '456',
        title: 'Notification lue',
        body: 'Vous avez lu ce message.',
        isRead: true,
        createdAt: DateTime.parse('2023-10-01T12:00:00Z'),
        readAt: DateTime.parse('2023-10-02T12:00:00Z'),
      );

      expect(notification.isRead, true);
      expect(notification.readAt, DateTime.parse('2023-10-02T12:00:00Z'));
    });

    // Vérifie le comportement avec un type de notification spécifique
    test('handles specific notification type correctly', () {
      final notification = NotificationModel(
        id: '3',
        userId: '789',
        title: 'Demande d\'ami',
        body: 'Un utilisateur souhaite vous ajouter en ami.',
        isRead: false,
        createdAt: DateTime.parse('2023-10-01T12:00:00Z'),
        type: 'friendRequest',
      );

      expect(notification.type, 'friendRequest');
    });

    // Vérifie le comportement avec un contenu lié
    test('handles related content correctly', () {
      final notification = NotificationModel(
        id: '4',
        userId: '101',
        title: 'Nouveau commentaire',
        body: 'Un utilisateur a commenté votre publication.',
        isRead: false,
        createdAt: DateTime.parse('2023-10-01T12:00:00Z'),
        relatedContentId: 'post_123',
      );

      expect(notification.relatedContentId, 'post_123');
    });

    // Vérifie le comportement avec des valeurs vides
    test('handles empty title and body gracefully', () {
      final notification = NotificationModel(
        id: '5',
        userId: '202',
        title: '',
        body: '',
        isRead: false,
        createdAt: DateTime.parse('2023-10-01T12:00:00Z'),
      );

      expect(notification.title, '');
      expect(notification.body, '');
    });
  });
}