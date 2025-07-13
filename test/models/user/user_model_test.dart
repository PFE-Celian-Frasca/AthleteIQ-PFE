import 'package:athlete_iq/models/user/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    // Vérifie la création correcte avec des valeurs requises
    test('creates model with required values', () {
      final user = UserModel(
        id: '123',
        pseudo: 'TestUser',
        email: 'test@example.com',
        sex: 'male',
        createdAt: DateTime(2023, 10, 1),
      );

      expect(user.id, '123');
      expect(user.pseudo, 'TestUser');
      expect(user.email, 'test@example.com');
      expect(user.sex, 'male');
      expect(user.createdAt, DateTime(2023, 10, 1));
      expect(user.image, isNotEmpty);
      expect(user.friends, isEmpty);
      expect(user.sentFriendRequests, isEmpty);
      expect(user.receivedFriendRequests, isEmpty);
      expect(user.fav, isEmpty);
      expect(user.objectif, 5.0);
      expect(user.totalDist, 0.0);
      expect(user.fcmToken, isNull);
    });

    // Vérifie la gestion des valeurs par défaut
    test('handles default values correctly', () {
      final user = UserModel(
        id: '123',
        pseudo: 'DefaultUser',
        email: 'default@example.com',
        sex: 'female',
        createdAt: DateTime(2023, 10, 1),
      );

      expect(user.image, isNotEmpty);
      expect(user.friends, isEmpty);
      expect(user.sentFriendRequests, isEmpty);
      expect(user.receivedFriendRequests, isEmpty);
      expect(user.fav, isEmpty);
      expect(user.objectif, 5.0);
      expect(user.totalDist, 0.0);
    });

    // Vérifie la sérialisation et désérialisation JSON
    test('serializes and deserializes correctly', () {
      final user = UserModel(
        id: '123',
        pseudo: 'SerializedUser',
        email: 'serialize@example.com',
        sex: 'male',
        createdAt: DateTime(2023, 10, 1),
        friends: ['friend1', 'friend2'],
        totalDist: 42.0,
      );

      final json = user.toJson();
      final deserialized = UserModel.fromJson(json);

      expect(deserialized.id, '123');
      expect(deserialized.pseudo, 'SerializedUser');
      expect(deserialized.email, 'serialize@example.com');
      expect(deserialized.sex, 'male');
      expect(deserialized.createdAt, DateTime(2023, 10, 1));
      expect(deserialized.friends, ['friend1', 'friend2']);
      expect(deserialized.totalDist, 42.0);
    });

    // Vérifie le comportement avec des listes vides
    test('handles empty lists gracefully', () {
      final user = UserModel(
        id: '123',
        pseudo: 'EmptyListsUser',
        email: 'empty@example.com',
        sex: 'female',
        createdAt: DateTime(2023, 10, 1),
        friends: [],
        sentFriendRequests: [],
        receivedFriendRequests: [],
        fav: [],
      );

      expect(user.friends, isEmpty);
      expect(user.sentFriendRequests, isEmpty);
      expect(user.receivedFriendRequests, isEmpty);
      expect(user.fav, isEmpty);
    });

    // Vérifie le comportement avec un objectif personnalisé
    test('handles custom objectif value', () {
      final user = UserModel(
        id: '123',
        pseudo: 'CustomObjectifUser',
        email: 'custom@example.com',
        sex: 'male',
        createdAt: DateTime(2023, 10, 1),
        objectif: 10.0,
      );

      expect(user.objectif, 10.0);
    });
  });
}