import 'package:flutter/material.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Politique de confidentialité',
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Politique de Confidentialité de AthleteIQ',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            buildSectionTitle(context, 'Introduction'),
            buildSectionText(context,
                'Chez AthleteIQ, nous prenons la confidentialité au sérieux. Cette politique explique comment nous collectons, utilisons, partageons et protégeons vos informations personnelles.'),
            buildSectionTitle(context, 'Collecte de données'),
            buildSectionText(context,
                'Nous collectons des données lorsque vous utilisez notre application et notre boîtier connecté, y compris votre position GPS, l\'activité de parcours, les informations de profil, et l\'utilisation des fonctionnalités communautaires.'),
            buildSectionTitle(context, 'Utilisation des données'),
            buildSectionText(context,
                'Vos données sont utilisées pour améliorer votre expérience, vous fournir nos services, communiquer avec vous, et optimiser nos produits. Nous n\'utilisons pas vos données à des fins commerciales sans votre consentement.'),
            buildSectionTitle(context, 'Partage de données'),
            buildSectionText(context,
                'Nous ne partageons pas vos données avec des tiers, sauf conformément à la loi ou pour répondre à vos demandes (par exemple, lors de partenariats ou d\'intégrations que vous avez activées).'),
            buildSectionTitle(context, 'Sécurité'),
            buildSectionText(context,
                'Nous appliquons des mesures de sécurité techniques et organisationnelles pour protéger vos données contre les accès non autorisés, la perte ou la destruction.'),
            buildSectionTitle(context, 'Vos droits'),
            buildSectionText(context,
                'Vous avez le droit de consulter, modifier ou supprimer vos données personnelles à tout moment en accédant à votre compte ou en nous contactant directement.'),
            buildSectionTitle(context, 'Modifications de la politique'),
            buildSectionText(context,
                'Cette politique peut être mise à jour périodiquement. Nous vous notifierons de toute modification significative, et vous encourageons à consulter régulièrement cette page.'),
            buildSectionTitle(context, 'Contact'),
            buildSectionText(context,
                'Si vous avez des questions sur cette politique ou nos pratiques de confidentialité, veuillez contacter notre support à support@athleteiq.com.'),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildSectionText(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
