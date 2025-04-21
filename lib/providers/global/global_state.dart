import 'package:freezed_annotation/freezed_annotation.dart';

import '../auth/auth_state.dart';
import '../notification/notification_state.dart';
import '../user/user_state.dart';
import '../user_preference/user_preferences_state.dart';

part 'global_state.freezed.dart';

@freezed
class GlobalState with _$GlobalState {
  const factory GlobalState({
    @Default(AuthState.initial()) AuthState authState,
    @Default(NotificationState.initial()) NotificationState notificationState,
    @Default(UserState.initial()) UserState userState,
    @Default(UserPreferencesState.initial())
    UserPreferencesState userPreferencesState,
    @Default(false) bool isLoading, // Ajout de l'état de chargement
  }) = _GlobalState;
}
