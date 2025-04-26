import 'package:flutter/material.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Conditions d\'utilisation',
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
              'Conditions d\'Utilisation de AthleteIQ',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            buildSectionTitle(context, '1. Acceptation des Conditions'),
            buildSectionText(context,
                'En utilisant l\'application AthleteIQ ou le boîtier connecté, vous acceptez d\'être lié par ces conditions, qui régissent votre utilisation de nos services. Si vous n\'acceptez pas ces termes, vous ne devez pas utiliser nos services.'),
            buildSectionTitle(context, '2. Description des Services'),
            buildSectionText(context,
                'AthleteIQ permet aux utilisateurs d\'enregistrer, de partager des parcours sportifs et de communiquer avec d\'autres utilisateurs. Le boîtier connecté fournit une extension matérielle pour l\'enregistrement des parcours sans utiliser directement votre téléphone.'),
            buildSectionTitle(context, '3. Données Personnelles'),
            buildSectionText(context,
                'Nous collectons des informations nécessaires à l\'exploitation de notre service, incluant mais non limité à l\'adresse email, le sexe, et la localisation GPS. Ces données sont traitées de manière sécurisée et ne sont partagées avec aucun tiers.'),
            buildSectionTitle(context, '4. Droits de Propriété'),
            buildSectionText(context,
                'Les contenus fournis par AthleteIQ sont protégés par des droits de propriété intellectuelle et restent la propriété exclusive de notre entreprise basée à Lyon, France. Vous obtenez une licence limitée, non-exclusive et révocable pour utiliser notre application conformément à ces Conditions.'),
            buildSectionTitle(context, '5. Utilisation Acceptable'),
            buildSectionText(context,
                'Vous vous engagez à ne pas utiliser les services pour toute activité illégale, et vous ne devez pas porter atteinte aux opérations ou à la sécurité des services. Le boîtier doit être utilisé conformément aux instructions fournies et ne peut être modifié.'),
            buildSectionTitle(context, '6. Modifications des Conditions'),
            buildSectionText(context,
                'Nous nous réservons le droit de modifier les conditions à tout moment. Vous êtes tenu de vous conformer à la version la plus récente des conditions publiée sur notre application ou site web.'),
            buildSectionTitle(context, '7. Limitation de Responsabilité'),
            buildSectionText(context,
                'Nous ne sommes pas responsables des dommages indirects résultant de votre utilisation des services. Notre responsabilité est limitée au montant que vous avez payé dans les 12 derniers mois.'),
            buildSectionTitle(context, '8. Résolution des Conflits'),
            buildSectionText(context,
                'Les conflits non résolus à l\'amiable seront soumis à l\'arbitrage sous la législation française, avec Lyon comme lieu de juridiction.'),
            buildSectionTitle(context, '9. Résiliation'),
            buildSectionText(context,
                'Vous pouvez résilier votre compte à tout moment. Nous nous réservons le droit de suspendre ou de résilier votre accès aux services en cas de violation grave ou répétée de ces conditions.'),
            buildSectionTitle(context, '10. Contact'),
            buildSectionText(context,
                'Pour toute question relative à ces conditions, veuillez contacter notre support à support@athleteiq.com.'),
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
