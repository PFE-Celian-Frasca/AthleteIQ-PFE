import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final bool enabled;
  final Widget? loadingWidget;
  final double? sizedBoxWidth;
  final double? sizedBoxHeight;

  const CustomElevatedButton({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.enabled = true,
    this.loadingWidget,
    this.sizedBoxHeight,
    this.sizedBoxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: sizedBoxWidth ?? double.infinity,
      height: sizedBoxHeight ?? 45.h,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: loadingWidget == null
            ? Icon(icon, color: iconColor ?? theme.colorScheme.onPrimary)
            : const SizedBox
                .shrink(), // Ensure the icon doesn't take space when there is a loading widget
        label: loadingWidget ??
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0), // Adding padding to the label for better balance
              child: Text(
                text ?? '',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: textColor ?? theme.colorScheme.onPrimary,
                ),
              ),
            ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? backgroundColor : theme.colorScheme.surfaceContainerHighest,
          disabledForegroundColor: backgroundColor?.withValues(alpha: 0.5).withValues(alpha: 0.38),
          disabledBackgroundColor: backgroundColor?.withValues(alpha: 0.5).withValues(alpha: 0.12),
          minimumSize: Size(double.infinity, 40.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          padding: EdgeInsets.symmetric(
              horizontal: 12.h, vertical: 12.h), // Uniform padding for better balance
          elevation: enabled ? 2 : 0,
          alignment: Alignment.center, // Aligns the button's content to the left
        ),
      ),
    );
  }
}
