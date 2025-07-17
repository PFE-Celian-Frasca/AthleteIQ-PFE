import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/utils/utils_navigation.dart';

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
      body: FocusTraversalGroup(
        child: ListView(
          children: [
          ListTile(
            title: const Text("Profil"),
            onTap: () => context.go('/info/settings/profile'),
          ),
          ],
        ),
      ),
    );
  }
}
