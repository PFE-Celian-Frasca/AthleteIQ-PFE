import 'package:athlete_iq/resources/components/Button/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParcourOverlayWidget extends StatelessWidget {
  final String title;
  final String ownerName;
  final VoidCallback onViewDetails;

  const ParcourOverlayWidget({
    super.key,
    required this.title,
    required this.ownerName,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 150.h,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Text("Créé par : $ownerName",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            CustomElevatedButton(
              sizedBoxHeight: 0.06.sh,
              sizedBoxWidth: double.infinity,
              icon: Icons.visibility,
              text: 'Voir les détails',
              onPressed: onViewDetails,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
