import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';

part 'user_preferences_state.freezed.dart';

@freezed
class UserPreferencesState with _$UserPreferencesState {
  const factory UserPreferencesState.initial() = _Initial;
  const factory UserPreferencesState.loading() = _Loading;
  const factory UserPreferencesState.loaded(UserPreferencesModel preferences) = _Loaded;
  const factory UserPreferencesState.error(String message) = _Error;
}
