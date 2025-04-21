// notification_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/notification_service.dart';
import '../auth/auth_provider.dart';
import 'notification_state.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref);
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref _ref;

  NotificationNotifier(this._ref) : super(const NotificationState.initial()) {
    loadNotifications(); // Appelez cette méthode si vous souhaitez charger les notifications au démarrage
  }

  Future<void> loadNotifications() async {
    final userId = _ref.read(authProvider).maybeWhen(
          authenticated: (user) => user.uid,
          orElse: () => null,
        );
    state = const NotificationState.loading();
    if (userId == null) return;
    try {
      final notifications = await _ref
          .read(notificationService)
          .fetchNotificationsForUser(userId);
      state = NotificationState.loaded(notifications);
    } catch (e) {
      state = NotificationState.error(e.toString());
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      if (await _ref.read(notificationService).markAsRead(notificationId)) {
        state.maybeWhen(
          loaded: (notifications) {
            final updatedNotifications = notifications.map((notification) {
              if (notification.id == notificationId) {
                return notification.copyWith(
                    isRead: true, readAt: DateTime.now());
              }
              return notification;
            }).toList();
            state = NotificationState.loaded(updatedNotifications);
          },
          orElse: () {},
        );
      }
    } catch (e) {
      state = NotificationState.error(e.toString());
    }
  }

  void resetState() {
    state = const NotificationState.initial();
  }
}
