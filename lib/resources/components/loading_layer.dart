import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingLayer extends StatelessWidget {
  const LoadingLayer({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Stack(
      children: [
        child,
        Consumer(
          builder: (context, ref, child) {
            return Material(
              color: scheme.surfaceVariant.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}
