import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaracteristiqueWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;
  final String unit;

  const CaracteristiqueWidget({
    super.key,
    required this.iconData,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(iconData, size: 20.sp, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text("$value ", style: Theme.of(context).textTheme.bodyMedium),
          Text(unit, style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.tertiary)
          ),
        ],
      ),
    );
  }
}
