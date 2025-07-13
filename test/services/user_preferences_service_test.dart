import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:athlete_iq/services/user_preferences_service.dart';
import 'package:athlete_iq/models/user_prefereces/user_preferences_model.dart';

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic>? _data;
  FakeDocumentSnapshot(this._data);
  @override
  bool get exists => _data != null;
  @override
  Map<String, dynamic>? data() => _data;
}

class FakeSubDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  Map<String, dynamic>? setData;
  Map<String, dynamic>? dataToReturn;
  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) async {
    setData = data;
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    return FakeDocumentSnapshot(dataToReturn);
  }
}

class FakeSubCollection extends Fake implements CollectionReference<Map<String, dynamic>> {
  final FakeSubDoc docRef = FakeSubDoc();
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) => docRef;
}

class FakeDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  Map<String, dynamic>? dataToReturn;
  final FakeSubCollection subCollection = FakeSubCollection();
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    return FakeDocumentSnapshot(dataToReturn);
  }

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) => subCollection;
}

class FakeCollection extends Fake implements CollectionReference<Map<String, dynamic>> {
  final FakeDoc docRef = FakeDoc();
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) => docRef;
}

class FakeFirestore extends Fake implements FirebaseFirestore {
  final FakeCollection collectionRef = FakeCollection();
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) => collectionRef;
}

void main() {
  test('getPreferences returns default when none exists', () async {
    final firestore = FakeFirestore();
    final service = UserPreferencesService(firestore);
    firestore.collectionRef.docRef.subCollection.docRef.dataToReturn = null;
    final prefs = await service.getPreferences('u');
    expect(prefs, const UserPreferencesModel());
  });

  test('updatePreferences writes data', () async {
    final firestore = FakeFirestore();
    final service = UserPreferencesService(firestore);
    const prefs = UserPreferencesModel(language: 'en');
    await service.updatePreferences('u', prefs);
    expect(firestore.collectionRef.docRef.subCollection.docRef.setData, prefs.toJson());
  });
}
