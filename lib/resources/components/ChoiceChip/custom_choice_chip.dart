import 'package:flutter/material.dart';

class CustomChoiceChipSelector<T> extends StatelessWidget {
  final String title;
  final Map<T, String> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;
  final Color? backgroundColor;

  const CustomChoiceChipSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: options.entries.map((entry) {
            return ChoiceChip(
              label: Text(entry.value),
              selected: selectedValue == entry.key,
              onSelected: (bool selected) {
                if (selected) {
                  onSelected(entry.key);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              labelStyle: TextStyle(
                color: selectedValue == entry.key
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: selectedValue == entry.key ? Colors.transparent : Colors.transparent,
                ),
              ),
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }
}
