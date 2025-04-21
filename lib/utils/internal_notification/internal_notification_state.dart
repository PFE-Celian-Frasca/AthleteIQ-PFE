import 'package:freezed_annotation/freezed_annotation.dart';

part 'internal_notification_state.freezed.dart';

@freezed
class InternalNotificationState with _$InternalNotificationState {
  const factory InternalNotificationState.initial() = Initial;
  const factory InternalNotificationState.toast(String message) = ToastState;
  const factory InternalNotificationState.errorToast(String message) =
      FlushBarState;
}
