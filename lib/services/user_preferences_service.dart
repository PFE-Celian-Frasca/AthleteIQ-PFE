import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';

final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  return UserPreferencesService(FirebaseFirestore.instance);
});

class UserPreferencesService {
  final FirebaseFirestore _firestore;

  UserPreferencesService(this._firestore);

  Future<UserPreferencesModel> getPreferences(String userId) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('userPreferences')
        .get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return UserPreferencesModel.fromJson(docSnapshot.data()!);
    } else {
      // Si aucun document n'existe, on renvoie des préférences par défaut
      return const UserPreferencesModel();
    }
  }

  Future<void> updatePreferences(String userId, UserPreferencesModel preferences) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('userPreferences')
        .set(preferences.toJson(), SetOptions(merge: true));
  }
}
