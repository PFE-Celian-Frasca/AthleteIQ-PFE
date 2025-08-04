import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((ref) {
  return SharedPreferencesService();
});

class SharedPreferencesService {
  SharedPreferencesService();

  // Sauvegarder une valeur String
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Lire une valeur String
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Sauvegarder une valeur bool
  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Lire une valeur bool
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Sauvegarder une valeur int
  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Lire une valeur int
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Sauvegarder une valeur double
  Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Lire une valeur double
  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Sauvegarder une liste de Strings
  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  // Lire une liste de Strings
  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // Supprimer une clé
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Effacer toutes les préférences
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Sauvegarder un objet JSON-serializable
  Future<void> setObject(String key, dynamic jsonSerializableObject) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(jsonSerializableObject);
    await prefs.setString(key, jsonString);
  }

  // Lire un objet JSON et le désérialiser
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    final Map<String, dynamic> decoded = json.decode(jsonString) as Map<String, dynamic>;
    return fromJson(decoded);
  }
}
