import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'InputField/custom_password_field.dart';

class ChangePasswordDialog extends HookWidget {
  final String userEmail;
  final Function(String currentPassword, String newPassword)? onChangePassword;
  final Function(String currentPassword)? onReauthenticate;

  const ChangePasswordDialog({
    required this.userEmail,
    this.onChangePassword,
    this.onReauthenticate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final isCurrentObscure = useState(true);
    final isNewObscure = useState(true);

    return AlertDialog(
      title: Text(onChangePassword != null
          ? 'Changer de mot de passe'
          : 'Re-connexion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPasswordField(
            label: "Mot de passe actuel",
            controller: currentPasswordController,
            isObscure: isCurrentObscure.value,
            toggleObscure: () =>
                isCurrentObscure.value = !isCurrentObscure.value,
            context: context,
          ),
          if (onChangePassword != null)
            CustomPasswordField(
              label: "Nouveau mot de passe",
              controller: newPasswordController,
              isObscure: isNewObscure.value,
              toggleObscure: () => isNewObscure.value = !isNewObscure.value,
              context: context,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if (onChangePassword != null) {
              onChangePassword!(
                  currentPasswordController.text, newPasswordController.text);
            } else if (onReauthenticate != null) {
              onReauthenticate!(currentPasswordController.text);
            }
            Navigator.of(context).pop();
          },
          child: Text(onChangePassword != null
              ? 'Changer le mot de passe'
              : 'Re-connexion'),
        ),
      ],
    );
  }
}
