import 'package:athlete_iq/models/rive_asset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

class FakeSMIBool extends Fake implements SMIBool {}

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

    test('setInput updates input', () {
      final asset = RiveAsset("assets/RiveAssets/icons.riv",
          artboard: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Communauté");

      final fakeInput = FakeSMIBool();
      asset.setInput = fakeInput;

      expect(asset.input, same(fakeInput));
    });

    test('bottomNavs contains expected items', () {
      expect(bottomNavs, hasLength(3));

      expect(bottomNavs[0].artboard, "CHAT");
      expect(bottomNavs[0].stateMachineName, "CHAT_Interactivity");
      expect(bottomNavs[0].title, "Communauté");
      expect(bottomNavs[0].src, "assets/RiveAssets/icons.riv");

      expect(bottomNavs[1].artboard, "HOME");
      expect(bottomNavs[1].stateMachineName, "HOME_interactivity");
      expect(bottomNavs[1].title, "Map");
      expect(bottomNavs[1].src, "assets/RiveAssets/icons.riv");

      expect(bottomNavs[2].artboard, "USER");
      expect(bottomNavs[2].stateMachineName, "USER_Interactivity");
      expect(bottomNavs[2].title, "Truc");
      expect(bottomNavs[2].src, "assets/RiveAssets/icons.riv");
    });
  });
}
