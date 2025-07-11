import 'dart:convert';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

part 'parcours_repository.g.dart';

class ParcoursRepository {
  ParcoursRepository(this._db, this._storage);
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  Future<void> addParcours(ParcoursModel parcours, List<LocationDataModel> locationData) async {
    final DocumentReference documentReference = _db.collection('parcours').doc();
    final String jsonData = jsonEncode(locationData.map((e) => e.toJson()).toList());
    final Reference storageRef = _storage.ref('parcours_data/${documentReference.id}.json');
    try {
      final TaskSnapshot snapshot = await storageRef.putString(jsonData);
      final String url = await snapshot.ref.getDownloadURL();

      final parcourWithUrl = parcours.copyWith(id: documentReference.id, parcoursDataUrl: url);
      await _db.collection('parcours').doc(parcourWithUrl.id).set(parcourWithUrl.toJson());
    } catch (e) {
      await storageRef.delete();
      throw Exception("Failed to upload parcours data: $e");
    }
  }

  Future<void> deleteParcours(String parcoursId) async {
    try {
      await _db.collection('parcours').doc(parcoursId).delete();
      await _storage.ref('parcours_data/$parcoursId.json').delete();
    } catch (e) {
      throw Exception("Failed to delete parcours: $e");
    }
  }

  Future<void> deleteAllParcoursForUser(String userId) async {
    try {
      final querySnapshot =
          await _db.collection('parcours').where('owner', isEqualTo: userId).get();
      for (final doc in querySnapshot.docs) {
        await deleteParcours(doc.id);
      }
    } catch (e) {
      throw Exception("Failed to delete all parcours for user: $e");
    }
  }

  Future<void> updateParcours(ParcoursModel updatedParcours) async {
    try {
      await _db.collection('parcours').doc(updatedParcours.id).update(updatedParcours.toJson());
    } catch (e) {
      throw Exception("Failed to update parcours: $e");
    }
  }

  Future<void> updateParcoursById(String parcoursId, Map<String, dynamic> updates) async {
    try {
      await _db.collection('parcours').doc(parcoursId).update(updates);
    } catch (e) {
      throw Exception("Failed to update parcours: $e");
    }
  }

  Future<ParcoursModel> getParcoursById(String parcoursId) async {
    try {
      final docSnapshot = await _db.collection('parcours').doc(parcoursId).get();
      if (!docSnapshot.exists) {
        throw Exception('Parcours not found');
      }
      return ParcoursModel.fromJson(docSnapshot.data()!);
    } catch (e) {
      throw Exception("Failed to get parcours by ID: $e");
    }
  }

  Future<List<LocationDataModel>> getParcoursGPSData(String parcoursId) async {
    try {
      final String filePath = 'parcours_data/$parcoursId.json';
      final ref = _storage.ref().child(filePath);
      final String url = await ref.getDownloadURL();
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> gpsData = jsonDecode(response.body) as List<dynamic>;
        return gpsData
            .map((data) => LocationDataModel.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load parcours GPS data with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Failed to get parcours GPS data: $e");
    }
  }

  Future<ParcoursWithGPSData> getParcoursWithGPSData(String parcoursId) async {
    final parcours = await getParcoursById(parcoursId);
    final gpsData = await getParcoursGPSData(parcoursId);
    return ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);
  }

  Stream<ParcoursWithGPSData> streamParcoursWithGPSData(String parcoursId) async* {
    try {
      final docStream = _db.collection('parcours').doc(parcoursId).snapshots();
      await for (final snapshot in docStream) {
        if (!snapshot.exists) {
          yield* Stream.error('Parcours not found');
        }
        final parcours = ParcoursModel.fromJson(snapshot.data()!);
        final gpsData = await getParcoursGPSData(parcoursId);
        yield ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);
      }
    } catch (e) {
      yield* Stream.error("Failed to stream parcours data: $e");
    }
  }

  Stream<List<ParcoursWithGPSData>> getPublicParcoursStream() {
    return _db
        .collection('parcours')
        .where('type', isEqualTo: 'public')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        final parcoursList =
            snapshot.docs.map((doc) => ParcoursModel.fromJson(doc.data())).toList();
        return _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get public parcours stream: $e");
      }
    });
  }

  Stream<List<ParcoursWithGPSData>> getPrivateParcoursStream(String userId) {
    return _db
        .collection('parcours')
        .where('owner', isEqualTo: userId)
        .where('type', isEqualTo: 'private')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        final parcoursList =
            snapshot.docs.map((doc) => ParcoursModel.fromJson(doc.data())).toList();
        return _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get private parcours stream: $e");
      }
    });
  }

  Stream<List<ParcoursWithGPSData>> getSharedParcoursStream(String userId) {
    final ownerStream = _db
        .collection('parcours')
        .where('owner', isEqualTo: userId)
        .where('type', isEqualTo: 'shared')
        .snapshots()
        .asyncMap((snapshot) {
      try {
        final parcoursList =
            snapshot.docs.map((doc) => ParcoursModel.fromJson(doc.data())).toList();
        return _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get owner parcours stream: $e");
      }
    });

    final sharedStream = _db
        .collection('parcours')
        .where('type', isEqualTo: 'shared')
        .where('shareTo', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        final parcoursList =
            snapshot.docs.map((doc) => ParcoursModel.fromJson(doc.data())).toList();
        return _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get shared parcours stream: $e");
      }
    });

    return Rx.combineLatest2(ownerStream, sharedStream,
        (List<ParcoursWithGPSData> ownerList, List<ParcoursWithGPSData> sharedList) {
      return [...ownerList, ...sharedList];
    });
  }

  Stream<List<ParcoursWithGPSData>> getFavoritesParcoursStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().asyncMap((userSnapshot) async {
      if (!userSnapshot.exists) throw Exception('User not found.');
      try {
        final user = UserModel.fromJson(userSnapshot.data()!);
        if (user.fav.isEmpty) return <ParcoursWithGPSData>[];
        final favoriteParcoursSnapshots = await _db
            .collection('parcours')
            .where(FieldPath.documentId, whereIn: user.fav)
            .orderBy('createdAt', descending: true)
            .get();
        final parcoursList = favoriteParcoursSnapshots.docs
            .map((doc) => ParcoursModel.fromJson(doc.data()))
            .toList();
        return _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get favorites parcours stream: $e");
      }
    });
  }

  Future<List<ParcoursWithGPSData>> _mapParcoursToParcoursWithGPSData(
      List<ParcoursModel> parcoursList) {
    try {
      return Future.wait(parcoursList.map((parcours) async {
        final gpsData = await getParcoursGPSData(parcours.id!);
        return ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);
      }).toList());
    } catch (e) {
      throw Exception("Failed to map parcours to GPS data: $e");
    }
  }

  Stream<List<List<ParcoursWithGPSData>>> getParcoursStream(String userId) {
    final publicParcoursStream = _db
        .collection('parcours')
        .where('type', isEqualTo: 'public')
        .where('owner', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        final parcoursList =
            snapshot.docs.map((doc) => ParcoursModel.fromJson(doc.data())).toList();
        return _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get public parcours stream: $e");
      }
    });

    final privateParcoursStream = _db
        .collection('parcours')
        .where('type', isEqualTo: 'private')
        .where('owner', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        final parcoursList =
            snapshot.docs.map((doc) => ParcoursModel.fromJson(doc.data())).toList();
        return _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get private parcours stream: $e");
      }
    });

    final sharedParcoursStream = getSharedParcoursStream(userId);

    final favoritesStream =
        _db.collection('users').doc(userId).snapshots().asyncMap((userSnapshot) async {
      if (!userSnapshot.exists) {
        throw Exception('User not found.');
      }
      try {
        final user = UserModel.fromJson(userSnapshot.data()!);
        if (user.fav.isEmpty) {
          return <ParcoursWithGPSData>[];
        }
        final favoriteParcoursSnapshots =
            await _db.collection('parcours').where(FieldPath.documentId, whereIn: user.fav).get();
        final parcoursList = favoriteParcoursSnapshots.docs
            .map((doc) => ParcoursModel.fromJson(doc.data()))
            .toList();
        return await _mapParcoursToParcoursWithGPSData(parcoursList);
      } catch (e) {
        throw Exception("Failed to get favorite parcours stream: $e");
      }
    });

    return CombineLatestStream.list([
      publicParcoursStream,
      privateParcoursStream,
      sharedParcoursStream,
      favoritesStream,
    ]);
  }
}

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(Ref ref) {
  return FirebaseStorage.instance;
}

@Riverpod(keepAlive: true)
ParcoursRepository parcoursRepository(Ref ref) {
  return ParcoursRepository(
      ref.watch(firebaseFirestoreProvider), ref.watch(firebaseStorageProvider));
}

@riverpod
Stream<List<List<ParcoursWithGPSData>>> userParcoursStream(Ref ref, String userId) {
  return ref.watch(parcoursRepositoryProvider).getParcoursStream(userId);
}

@riverpod
Stream<ParcoursWithGPSData> singleParcoursWithGPSData(Ref ref, String parcoursId) {
  return ref.watch(parcoursRepositoryProvider).streamParcoursWithGPSData(parcoursId);
}
