import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_iq/services/user_preferences_service.dart';
import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';

void main() {
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
}
