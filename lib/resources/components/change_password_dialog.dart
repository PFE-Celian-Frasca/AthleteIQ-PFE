import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'InputField/custom_password_field.dart';

class ChangePasswordDialog extends HookWidget {
  final String userEmail;
  final Function(String currentPassword, String newPassword) onChangePassword;

  const ChangePasswordDialog({
    required this.userEmail,
    required this.onChangePassword,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final isCurrentObscure = useState(true);
    final isNewObscure = useState(true);

    return AlertDialog(
      title: const Text('Change Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPasswordField(
            label: "Current Password",
            controller: currentPasswordController,
            isObscure: isCurrentObscure.value,
            toggleObscure: () =>
                isCurrentObscure.value = !isCurrentObscure.value,
            context: context,
          ),
          CustomPasswordField(
            label: "New Password",
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
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onChangePassword(
                currentPasswordController.text, newPasswordController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Change Password'),
        ),
      ],
    );
  }
}
