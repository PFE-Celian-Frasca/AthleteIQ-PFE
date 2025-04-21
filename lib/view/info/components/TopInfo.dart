import 'dart:io';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/user/user_provider.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget buildTopInfo(BuildContext context, WidgetRef ref) {
  final userState =
      ref.watch(globalProvider.select((state) => state.userState));

  return userState.when(
    initial: () => const Center(child: Text('Welcome!')),
    loading: () => const Center(child: CircularProgressIndicator()),
    loaded: (user) => _buildUserInfo(context, ref, user),
    error: (message) => Center(child: Text('Error: $message')),
  );
}

Widget _buildUserInfo(BuildContext context, WidgetRef ref, UserModel user) {
  int remainingDays = DateTime.sunday - DateTime.now().weekday;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (picked != null) {
                    File imageFile = File(picked.path);
                    ref
                        .read(userProvider.notifier)
                        .updateUserImage(user.id, imageFile);
                  } else {
                    return;
                  }
                } catch (e) {
                  // Capture spécifiquement les erreurs de permission refusée
                  if (e is PlatformException &&
                      e.code == 'photo_access_denied') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Permission requise'),
                        content: const Text(
                            'Cette fonctionnalité nécessite un accès à vos photos. Veuillez activer cette permission dans les paramètres de votre appareil.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Fermer'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ref
                        .read(notificationNotifierProvider.notifier)
                        .showErrorToast(
                            "Erreur lors de la mise à jour de l'image");
                  }
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  user.image,
                  width: 0.3.sw,
                  height: 0.4.sw,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.pseudo,
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Objectif hebdo: ${user.objectif} Km",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 4.h),
                  LinearPercentIndicator(
                    width: 0.5.sw,
                    lineHeight: 20.h,
                    animation: true,
                    animationDuration: 2000,
                    percent: calculatePercent(user.objectif, user.totalDist),
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    progressColor: Theme.of(context).colorScheme.primary,
                    center: Text(
                      "${(calculatePercent(user.objectif, user.totalDist) * 100).toStringAsFixed(0)}%",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                    barRadius: Radius.circular(15.r),
                  ),
                  if (remainingDays > 0) ...[
                    Text(
                      "plus que $remainingDays jours...",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.settings, size: 24.sp), // Adjust size as needed
            onPressed: () {
              GoRouter.of(context).go('/info/settings');
            },
          ),
        ),
      ],
    ),
  );
}

double calculatePercent(double goal, double current) {
  return (goal > 0) ? (current / goal).clamp(0.0, 1.0) : 0.0;
}
