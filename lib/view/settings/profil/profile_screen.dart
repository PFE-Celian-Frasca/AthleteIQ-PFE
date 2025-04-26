import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/resources/components/change_password_dialog.dart';
import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart';
import 'package:athlete_iq/resources/components/loading_layer.dart';
import 'package:athlete_iq/view/settings/profil/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
          final objectifController =
              useTextEditingController(text: user.objectif.toString());

          late BuildContext savedContext;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            savedContext = context;
          });

          Future<String?> promptForPassword(BuildContext context) async {
            final passwordController = TextEditingController();
            String? password;
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Re-authenticate'),
                content: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      password = passwordController.text;
                      Navigator.of(context).pop();
                    },
                    child: const Text('Submit'),
                  ),
                ],
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
                await ref
                    .read(profileControllerProvider.notifier)
                    .deleteAccount(); // Retry deleting the account
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(savedContext)
                      .showSnackBar(const SnackBar(
                    content: Text("Password is required to reauthenticate."),
                  ));
                }
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(savedContext).showSnackBar(SnackBar(
                  content: Text("Failed to reauthenticate: $e"),
                ));
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
              if (context.mounted) {
                savedContext.go('/login');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(savedContext).showSnackBar(SnackBar(
                  content: Text('Erreur lors de la déconnexion: $e'),
                ));
              }
            }
          }

          void showChangePasswordDialog(BuildContext context, WidgetRef ref) {
            showDialog(
              context: context,
              builder: (context) => ChangePasswordDialog(
                userEmail: user.email,
                onChangePassword: (currentPassword, newPassword) async {
                  try {
                    await ref
                        .read(profileControllerProvider.notifier)
                        .changePassword(newPassword);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Erreur lors du changement de mot de passe: ${e.toString()}')));
                    }
                  }
                },
              ),
            );
          }

          return isLoading
              ? const LoadingLayer(child: SizedBox.shrink())
              : SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                          label: "Objectif",
                          controller: objectifController,
                          icon: UniconsLine.award,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textInputAction: TextInputAction.next,
                          context: context,
                        ),
                        SizedBox(height: 40.h),
                        CustomElevatedButton(
                          icon: UniconsLine.edit,
                          text: "Modifier",
                          onPressed: updateProfile,
                        ),
                        SizedBox(height: 10.h),
                        CustomElevatedButton(
                          icon: UniconsLine.key_skeleton,
                          text: "Changer de mot de passe",
                          onPressed: () {
                            showChangePasswordDialog(context, ref);
                          },
                        ),
                        SizedBox(height: 40.h),
                        CustomElevatedButton(
                          text: "Déconnexion",
                          icon: UniconsLine.exit,
                          onPressed: logout,
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        SizedBox(height: 10.h),
                        CustomElevatedButton(
                          text: "Supprimer votre compte",
                          icon: UniconsLine.trash,
                          onPressed: reauthenticateAndDeleteAccount,
                          backgroundColor: Theme.of(context).colorScheme.error,
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
