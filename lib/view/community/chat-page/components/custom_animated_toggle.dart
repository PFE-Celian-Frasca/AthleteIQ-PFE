import 'package:flutter/material.dart';

class CustomAnimatedToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomAnimatedToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: value ? Colors.blue : Colors.grey[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: value ? 30.0 : 0.0,
              right: value ? 0.0 : 30.0,
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.all(3.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
