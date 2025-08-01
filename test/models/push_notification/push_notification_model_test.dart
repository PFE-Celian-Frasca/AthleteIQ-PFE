import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/push_notification/push_notification_model.dart';

void main() {
  group('PushNotificationModel', () {
    // Vérifie la création correcte avec des valeurs requises
    test('creates model with required values', () {
      const notification = PushNotificationModel(
        title: 'Test Title',
        body: 'Test Body',
        imageUrl: null,
        data: {
          "key": "value",
        },
      );

      expect(notification.title, 'Test Title');
      expect(notification.body, 'Test Body');
      expect(notification.imageUrl, null);
      expect(notification.data, {
        "key": "value",
      });
    });

    // Vérifie la création correcte avec une image et des données supplémentaires
    test('creates model with image and additional data', () {
      const notification = PushNotificationModel(
        title: 'Test Title',
        body: 'Test Body',
        imageUrl: 'https://example.com/image.png',
        data: {'key': 'value'},
      );

      expect(notification.title, 'Test Title');
      expect(notification.body, 'Test Body');
      expect(notification.imageUrl, 'https://example.com/image.png');
      expect(notification.data, {'key': 'value'});
    });

    // Vérifie la sérialisation et désérialisation JSON
    test('serializes and deserializes correctly', () {
      const notification = PushNotificationModel(
        title: 'Test Title',
        body: 'Test Body',
        imageUrl: 'https://example.com/image.png',
        data: {'key': 'value'},
      );

      final json = notification.toJson();
      final deserialized = PushNotificationModel.fromJson(json);

      expect(deserialized.title, 'Test Title');
      expect(deserialized.body, 'Test Body');
      expect(deserialized.imageUrl, 'https://example.com/image.png');
      expect(deserialized.data, {'key': 'value'});
    });

    // Vérifie le comportement avec des données vides
    test('handles empty data gracefully', () {
      const notification = PushNotificationModel(
        title: 'Test Title',
        body: 'Test Body',
        data: {},
      );

      expect(notification.data.isEmpty, true);
    });
  });
}
