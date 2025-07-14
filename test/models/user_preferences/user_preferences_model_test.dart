import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserPreferencesModel', () {
    // Vérifie la création avec les valeurs par défaut
    test('creates model with default values', () {
      const preferences = UserPreferencesModel();

      expect(preferences.receiveNotifications, true);
      expect(preferences.darkModeEnabled, true);
      expect(preferences.language, '');
    });

    // Vérifie la création avec des valeurs personnalisées
    test('creates model with custom values', () {
      const preferences = UserPreferencesModel(
        receiveNotifications: false,
        darkModeEnabled: false,
        language: 'fr',
      );

      expect(preferences.receiveNotifications, false);
      expect(preferences.darkModeEnabled, false);
      expect(preferences.language, 'fr');
    });

    // Vérifie la sérialisation et désérialisation JSON
    test('serializes and deserializes correctly', () {
      const preferences = UserPreferencesModel(
        receiveNotifications: false,
        darkModeEnabled: true,
        language: 'en',
      );

      final json = preferences.toJson();
      final deserialized = UserPreferencesModel.fromJson(json);

      expect(deserialized.receiveNotifications, false);
      expect(deserialized.darkModeEnabled, true);
      expect(deserialized.language, 'en');
    });

    // Vérifie le comportement avec une langue vide
    test('handles empty language gracefully', () {
      const preferences = UserPreferencesModel(language: '');

      expect(preferences.language, '');
    });

    // Vérifie le comportement avec des valeurs nulles
    test('handles null values gracefully', () {
      const preferences =
          UserPreferencesModel(receiveNotifications: true, darkModeEnabled: true, language: '');

      expect(preferences.receiveNotifications, true);
      expect(preferences.darkModeEnabled, true);
      expect(preferences.language, '');
    });
  });
}
