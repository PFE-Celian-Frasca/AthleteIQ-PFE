import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/info/components/show_delete_friend_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget userTile(
    UserModel user, BuildContext context, WidgetRef ref, bool friendRequest) {
  final currentUser = ref.watch(authRepositoryProvider).currentUser;
  if (currentUser == null) {
    return const Center(child: Text("Aucun utilisateur connecté"));
  }

  final userId = currentUser.uid;
  final currentUserStream = ref.watch(userStateChangesProvider(userId));

  return currentUserStream.when(
    data: (currentUser) {
      if (currentUser != null) {
        return Padding(
          padding: EdgeInsets.only(top: 10.h, right: 5.h, left: 5.h),
          child: Material(
            elevation: 3.0,
            shadowColor: Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: ListTile(
              onTap: () {},
              leading: user.image.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                      radius: 33.r,
                    )
                  : null,
              title: Text(
                user.pseudo,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text(
                friendRequest
                    ? "Vous demande en ami"
                    : "Depuis lundi ${user.totalDist.toStringAsFixed(2)} Km",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: friendRequest
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            try {
                              await ref
                                  .read(userRepositoryProvider)
                                  .acceptFriendRequest(
                                      userId: currentUser.id,
                                      friendId: user.id);
                              ref
                                  .read(internalNotificationProvider)
                                  .showToast('Demande d\'ami acceptée.');
                            } catch (e) {
                              ref
                                  .read(internalNotificationProvider)
                                  .showErrorToast(
                                      'Impossible d\'accepter la demande d\'ami.');
                            }
                          },
                          icon: Icon(MdiIcons.accountCheck, size: 24.r),
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await ref
                                  .read(userRepositoryProvider)
                                  .denyFriendRequest(
                                      userId: currentUser.id,
                                      friendId: user.id);
                              ref
                                  .read(internalNotificationProvider)
                                  .showToast('Demande d\'ami refusée.');
                            } catch (e) {
                              ref
                                  .read(internalNotificationProvider)
                                  .showErrorToast(
                                      'Impossible de refuser la demande d\'ami.');
                            }
                          },
                          icon: Icon(MdiIcons.accountCancel, size: 24.r),
                        )
                      ],
                    )
                  : IconButton(
                      icon: Icon(MdiIcons.accountCancel, size: 24.r),
                      onPressed: () {
                        showDeleteFriendConfirmationDialog(context, user, ref);
                      },
                    ),
            ),
          ),
        );
      } else {
        return const Center(
            child: Text('Erreur lors du chargement de l\'utilisateur'));
      }
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => const Center(
        child: Text('Erreur lors du chargement de l\'utilisateur')),
  );
}
