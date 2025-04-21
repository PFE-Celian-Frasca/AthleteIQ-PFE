import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'internal_notification_state.dart';

class NotificationNotifier extends StateNotifier<InternalNotificationState> {
  NotificationNotifier() : super(const InternalNotificationState.initial());

  void showToast(String message) =>
      state = InternalNotificationState.toast(message);

  void showErrorToast(String message) =>
      state = InternalNotificationState.errorToast(message);
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, InternalNotificationState>(
  (ref) => NotificationNotifier(),
);

void handleError(e, String operation) {
  final errorMsg = "Failed to $operation: $e";
  if (kDebugMode) {
    print(errorMsg);
  }
  throw Exception(errorMsg);
}
