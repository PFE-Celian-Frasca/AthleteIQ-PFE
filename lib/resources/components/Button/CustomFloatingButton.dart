import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Object? heroTag;
  final IconData? icon;
  final Color? iconColor;
  final String? tooltip;
  final Widget? loadingWidget;

  const CustomFloatingButton({
    super.key,
    this.onPressed,
    required this.backgroundColor,
    this.heroTag,
    this.icon,
    this.iconColor,
    this.tooltip,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      heroTag: heroTag,
      backgroundColor: backgroundColor,
      tooltip: tooltip,
      child: loadingWidget ?? Icon(icon, color: iconColor, size: 25.sp),
    );
  }
}