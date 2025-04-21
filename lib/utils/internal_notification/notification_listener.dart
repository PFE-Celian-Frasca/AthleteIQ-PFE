import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'internal_notification_provider.dart';

class NotificationListener extends ConsumerWidget {
  final Widget child;

  const NotificationListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationNotifierProvider);

    // Utilisation de Freezed pour réagir différemment selon l'état

    return child;
  }
}
