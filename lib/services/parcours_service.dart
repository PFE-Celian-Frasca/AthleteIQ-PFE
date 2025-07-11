import 'dart:convert';

import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:http/http.dart' as http;

final parcoursService = Provider<ParcoursService>((ref) {
  return ParcoursService(FirebaseFirestore.instance, FirebaseStorage.instance, ref);
});

class ParcoursService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Ref _ref;

  ParcoursService(this._firestore, this._storage, this._ref);

  Future<void> addParcours(ParcoursModel parcours, List<LocationDataModel> locationData) async {
    final DocumentReference documentReference = _firestore.collection('parcours').doc();
    final String jsonData = jsonEncode(locationData.map((e) => e.toJson()).toList());
    final Reference storageRef = _storage.ref('parcours_data/${documentReference.id}.json');
    try {
      // Step 1: Upload JSON data to Firebase Storage and retrieve the URL
      final TaskSnapshot snapshot = await storageRef.putString(jsonData);
      final String url = await snapshot.ref.getDownloadURL();

      // Step 2: Create a new ParcoursModel with the download URL
      final parcourWithUrl = parcours.copyWith(id: documentReference.id, parcoursDataUrl: url);

      // Step 3: Save the ParcoursModel with the URL in Firestore
      await _firestore.collection('parcours').doc(parcourWithUrl.id).set(parcourWithUrl.toJson());
    } catch (e) {
      // Rollback actions
      await storageRef.delete();

      handleError(e, "upload parcours data");
    }
  }

  Future<void> deleteParcours(String parcoursId) async {
    try {
      await _firestore.collection('parcours').doc(parcoursId).delete();
      await _storage.ref('parcours_data/$parcoursId.json').delete();
      await removeFromAllFavorites(parcoursId);
    } catch (e) {
      handleError(e, "deleting parcours");
    }
  }

  Future<void> deleteAllParcoursForUser(String userId) async {
    try {
      final querySnapshot =
          await _firestore.collection('parcours').where('owner', isEqualTo: userId).get();
      for (final doc in querySnapshot.docs) {
        await deleteParcours(doc.id);
      }
    } catch (e) {
      handleError(e, "deleting all parcours for user");
    }
  }

  Future<void> updateParcours(ParcoursModel updatedParcours) async {
    try {
      await _firestore
          .collection('parcours')
          .doc(updatedParcours.id)
          .update(updatedParcours.toJson());
    } catch (e) {
      handleError(e, "updating parcours");
    }
  }

  Future<List<ParcoursModel>> getParcoursByType(ParcourVisibility type, {String? userId}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final List<Query> queries = [];
      Query query = firestore.collection('parcours');

      switch (type) {
        case ParcourVisibility.public:
          query = query.where('type', isEqualTo: 'public');
          queries.add(query);
          break;
        case ParcourVisibility.shared:
          if (userId != null) {
            // Create two queries and combine their results
            queries.add(
                query.where('type', isEqualTo: 'Shared').where('shareTo', arrayContains: userId));
            queries.add(query.where('type', isEqualTo: 'Shared').where('owner', isEqualTo: userId));
          }
          break;
        case ParcourVisibility.private:
          if (userId != null) {
            query = query.where('owner', isEqualTo: userId).where('type', isEqualTo: 'Private');
            queries.add(query);
          }
          break;
      }

      // Execute all queries and combine their results
      final List<ParcoursModel> parcoursList = [];
      for (final Query q in queries) {
        final QuerySnapshot querySnapshot = await q.get();
        parcoursList.addAll(querySnapshot.docs
            .map((doc) => ParcoursModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
      }

      return parcoursList;
    } catch (e) {
      handleError(e, "getting parcours by type");
    }
    throw Exception('Une erreur s\'est produite lors de la récupération des parcours');
  }

  Future<void> removeFromAllFavorites(String parcoursId) async {
    try {
      final usersWithFavorite =
          await _firestore.collection('users').where('fav', arrayContains: parcoursId).get();
      for (final userDoc in usersWithFavorite.docs) {
        await _ref
            .read(userRepositoryProvider)
            .toggleFavoriteParcours(userDoc.id, parcoursId, false);
      }
    } catch (e) {
      handleError(e, "removing parcours from all favorites");
    }
  }

  Future<ParcoursModel> getParcoursById(String parcoursId) async {
    try {
      final docSnapshot = await _firestore.collection('parcours').doc(parcoursId).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return ParcoursModel.fromJson(data);
      } else {
        throw Exception('Parcours not found');
      }
    } catch (e) {
      handleError(e, "getting a parcours by ID");
      throw Exception('Une erreur s\'est produite lors de la récupération du parcours');
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
      handleError(e, "getting parcours GPS data");
    }
    throw Exception(
        'Une erreur s\'est produite lors de la récupération des données GPS du parcours');
  }

  Future<List<ParcoursModel>> getFavorites(UserModel user) async {
    try {
        final List<dynamic> favoritesIds = user.fav;
        final List<ParcoursModel> favorites = [];
        for (final String parcoursId in favoritesIds.cast<String>()) {
        final parcoursDoc = await _firestore.collection('parcours').doc(parcoursId).get();
        if (parcoursDoc.exists) {
          favorites.add(ParcoursModel.fromJson(parcoursDoc.data() as Map<String, dynamic>));
        }
      }
      return favorites;
    } catch (e) {
      handleError(e, "getting favorites");
    }
    throw Exception('Une erreur s\'est produite lors de la récupération des favoris');
  }
}
