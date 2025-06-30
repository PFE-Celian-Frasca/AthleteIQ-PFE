import 'package:athlete_iq/providers/user_preference/user_preferences_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/user_prefereces/user_preferences_model.dart';
import '../../services/user_preferences_service.dart';

final userPreferencesNotifierProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferencesState>((ref) {
  return UserPreferencesNotifier(ref.read(userPreferencesServiceProvider));
});

class UserPreferencesNotifier extends StateNotifier<UserPreferencesState> {
  final UserPreferencesService _service;

  UserPreferencesNotifier(this._service)
      : super(const UserPreferencesState.initial());

  Future<void> loadPreferences(String userId) async {
    state = const UserPreferencesState.loading();
    try {
      final preferences = await _service.getPreferences(userId);
      state = UserPreferencesState.loaded(preferences);
    } catch (e) {
      state = UserPreferencesState.error(e.toString());
    }
  }

  Future<void> updatePreferences(
      String userId, UserPreferencesModel preferences) async {
    try {
      await _service.updatePreferences(userId, preferences);
      // Après la mise à jour, rechargez les préférences pour mettre à jour l'état
      await loadPreferences(userId);
    } catch (e) {
      state = UserPreferencesState.error(e.toString());
    }
  }

  void resetState() {
    state = const UserPreferencesState.initial();
  }
}
