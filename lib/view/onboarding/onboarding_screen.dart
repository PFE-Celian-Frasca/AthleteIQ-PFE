import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import 'onboarding_controller.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem(
      {required this.image, required this.title, required this.description});
}

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  static const List<OnboardingItem> _items = [
    OnboardingItem(
        image: "assets/images/photo_nous.png",
        title: "Notre projet",
        description:
            "Découvrez AthleteIQ, une plateforme dédiée aux athlètes pour partager et interagir sur leurs performances. Un outil conçu pour suivre votre progression et celle de la communauté."),
    OnboardingItem(
        image: "assets/images/presentation-parcours.png",
        title: "Les parcours et la visibilité",
        description:
            "Créez, partagez et découvrez des parcours. Contrôlez la visibilité de vos performances pour rester maître de votre vie privée."),
    OnboardingItem(
        image: "assets/images/page-principale.png",
        title: "La page principale",
        description:
            "Une interface claire et intuitive. Tout ce dont vous avez besoin pour améliorer vos performances et celles de vos amis est ici."),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = usePageController(initialPage: 0);
    final currentPage = useState(0);
    final state = ref.watch(onboardingControllerProvider);
    void navigateToNextPage() {
      if (currentPage.value < _items.length - 1) {
        controller.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        done(context, ref);
      }
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: (page) => currentPage.value = page,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Image.asset(item.image, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 16),
                      Text(item.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 14),
                      Text(item.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildIndicator(currentPage.value, _items.length, theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage.value == _items.length - 1
                    ? const SizedBox()
                    : CustomElevatedButton(
                        sizedBoxWidth: 130.w,
                        onPressed:
                            state.isLoading ? null : () => done(context, ref),
                        text: "Passer",
                        icon: UniconsLine.check,
                        textColor: Theme.of(context).colorScheme.background,
                        iconColor: Theme.of(context).colorScheme.background,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                CustomElevatedButton(
                  sizedBoxWidth: 130.w,
                  onPressed: state.isLoading ? null : navigateToNextPage,
                  icon: currentPage.value == _items.length - 1
                      ? UniconsLine.check
                      : UniconsLine.arrow_right,
                  text: currentPage.value == _items.length - 1
                      ? "Fini"
                      : "Suivant",
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int currentPage, int itemCount, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.all(4),
          child: CircleAvatar(
            radius: currentPage == index ? 6 : 4,
            backgroundColor: currentPage == index
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  Future<void> done(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (context.mounted) {
      GoRouter.of(context).go('/login');
    }
  }
}
