import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/utils/internal_notification/flushbar.dart';

class InternalNotificationService {
  void showToast(String message) {
    FlushBarUtils.toastMessage(message);
  }

  void showErrorToast(String message) {
    FlushBarUtils.toastErrorMessage(message);
  }
}

final internalNotificationProvider = Provider<InternalNotificationService>((ref) {
  return InternalNotificationService();
});

void handleError(Object e, String operation) {
  final errorMsg = "Failed to $operation: $e";
  if (kDebugMode) {
    print(errorMsg);
  }
  throw Exception(errorMsg);
}
