import 'package:athlete_iq/models/rive_asset.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RiveAsset model', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      final asset = RiveAsset("assets/RiveAssets/icons.riv",
          artboard: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Communauté");

      expect(asset.src, "assets/RiveAssets/icons.riv");
      expect(asset.artboard, "CHAT");
      expect(asset.stateMachineName, "CHAT_Interactivity");
      expect(asset.title, "Communauté");
      expect(asset.input, null);
    });

    // Vérifie le comportement avec des valeurs vides
    test('handles empty title gracefully', () {
      final asset = RiveAsset("assets/RiveAssets/icons.riv",
          artboard: "USER", stateMachineName: "USER_Interactivity", title: "");

      expect(asset.title, "");
    });

    // Vérifie le comportement avec un artboard manquant
    test('handles missing artboard gracefully', () {
      final asset = RiveAsset("assets/RiveAssets/icons.riv",
          artboard: "", stateMachineName: "USER_Interactivity", title: "Truc");

      expect(asset.artboard, "");
    });

    // Vérifie le comportement avec un chemin source invalide
    test('handles invalid src gracefully', () {
      final asset =
          RiveAsset("", artboard: "HOME", stateMachineName: "HOME_interactivity", title: "Map");

      expect(asset.src, "");
    });
  });
}
