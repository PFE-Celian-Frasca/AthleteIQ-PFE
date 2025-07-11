import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/resources/components/change_password_dialog.dart';
import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/settings/profil/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:unicons/unicons.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(profileControllerProvider);
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid ?? "";
    final userStream = ref.watch(userStateChangesProvider(userId));

    return Scaffold(
      appBar: CustomAppBar(
        title: "Profil",
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: userStream.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Utilisateur non trouvé.'));
          }

          final pseudoController = useTextEditingController(text: user.pseudo);
          final emailController = useTextEditingController(text: user.email);
          final objectifController = useTextEditingController(text: user.objectif.toString());

          late BuildContext savedContext;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            savedContext = context;
          });

          Future<String?> promptForPassword(BuildContext context) async {
            String? password;
              await showDialog<void>(
              context: context,
              builder: (context) => ChangePasswordDialog(
                userEmail: user.email,
                onReauthenticate: (currentPassword) {
                  password = currentPassword;
                },
              ),
            );
            return password;
          }

          Future<void> reauthenticateAndDeleteAccount() async {
            try {
              final authRepository = ref.read(authRepositoryProvider);
              final user = authRepository.currentUser;

              final email = user?.email ?? "";
              final password = await promptForPassword(savedContext);

              if (password != null) {
                await authRepository.reauthenticate(email, password);
                await ref.read(profileControllerProvider.notifier).deleteAccount();
              } else {
                if (context.mounted) {
                  ref
                      .read(internalNotificationProvider)
                      .showErrorToast('Le mot de passe est requis pour ré-authentifier.');
                }
              }
            } catch (e) {
              if (context.mounted) {
                ref
                    .read(internalNotificationProvider)
                    .showErrorToast('Erreur lors de la ré-authentification');
              }
            }
          }

          void updateProfile() async {
            UserModel updatedUser = user.copyWith();
            bool emailChanged = false;

            if (user.pseudo != pseudoController.text) {
              updatedUser = updatedUser.copyWith(pseudo: pseudoController.text);
            }

            if (user.email != emailController.text) {
              updatedUser = updatedUser.copyWith(email: emailController.text);
              emailChanged = true;
            }

            final double? objective = double.tryParse(objectifController.text);
            if (objective == null) {
              return;
            } else if (user.objectif != objective) {
              updatedUser = updatedUser.copyWith(objectif: objective);
            }

            await ref
                .read(profileControllerProvider.notifier)
                .updateProfile(updatedUser, emailChanged: emailChanged);
          }

          void logout() async {
            try {
              await ref.read(profileControllerProvider.notifier).logout();
            } catch (e) {
              if (context.mounted) {
                ref
                    .read(internalNotificationProvider)
                    .showErrorToast('Erreur lors de la déconnexion');
              }
            }
          }

            void showChangePasswordDialog(BuildContext context, WidgetRef ref) {
              showDialog<void>(
              context: context,
              builder: (context) => ChangePasswordDialog(
                userEmail: user.email,
                onChangePassword: (currentPassword, newPassword) async {
                  try {
                    await ref.read(profileControllerProvider.notifier).changePassword(newPassword);
                  } catch (e) {
                    if (context.mounted) {
                      ref
                          .read(internalNotificationProvider)
                          .showErrorToast('Erreur lors du changement de mot de passe');
                    }
                  }
                },
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              child: Column(
                children: [
                  CustomInputField(
                    label: "Pseudo",
                    controller: pseudoController,
                    icon: Icons.account_circle_outlined,
                    textInputAction: TextInputAction.next,
                    context: context,
                  ),
                  CustomInputField(
                    label: "Email",
                    controller: emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    context: context,
                  ),
                  CustomInputField(
                    label: "Objectif (Km)",
                    controller: objectifController,
                    icon: UniconsLine.award,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    context: context,
                  ),
                  SizedBox(height: 40.h),
                  CustomElevatedButton(
                    icon: UniconsLine.edit,
                    text: "Modifier",
                    onPressed: updateProfile,
                    loadingWidget: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary),
                          )
                        : null,
                  ),
                  SizedBox(height: 10.h),
                  CustomElevatedButton(
                    icon: UniconsLine.key_skeleton,
                    text: "Changer de mot de passe",
                    onPressed: () {
                      showChangePasswordDialog(context, ref);
                    },
                    loadingWidget: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary),
                          )
                        : null,
                  ),
                  SizedBox(height: 40.h),
                  CustomElevatedButton(
                    text: "Déconnexion",
                    icon: UniconsLine.exit,
                    onPressed: logout,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    loadingWidget: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary),
                          )
                        : null,
                  ),
                  SizedBox(height: 10.h),
                  CustomElevatedButton(
                    text: "Supprimer votre compte",
                    icon: UniconsLine.trash,
                    onPressed: reauthenticateAndDeleteAccount,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    loadingWidget: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
    );
  }
}
