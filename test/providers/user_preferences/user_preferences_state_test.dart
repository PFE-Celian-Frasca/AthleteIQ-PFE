import 'package:flutter_test/flutter_test.dart';

import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';
import 'package:athlete_iq/providers/user_preference/user_preferences_state.dart';

void main() {
  const prefs = UserPreferencesModel(
    receiveNotifications: true,
    darkModeEnabled: false,
    language: 'en',
  );

  group('UserPreferencesState', () {
    test('initial state', () {
      const state = UserPreferencesState.initial();

      expect(state.maybeWhen(initial: () => true, orElse: () => false), isTrue);
    });

    test('loading state', () {
      const state = UserPreferencesState.loading();

      expect(state.maybeWhen(loading: () => true, orElse: () => false), isTrue);
    });

    test('loaded state exposes preferences', () {
      const state = UserPreferencesState.loaded(prefs);

      expect(state.maybeWhen(loaded: (_) => true, orElse: () => false), isTrue);

      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (p) => expect(p, prefs),
        error: (_) => fail('Should not be error'),
      );
    });

    test('error state exposes message', () {
      const msg = 'cache read failure';
      const state = UserPreferencesState.error(msg);

      expect(state.maybeWhen(error: (_) => true, orElse: () => false), isTrue);

      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (_) => fail('Should not be loaded'),
        error: (m) => expect(m, msg),
      );
    });
  });
}
