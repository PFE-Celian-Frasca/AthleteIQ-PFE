import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../resources/components/custom_app_bar.dart';
import '../../utils/utils_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const route = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Paramètres",
        hasBackButton: true,
        onBackButtonPressed: () => navigateBackOrToMain(context),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Profil"),
            onTap: () => context.go('/info/settings/profile'),
          ),
          ListTile(
            title: const Text("Appareils"),
            onTap: () => context.go('/info/settings/appareils'),
          ),
          ListTile(
              title: const Text("Statistiques"),
              onTap: () => context.go('/info/settings/statistiques')),
          ListTile(
            title: const Text("A propos de nous"),
            onTap: () => context.go('/info/settings/a-propos-de-nous'),
          ),
          ListTile(
            title: const Text("Conditions d'utilisation"),
            onTap: () => context.go('/info/settings/conditions-utilisation'),
          ),
          ListTile(
            title: const Text("Politique de confidentialité"),
            onTap: () => context.go('/info/settings/politique-confidentialite'),
          ),
        ],
        //TODO: Ajouter la version de l'application
      ),
    );
  }
}
