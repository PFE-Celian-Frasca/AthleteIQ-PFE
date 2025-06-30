import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


Widget noGroupWidget(WidgetRef ref, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 200.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Vous n'avez rejoint aucun groupe, tapez sur l'icône pour créer un groupe. Vous pouvez aussi en chercher un depuis le bouton de recherche en haut.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium
        )
      ],
    ),
  );
}
