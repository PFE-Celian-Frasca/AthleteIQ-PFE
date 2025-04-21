import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/auth/auth_provider.dart';
import 'package:athlete_iq/providers/user/user_provider.dart';
import 'package:athlete_iq/resources/components/change_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:athlete_iq/resources/components/Button/CustomElevatedButton.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';
import 'package:athlete_iq/resources/components/InputField/CustomInputField.dart';
import 'package:athlete_iq/resources/components/loading_layer.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:unicons/unicons.dart';

//TODO: ADd loading layer
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(globalProvider.select((state) => state.isLoading));
    final user = ref
        .watch(globalProvider.select((state) => state.userState))
        .maybeWhen(loaded: (user) => user, orElse: () => null);

    // Hooks for managing text editing
    final pseudoController = useTextEditingController(text: user?.pseudo ?? "");
    final emailController = useTextEditingController(text: user?.email ?? "");
    final objectifController =
        useTextEditingController(text: user?.objectif.toString() ?? "");

    void updateProfile() async {
      UserModel updatedUser =
          user!.copyWith(); // Create a copy of the current user model

      // Check if the pseudo has been changed
      if (user.pseudo != pseudoController.text) {
        updatedUser = updatedUser.copyWith(pseudo: pseudoController.text);
      }

      // Check if the email has been changed
      bool emailChanged = user.email != emailController.text;
      if (emailChanged) {
        updatedUser = updatedUser.copyWith(email: emailController.text);
      }

      // Check if the objective has been changed and is valid
      final double? objective = double.tryParse(objectifController.text);
      if (objective == null) {
        return;
      } else if (user.objectif != objective) {
        updatedUser = updatedUser.copyWith(objectif: objective);
      }

      // If email has changed, update it through a specific method
      if (emailChanged) {
        try {
          await ref
              .read(authProvider.notifier)
              .updateEmail(emailController.text);
          await ref.read(userProvider.notifier).updateUserProfile(updatedUser);
        } catch (e) {
          return;
        }
      } else {
        // Update user profile excluding email
        try {
          await ref.read(userProvider.notifier).updateUserProfile(updatedUser);
        } catch (e) {
          return;
        }
      }
    }

    void logout() {
      ref.read(globalProvider.notifier).signOutUser();
    }

    Future<void> deleteAccount() async {
      await ref.read(globalProvider.notifier).deleteUserAccount(user!.id);
    }

    void showChangePasswordDialog(BuildContext context, WidgetRef ref) {
      showDialog(
        context: context,
        builder: (context) => ChangePasswordDialog(
          userEmail: user!.email,
          onChangePassword: (currentPassword, newPassword) async {
            try {
              await ref.read(authProvider.notifier).updatePassword(newPassword);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to change password: ${e.toString()}')));
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Profil",
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: isLoading
          ? const LoadingLayer(child: SizedBox.shrink())
          : SingleChildScrollView(
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
                      label: "Objective",
                      controller: objectifController,
                      icon: UniconsLine.award,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                      onPressed: deleteAccount,
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
