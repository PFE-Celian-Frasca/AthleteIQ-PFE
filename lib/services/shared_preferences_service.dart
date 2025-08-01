import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((ref) {
  return SharedPreferencesService();
});

class SharedPreferencesService {
  SharedPreferencesService();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Sauvegarder une valeur String
  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  // Lire une valeur String
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  // Sauvegarder une valeur bool
  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  // Lire une valeur bool
  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  // Sauvegarder une valeur int
  Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  // Lire une valeur int
  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  // Sauvegarder une valeur double
  Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  // Lire une valeur double
  Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  // Sauvegarder une liste de Strings
  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    await prefs.setStringList(key, value);
  }

  // Lire une liste de Strings
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  // Supprimer une clé
  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  // Sauvegarder un objet complexe (par exemple, un modèle)
  Future<void> setObject(String key, dynamic jsonSerializableObject) async {
    final prefs = await _prefs;
    final String jsonString = json.encode(jsonSerializableObject);
    await prefs.setString(key, jsonString);
  }

  // Lire un objet complexe
  Future<dynamic> getObject(String key, Function fromJson) async {
    final prefs = await _prefs;
    final String? jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return fromJson(json.decode(jsonString));
  }

  // Effacer toutes les données
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
