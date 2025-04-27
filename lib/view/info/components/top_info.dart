import 'dart:io';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/global_methods.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BuildTopInfo extends HookConsumerWidget {
  final String userId;

  const BuildTopInfo({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userStateChangesProvider(userId));

    return userStream.when(
      data: (user) {
        if (user != null) {
          return _buildUserInfo(context, ref, user);
        } else {
          return const Center(
            child: Text('Erreur lors du chargement de l\'utilisateur'),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(
        child: Text('Erreur lors du chargement de l\'utilisateur'),
      ),
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
                    File? imageFile = await pickImage(
                      fromCamera: false,
                      onFail: (message) => ref
                          .read(internalNotificationProvider)
                          .showErrorToast(message),
                    );

                    if (imageFile != null) {
                      // Crop the image
                      CroppedFile? croppedFile = await ImageCropper().cropImage(
                        sourcePath: imageFile.path,
                        maxHeight: 800.h.toInt(),
                        maxWidth: 800.w.toInt(),
                        compressQuality: 90,
                      );

                      if (croppedFile != null) {
                        String imageUrl = await storeFileToStorage(
                          file: File(croppedFile.path),
                          reference: 'userImages/${user.id}',
                        );
                        await ref
                            .read(userRepositoryProvider)
                            .updateUser(user.copyWith(image: imageUrl));
                        ref
                            .read(internalNotificationProvider)
                            .showToast('Image mise à jour avec succès.');
                      }
                    }
                  } catch (e) {
                    if (e is PlatformException &&
                        e.code == 'photo_access_denied') {
                      if (context.mounted) {
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
                      }
                    } else {
                      ref.read(internalNotificationProvider).showErrorToast(
                          "Erreur lors de la mise à jour de l'image: $e");
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
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
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
}
