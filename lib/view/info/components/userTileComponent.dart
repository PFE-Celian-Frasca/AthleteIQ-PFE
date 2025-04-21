import 'package:athlete_iq/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../resources/components/ConfirmationDialog/CustomConfirmationDialog.dart';

Widget userTile(
    UserModel user, BuildContext context, WidgetRef ref, bool friendRequest) {
  return Padding(
    padding: EdgeInsets.only(top: 10.h, right: 5.h, left: 5.h),
    child: Material(
      elevation: 3.0,
      shadowColor: Theme.of(context).colorScheme.onBackground,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.r), // Ajusté pour la responsivité
      ),
      child: ListTile(
        onTap: () {},
        leading: user.image.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(user.image),
                radius: 33.r, // Ajusté pour la responsivité
              )
            : null,
        title: Text(
          user.pseudo,
          style: Theme.of(context)
              .textTheme
              .titleSmall, // Ajusté pour la responsivité
        ),
        subtitle: Text(
          friendRequest
              ? "Vous demande en ami"
              : "Depuis lundi ${user.totalDist.toStringAsFixed(2)} Km",
          style: Theme.of(context)
              .textTheme
              .bodySmall, // Ajusté pour la responsivité
        ),
        trailing: friendRequest
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      /*ref
                          .read(friendsViewModelProvider)
                          .valideInvalideFriend(user, true);*/
                    },
                    icon: Icon(MdiIcons.accountCheck,
                        size: 24.r), // Ajusté pour la responsivité
                  ),
                  IconButton(
                    onPressed: () {
                      /* ref
                          .read(friendsViewModelProvider)
                          .valideInvalideFriend(user, false);*/
                    },
                    icon: Icon(MdiIcons.accountCancel,
                        size: 24.r), // Ajusté pour la responsivité
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
}

// Cette fonction peut être déclarée à l'intérieur de votre widget ou dans un fichier séparé si vous prévoyez de la réutiliser à travers l'application.
void showDeleteFriendConfirmationDialog(
    BuildContext context, UserModel user, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => CustomConfirmationDialog(
      title: "Supprimer cet ami",
      content: "Êtes-vous sur de vouloir supprimer cet ami ?",
      onConfirm: () async {
        /* try {
          await ref.read(friendsViewModelProvider).removeFriend(user);
          Navigator.pop(context); // Fermer le dialogue après la suppression
        } catch (e) {
          */ /*Utils.flushBarErrorMessage(e.toString(), context);*/ /*
        }*/
      },
      onCancel: () => Navigator.pop(context),
      // Fermer le dialogue sans action
      confirmText: "Supprimer",
      backgroundColor: Theme.of(context)
          .colorScheme
          .error, // Optionnel: spécifiez la couleur de fond pour l'en-tête
    ),
  );
}
