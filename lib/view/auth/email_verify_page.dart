import 'dart:async';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/resources/components/Button/custom_text_button.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailVerifyScreen extends HookConsumerWidget {
  const EmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authRepositoryProvider);
    final user = authState.currentUser;

    Future<void> handleSendEmailVerification() async {
      try {
        await authState.sendEmailVerification();
        ref
            .read(internalNotificationProvider)
            .showToast('Email de vérification envoyé.');
      } catch (e) {
        ref
            .read(internalNotificationProvider)
            .showErrorToast('Erreur lors de l\'envoi de l\'email: $e');
      }
    }

    useEffect(() {
      Timer? timer;
      if (user != null && !user.emailVerified) {
        handleSendEmailVerification(); // Send email verification on page load
        timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
          await user.reload();
          if (authState.currentUser?.emailVerified == true) {
            timer.cancel();
            if (context.mounted) {
              GoRouter.of(context).go('/home');
            }
          }
        });
      }
      return () => timer?.cancel();
    }, [user]);

    return Scaffold(
      appBar: CustomAppBar(
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () async {
          if (user?.emailVerified == true) {
            GoRouter.of(context).go('/home');
          } else {
            await authState.signOut();
          }
        },
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
              "Un email de vérification a été envoyé à ${user?.email ?? '...'}",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            SizedBox(height: 10.h),
            CustomTextButton(
              onPressed: handleSendEmailVerification,
              text: "Renvoyer",
              color: Theme.of(context).colorScheme.surface,
              textColor: Theme.of(context).colorScheme.primary,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
