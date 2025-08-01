import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_iq/services/user_preferences_service.dart';
import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('provider exposes service', () {
    final container = ProviderContainer(overrides: [
      userPreferencesServiceProvider.overrideWithValue(
        UserPreferencesService(FakeFirebaseFirestore()),
      ),
    ]);
    expect(container.read(userPreferencesServiceProvider), isA<UserPreferencesService>());
  });
  test('getPreferences returns default when none exists', () async {
    final firestore = FakeFirebaseFirestore();
    final service = UserPreferencesService(firestore);
    final prefs = await service.getPreferences('u');
    expect(prefs, const UserPreferencesModel());
  });

  test('updatePreferences writes data', () async {
    final firestore = FakeFirebaseFirestore();
    final service = UserPreferencesService(firestore);
    const prefs = UserPreferencesModel(language: 'en');
    await service.updatePreferences('u', prefs);
    final doc = await firestore
        .collection('users')
        .doc('u')
        .collection('preferences')
        .doc('userPreferences')
        .get();
    expect(doc.data(), prefs.toJson());
  });

  test('getPreferences returns stored value when exists', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('u')
        .collection('preferences')
        .doc('userPreferences')
        .set(const UserPreferencesModel(language: 'fr').toJson());
    final service = UserPreferencesService(firestore);
    final prefs = await service.getPreferences('u');
    expect(prefs.language, 'fr');
  });
}
