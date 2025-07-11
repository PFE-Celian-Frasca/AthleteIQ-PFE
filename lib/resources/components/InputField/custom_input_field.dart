import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputField extends StatelessWidget {
  final BuildContext context;
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? initialValue;
  final bool? autocorrect;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final IconData? icon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.context,
    required this.label,
    this.controller,
    this.keyboardType,
    this.initialValue,
    this.autocorrect,
    this.maxLines,
    this.textCapitalization,
    this.textInputAction,
    this.icon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        initialValue: initialValue,
        autocorrect: autocorrect ?? false,
        maxLines: maxLines,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
