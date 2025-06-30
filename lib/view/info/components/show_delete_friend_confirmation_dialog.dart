import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';

void showDeleteFriendConfirmationDialog(
    BuildContext context, UserModel user, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Supprimer cet ami"),
      content: const Text("Êtes-vous sûr de vouloir supprimer cet ami ?"),
      actions: <Widget>[
        TextButton(
          child: const Text("Annuler"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Supprimer"),
          onPressed: () async {
            try {
              final userId = ref.read(authRepositoryProvider).currentUser!.uid;
              await ref.read(userRepositoryProvider).removeFriend(
                    userId: userId,
                    friendId: user.id,
                  );
              ref.read(internalNotificationProvider).showToast('Ami supprimé.');
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              ref
                  .read(internalNotificationProvider)
                  .showErrorToast('Impossible de supprimer cet ami.');
            }
          },
        ),
      ],
    ),
  );
}
