import 'package:athlete_iq/providers/groupe/group_state.dart';
import 'package:athlete_iq/providers/location/location_provider.dart';
import 'package:athlete_iq/providers/parcour/parcours_provider.dart';
import 'package:athlete_iq/providers/parcour/parcours_state.dart';
import 'package:athlete_iq/utils/internal_notification/flushbar.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_provider.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_provider.dart';
import '../auth/auth_state.dart';
import '../user/user_provider.dart';
import '../user/user_state.dart';
import '../notification/notification_provider.dart';
import '../notification/notification_state.dart';
import '../user_preference/user_preferences_provider.dart';
import '../user_preference/user_preferences_state.dart';
import 'global_state.dart';

final globalProvider =
    StateNotifierProvider<GlobalNotifier, GlobalState>((ref) {
  return GlobalNotifier(ref);
});

class GlobalNotifier extends StateNotifier<GlobalState> {
  final Ref ref;

  GlobalNotifier(this.ref) : super(const GlobalState()) {
    _initState();
  }

  void _initState() {
    ref.listen<AuthState>(authProvider, (_, state) => _handleAuthState(state));
    ref.listen<NotificationState>(
        notificationProvider, (_, state) => _handleNotificationState(state));
    ref.listen<UserState>(userProvider, (_, state) => _handleUserState(state));
    ref.listen<UserPreferencesState>(userPreferencesNotifierProvider,
        (_, state) => _handleUserPreferencesState(state));
    ref.listen<ParcoursState>(
        parcoursProvider, (_, state) => _handleParcoursState(state));
    ref.listen<InternalNotificationState>(notificationNotifierProvider,
        (_, state) => _handleInternalNotification(state));
  }

  void _handleParcoursState(ParcoursState state) {
    state.maybeWhen(
        orElse: () {},
        error: (String error) => ref
            .read(notificationNotifierProvider.notifier)
            .showErrorToast(error));
  }

  void _handleInternalNotification(InternalNotificationState state) {
    state.when(
      initial: () {},
      toast: (message) {
        print(message);
        // Montre un toast
        FlushBarUtils.toastMessage(message);
      },
      errorToast: (message) {
        print(message);
        // Montre un Flushbar
        FlushBarUtils.toastErrorMessage(message);
      },
    );
  }

  void _handleAuthState(AuthState state) {
    state.when(
        initial: () {},
        authenticated: (User user) {
          loadUserProfile(user.uid);
          loadUserPreferences(user.uid);
          loadNotifications();
          this.state = this.state.copyWith(authState: state);
        },
        unauthenticated: () {
          resetAllStates();
          this.state = this.state.copyWith(authState: state);
        },
        error: (String message) {
          ref
              .read(notificationNotifierProvider.notifier)
              .showErrorToast(message);
          this.state = this.state.copyWith(authState: state);
        },
        loading: () {});
  }

  void _handleUserState(UserState state) {
    state.maybeWhen(
        orElse: () {},
        error: (String error) => ref
            .read(notificationNotifierProvider.notifier)
            .showErrorToast(error));
    this.state = this.state.copyWith(userState: state);
  }

  void _handleNotificationState(NotificationState state) {
    this.state = this.state.copyWith(notificationState: state);
  }

  void _handleUserPreferencesState(UserPreferencesState state) {
    this.state = this.state.copyWith(userPreferencesState: state);
  }

  void _handleGroupState(GroupState state) {
    state.maybeWhen(
        orElse: () {},
        error: (String error) => ref
            .read(notificationNotifierProvider.notifier)
            .showErrorToast(error));
  }

  Future<void> loadUserProfile(String userId) async {
    await ref.read(userProvider.notifier).loadUserProfile(userId);
  }

  Future<void> loadUserPreferences(String userId) async {
    await ref
        .read(userPreferencesNotifierProvider.notifier)
        .loadPreferences(userId);
  }

  Future<void> loadNotifications() async {
    await ref.read(notificationProvider.notifier).loadNotifications();
  }

  Future<void> signOutUser() async {
    await ref.read(authProvider.notifier).signOut();
    resetAllStates();
  }

  Future<void> deleteUserAccount(String userId) async {
    try {
      await ref.read(authProvider.notifier).deleteAccount();
      await ref.read(userProvider.notifier).deleteUser(userId);
      await ref
          .read(parcoursProvider.notifier)
          .deleteAllParcoursForUser(userId);
      resetAllStates();
    } catch (e) {
      return;
    }
    resetAllStates();
  }

  void resetAllStates() {
    ref.read(userProvider.notifier).resetState();
    ref.read(notificationProvider.notifier).resetState();
    ref.read(userPreferencesNotifierProvider.notifier).resetState();
    state = const GlobalState(); // Resets global state to initial
  }
}
