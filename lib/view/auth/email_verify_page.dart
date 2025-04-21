import 'package:athlete_iq/providers/auth/auth_provider.dart';
import 'package:athlete_iq/providers/auth/auth_state.dart';
import 'package:athlete_iq/resources/components/Button/CustomElevatedButton.dart';
import 'package:athlete_iq/resources/components/Button/CustomTextButton.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

class EmailVerifyScreen extends HookConsumerWidget {
  const EmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    void onDone() {
      GoRouter.of(context).go('/');
    }

    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
          authenticated: (user) {
            if (user.emailVerified) {
              onDone();
            }
          },
          orElse: () {});
    });

    return Scaffold(
      appBar: CustomAppBar(
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            icon: Icon(UniconsLine.exit,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              onDone();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              "Veuillez vérifier votre email",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              "Un email de vérification a été envoyé à ${authState.maybeWhen(orElse: () => '...', authenticated: (user) => user.email)}",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            CustomElevatedButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                await ref.read(authProvider.notifier).sendEmailVerification();
              },
              icon: Icons.check,
              iconColor: Theme.of(context).colorScheme.onPrimary,
              text: 'OK',
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(height: 10.h),
            CustomTextButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).sendEmailVerification();
              },
              text: "Renvoyer",
              color: Theme.of(context).colorScheme.background,
              textColor: Theme.of(context).colorScheme.primary,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
