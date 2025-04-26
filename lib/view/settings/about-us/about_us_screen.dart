import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'À propos de nous',
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
              'Qui sommes-nous ?',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            Text(
              'AthleteIQ est une entreprise innovante basée à Lyon, France, spécialisée dans le développement de solutions technologiques dédiées aux sportifs de tous niveaux. Fondée en 2023, notre mission est de rendre le sport plus accessible et agréable grâce à la technologie.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Notre Vision',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            Text(
              'Nous aspirons à être un leader mondial dans le domaine des technologies sportives, en fournissant des produits innovants qui connectent, motivent et soutiennent les sportifs dans leur quête de dépassement.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Nos Produits',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            Text(
              'De l\'application mobile AthleteIQ qui permet de suivre et partager vos performances sportives, au boîtier connecté pour les sports extrêmes, chaque produit que nous développons est conçu pour améliorer votre expérience sportive.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Engagement envers nos utilisateurs',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            Text(
              'Votre confiance et votre satisfaction sont au cœur de notre démarche. Nous nous engageons à fournir des produits de haute qualité et un support client sans pareil.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
