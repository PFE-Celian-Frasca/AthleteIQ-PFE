import 'package:athlete_iq/providers/auth/auth_provider.dart';
import 'package:athlete_iq/resources/components/Button/CustomElevatedButton.dart';
import 'package:athlete_iq/resources/components/Button/CustomTextButton.dart';
import 'package:athlete_iq/resources/components/InputField/CustomInputField.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    void onResetPassword() async {
      if (formKey.currentState!.validate()) {
        await ref
            .read(authProvider.notifier)
            .resetPassword(emailController.text);
        ref.read(notificationNotifierProvider.notifier).showToast(
            'A password reset link has been sent to your email address.');
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomInputField(
                        context: context,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30.h),
                      CustomElevatedButton(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: onResetPassword,
                        icon: Icons.send,
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                        text: 'Send',
                        textColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextButton(
                        onPressed: () => GoRouter.of(context).go('/login'),
                        text: 'Back',
                        color: Theme.of(context).colorScheme.background,
                        textColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 0.3.sh,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.r)),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 20.w, bottom: 20.h, right: 20.w, top: 40.h),
        child: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 100.h),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Forgot Password?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                  Text('Enter your email to reset your password.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.7),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
