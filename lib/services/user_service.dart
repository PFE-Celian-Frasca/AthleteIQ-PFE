import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user/user_model.dart';
import '../utils/internal_notification/internal_notification_provider.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(FirebaseFirestore.instance, FirebaseStorage.instance);
});

class UserService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  UserService(this._firestore, this._storage);

  Future<UserModel> getUserData(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!docSnapshot.exists) {
        throw Exception('User not found.');
      }
      return UserModel.fromJson(docSnapshot.data()!);
    } catch (e) {
      handleError(e, "get user data");
    }
    throw Exception('An error occurred');
  }

  Future<UserModel> createUser(UserModel newUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toJson());
      return newUser;
    } catch (e) {
      handleError(e, "create user");
      throw Exception('Failed to create user');
    }
  }

  Future<String> uploadUserProfileImage(String userId, File imageFile) async {
    try {
      var uploadTask = await _storage
          .ref('user_images/$userId/profile_picture.png')
          .putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      handleError(e, "upload user profile image");
    }
    throw Exception('An error occurred');
  }

  Future<void> updateUserImage(String userId, File newImageFile) async {
    try {
      String imageUrl = await uploadUserProfileImage(userId, newImageFile);
      await _firestore.collection('users').doc(userId).update({
        'image': imageUrl,
      });
    } catch (e) {
      handleError(e, "update user image");
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      handleError(e, "update user data");
    }
  }

  Future<void> deleteUserImage(String userId) async {
    try {
      await _storage.ref('user_images/$userId/profile_picture.png').delete();
      await _firestore.collection('users').doc(userId).update({
        'image':
            "default_image_url", // Set to your default image URL or make it null
      });
    } catch (e) {
      handleError(e, "delete user image");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await deleteUserImage(userId);
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      handleError(e, "delete user");
    }
  }

  DocumentSnapshot? _lastUserDocument;

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final formattedQuery = query.toLowerCase().trim();
      var querySnapshot = await _firestore
          .collection('users')
          .where('pseudo', isGreaterThanOrEqualTo: formattedQuery)
          .where('pseudo', isLessThanOrEqualTo: formattedQuery + '\uf8ff')
          .get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  Future<List<UserModel>> loadMoreUsers({int limit = 10}) async {
    try {
      Query queryRef = _firestore.collection('users').orderBy('pseudo');
      if (_lastUserDocument != null) {
        queryRef = queryRef.startAfterDocument(_lastUserDocument!);
      }
      var querySnapshot = await queryRef.limit(limit).get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      _lastUserDocument = querySnapshot.docs.last; // Update last document
      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  void resetPagination() {
    _lastUserDocument = null;
  }

  Future<bool> checkPseudoExists(String pseudo) async {
    try {
      var querySnapshot = await _firestore
          .collection('users')
          .where('pseudo', isEqualTo: pseudo)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      handleError(e, "search users");
      return false;
    }
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
      });
    } catch (e) {
      handleError(e, "block user");
    }
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayRemove([blockedUserId]),
      });
    } catch (e) {
      handleError(e, "unblock user");
    }
  }

  Future<void> toggleFavoriteParcours(
      String userId, String parcoursId, bool isFavorite) async {
    try {
      if (isFavorite) {
        await _firestore.collection('users').doc(userId).update({
          'fav': FieldValue.arrayUnion([parcoursId]),
        });
      } else {
        await _firestore.collection('users').doc(userId).update({
          'fav': FieldValue.arrayRemove([parcoursId]),
        });
      }
    } catch (e) {
      handleError(e, "toggle favorite parcours");
    }
  }
}
