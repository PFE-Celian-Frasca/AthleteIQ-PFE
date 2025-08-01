import 'package:athlete_iq/models/gender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';

void main() {
  group('Gender model', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      final gender = Gender('Male', CupertinoIcons.person, false);

      expect(gender.name, 'Male');
      expect(gender.icon, CupertinoIcons.person);
      expect(gender.isSelected, false);
    });

    // Vérifie que la sélection peut être modifiée
    test('allows selection state to be updated', () {
      final gender = Gender('Female', CupertinoIcons.person, false);

      gender.isSelected = true;

      expect(gender.isSelected, true);
    });

    // Vérifie le comportement avec des valeurs vides
    test('handles empty name gracefully', () {
      final gender = Gender('', CupertinoIcons.person, false);

      expect(gender.name, '');
    });
  });
}
