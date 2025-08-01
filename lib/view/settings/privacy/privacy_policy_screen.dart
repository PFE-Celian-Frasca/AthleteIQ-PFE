import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrivacySettingsScreen extends HookConsumerWidget {
  const PrivacySettingsScreen({super.key});

  static const _policyLastUpdate = 'Dernière mise à jour : 31/07/2025';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowAnalytics = useState<bool>(false);
    final allowCrash = useState<bool>(false);

    Widget sectionTitle(String text) => Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        );

    final bulletStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          height: 1.4,
          color: Colors.black87,
        );

    Widget bullet(String text) => Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text('• $text', style: bulletStyle),
        );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Confidentialité & Données",
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_policyLastUpdate, style: Theme.of(context).textTheme.bodySmall),

            sectionTitle('Résumé de la politique'),
            const Text(
              "Nous collectons uniquement les données nécessaires au bon fonctionnement de l’application : "
              "adresse e-mail (compte), pseudonyme et données d’activité (distance, durée, trace GPS). "
              "Aucune donnée n’est vendue ni partagée à des tiers à des fins publicitaires.",
            ),

            sectionTitle('Données collectées'),
            bullet("Identité du compte : adresse e-mail et pseudonyme."),
            bullet("Activité sportive : distance, durée, positions GPS, date et heure."),
            bullet("Technique (minimisé) : version de l’application, plate-forme, langue."),

            sectionTitle('Finalités & base légale'),
            bullet("Création et gestion de compte (exécution du service)."),
            bullet("Enregistrement et consultation de sessions (exécution du service)."),
            bullet(
                "Amélioration du produit et stabilité (intérêt légitime ; analytics/crash désactivés par défaut sans consentement)."),

            sectionTitle('Durées de conservation'),
            bullet("Sessions sportives : 24 mois, puis suppression automatique."),
            bullet("Profil/compte : jusqu’à suppression volontaire du compte par l’utilisateur."),
            bullet("Journaux techniques : 12 mois maximum."),

            sectionTitle('Partage & hébergement'),
            bullet("Pas de vente de données, pas d’échange à des tiers marketing."),
            bullet(
                "Hébergement et services gérés par Firebase/Google ; transferts sécurisés (HTTPS)."),

            sectionTitle('Vos choix'),
            bullet(
                "Vous pouvez refuser à tout moment la collecte de statistiques anonymes et des rapports de crash."),
            bullet(
                "Vous pouvez demander l’export de vos données ou la suppression définitive de votre compte."),

            sectionTitle('Consentements (désactivés par défaut)'),
            Row(
              children: [
                Switch.adaptive(
                  value: allowAnalytics.value,
                  onChanged: (v) => allowAnalytics.value = v,
                ),
                const SizedBox(width: 8),
                const Expanded(child: Text("Partage des statistiques anonymes (Analytics)")),
              ],
            ),
            Row(
              children: [
                Switch.adaptive(
                  value: allowCrash.value,
                  onChanged: (v) => allowCrash.value = v,
                ),
                const SizedBox(width: 8),
                const Expanded(child: Text("Rapports de crash pour améliorer la stabilité")),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "Ces réglages sont enregistrés localement sur l’appareil. Vous pouvez les modifier à tout moment.",
              style: Theme.of(context).textTheme.bodySmall,
            ),

            sectionTitle('Droits & contact'),
            bullet("Accès, rectification, export (portabilité) et suppression de vos données."),
            bullet("Retrait du consentement à tout moment pour analytics/crash."),
            bullet("Contact : privacy@athleteiq.app"),

            SizedBox(height: 16.h),
            Text(
              "Cette page résume la politique de confidentialité. La version complète est disponible depuis le site et sera mise à jour en cas d’évolution.",
              style: Theme.of(context).textTheme.bodySmall,
            ),

            SizedBox(height: 12.h),
            // (Tu peux ajouter ici des boutons “Exporter mes données” / “Supprimer mon compte”
            // lorsqu’ils seront branchés à la logique correspondante.)
          ],
        ),
      ),
    );
  }
}
