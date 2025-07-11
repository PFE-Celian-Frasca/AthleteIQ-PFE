import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:athlete_iq/view/onboarding/onboarding_controller.dart';

/// Model representing a single onboarding page.
class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

/// Main onboarding screen with animated pages and navigation buttons.
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  static const List<OnboardingItem> _items = [
    OnboardingItem(
      image: 'assets/images/logo_noir.png',
      title: 'Notre projet',
      description:
          'Découvrez AthleteIQ, une plateforme dédiée aux athlètes pour partager et interagir sur leurs performances. Un outil conçu pour suivre votre progression et celle de la communauté.',
    ),
    OnboardingItem(
      image: 'assets/images/presentation-parcours.png',
      title: 'Les parcours et la visibilité',
      description:
          'Créez, partagez et découvrez des parcours. Contrôlez la visibilité de vos performances pour rester maître de votre vie privée.',
    ),
    OnboardingItem(
      image: 'assets/images/page-principale.png',
      title: 'La page principale',
      description:
          'Une interface claire et intuitive. Tout ce dont vous avez besoin pour améliorer vos performances et celles de vos amis est ici.',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = usePageController();
    final currentPage = useState(0);
    final state = ref.watch(onboardingControllerProvider);

    void goNext() {
      if (currentPage.value < _items.length - 1) {
        controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.ease,
        );
      } else {
        _completeOnboarding(context, ref);
      }
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: _items.length,
                  onPageChanged: (index) => currentPage.value = index,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final active = index == currentPage.value;
                    return _AnimatedOnboardingPage(
                      controller: controller,
                      index: index,
                      active: active,
                      item: item,
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              SmoothPageIndicator(
                controller: controller,
                count: _items.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.h,
                  expansionFactor: 3,
                  spacing: 6.w,
                  activeDotColor: theme.colorScheme.primary,
                  dotColor: theme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage.value != _items.length - 1)
                    _NavigationButton(
                      label: 'Passer',
                      icon: UniconsLine.skip_forward,
                      color: theme.colorScheme.tertiary,
                      onPressed: state.isLoading ? null : () => _completeOnboarding(context, ref),
                    )
                  else
                    SizedBox(width: 110.w),
                  _NavigationButton(
                    label: currentPage.value == _items.length - 1 ? 'Fin' : 'Suivant',
                    icon: currentPage.value == _items.length - 1
                        ? UniconsLine.check
                        : UniconsLine.arrow_right,
                    color: theme.colorScheme.primary,
                    onPressed: state.isLoading ? null : goNext,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (context.mounted) {
      GoRouter.of(context).go('/home');
    }
  }
}

class _AnimatedOnboardingPage extends StatelessWidget {
  const _AnimatedOnboardingPage({
    required this.controller,
    required this.index,
    required this.active,
    required this.item,
  });

  final PageController controller;
  final int index;
  final bool active;
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = (1 - (controller.page! - index).abs()).clamp(0.0, 1.0);
        }
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxHeight < 600;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: active ? 1 : 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 600),
                  offset: active ? Offset.zero : const Offset(0, 0.2),
                  child: Image.asset(
                    item.image,
                    height: isSmall ? 180.h : 220.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: active ? 1 : 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 600),
                  offset: active ? Offset.zero : const Offset(0, 0.2),
                  child: Text(
                    item.title,
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: active ? 1 : 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 600),
                  offset: active ? Offset.zero : const Offset(0, 0.2),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      item.description,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 45.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20.sp, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 4,
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
