import 'package:athlete_iq/providers/parcour_recording/parcours_recording_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoBtn extends ConsumerWidget {
  final VoidCallback onTap; // Ajout d'un callback comme paramètre

  const GoBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcoursRecordingState = ref.read(parcoursRecordingNotifierProvider);

    return GestureDetector(
      onTap: onTap, // Utilisation du callback passé comme paramètre
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 50.h,
        width: parcoursRecordingState.isRecording ? 120.w : 60.w,
        decoration: BoxDecoration(
          color: parcoursRecordingState.isRecording
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Center(
          child: Text(
            parcoursRecordingState.isRecording ? 'STOP' : 'GO',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
