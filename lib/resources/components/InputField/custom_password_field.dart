import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPasswordField extends StatelessWidget {
  final BuildContext context;
  final String label;
  final TextEditingController? controller;
  final bool isObscure;
  final VoidCallback toggleObscure;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    super.key,
    required this.context,
    required this.label,
    this.controller,
    required this.isObscure,
    required this.toggleObscure,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            onPressed: toggleObscure,
          ),
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
