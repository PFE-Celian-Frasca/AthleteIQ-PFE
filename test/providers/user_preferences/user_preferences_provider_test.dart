import 'package:athlete_iq/providers/user_preference/user_preferences_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';
import 'package:athlete_iq/providers/user_preference/user_preferences_state.dart';
import 'package:athlete_iq/services/user_preferences_service.dart';

/// ---------------- Mocks ----------------------------------------------------
class MockPrefsService extends Mock implements UserPreferencesService {}

void main() {
  const userId = 'u1';

  // fixture de préférences
  const prefs = UserPreferencesModel(
    receiveNotifications: true,
    darkModeEnabled: false,
    language: 'en',
  );

  // fallback nécessaire à mocktail (UserPreferencesModel)
  setUpAll(() {
    registerFallbackValue(prefs);
  });

  late MockPrefsService mockService;
  late ProviderContainer container;
  late UserPreferencesNotifier notifier;

  setUp(() {
    mockService = MockPrefsService();
    container = ProviderContainer(overrides: [
      userPreferencesServiceProvider.overrideWithValue(mockService),
    ]);
    addTearDown(container.dispose);

    notifier = container.read(userPreferencesNotifierProvider.notifier);
  });

  group('UserPreferencesNotifier', () {
    test('loadPreferences → success', () async {
      when(() => mockService.getPreferences(userId)).thenAnswer((_) async => prefs);

      await notifier.loadPreferences(userId);

      final state = container.read(userPreferencesNotifierProvider);
      state.when(
        initial: () => fail('should not be initial'),
        loading: () => fail('should not be loading'),
        error: (_) => fail('should not be error'),
        loaded: (p) => expect(p, prefs),
      );
    });

    test('loadPreferences → error', () async {
      when(() => mockService.getPreferences(userId)).thenThrow(Exception('db'));

      await notifier.loadPreferences(userId);

      final state = container.read(userPreferencesNotifierProvider);
      expect(
        state.maybeWhen(error: (_) => true, orElse: () => false),
        isTrue,
      );
    });

    test('updatePreferences appelle service + reload', () async {
      // stub update
      when(() => mockService.updatePreferences(userId, prefs)).thenAnswer((_) async {});
      // stub getPreferences pour le reload
      when(() => mockService.getPreferences(userId)).thenAnswer((_) async => prefs);

      await notifier.updatePreferences(userId, prefs);

      verify(() => mockService.updatePreferences(userId, prefs)).called(1);
      // l'état doit finir en loaded
      expect(
        container
            .read(userPreferencesNotifierProvider)
            .maybeWhen(loaded: (_) => true, orElse: () => false),
        isTrue,
      );
    });

    test('resetState remet à initial', () {
      notifier.resetState();
      expect(container.read(userPreferencesNotifierProvider), const UserPreferencesState.initial());
    });
  });
}
