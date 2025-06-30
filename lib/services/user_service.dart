import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user/user_model.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(FirebaseFirestore.instance, FirebaseStorage.instance);
});

class UserService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  UserService(this._firestore, this._storage);

  Future<T> _handleServiceAction<T>(
      Future<T> Function() action, String errorMessage) async {
    try {
      return await action();
    } catch (e) {
      throw Exception('$errorMessage: $e');
    }
  }

  Future<UserModel> getUserData(String userId) async {
    return _handleServiceAction(() async {
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!docSnapshot.exists) {
        throw Exception('User not found.');
      }
      return UserModel.fromJson(docSnapshot.data()!);
    }, 'Failed to get user data');
  }

  Stream<UserModel> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw Exception('User not found.');
      }
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  Future<UserModel> createUser(UserModel newUser) async {
    return _handleServiceAction(() async {
      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toJson());
      return newUser;
    }, 'Failed to create user');
  }

  Future<String> uploadUserProfileImage(String userId, File imageFile) async {
    return _handleServiceAction(() async {
      var uploadTask = await _storage
          .ref('user_images/$userId/profile_picture.png')
          .putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    }, 'Failed to upload user profile image');
  }

  Future<void> updateUserImage(String userId, File newImageFile) async {
    await _handleServiceAction(() async {
      String imageUrl = await uploadUserProfileImage(userId, newImageFile);
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'image': imageUrl});
    }, 'Failed to update user image');
  }

  Future<void> updateUserData(UserModel user) async {
    await _handleServiceAction(() async {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    }, 'Failed to update user data');
  }

  Future<void> deleteUserImage(String userId) async {
    await _handleServiceAction(() async {
      await _storage.ref('user_images/$userId/profile_picture.png').delete();
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'image': "default_image_url"});
    }, 'Failed to delete user image');
  }

  Future<void> deleteUser(String userId) async {
    await _handleServiceAction(() async {
      await deleteUserImage(userId);
      await _firestore.collection('users').doc(userId).delete();
    }, 'Failed to delete user');
  }

  Future<List<UserModel>> searchUsers(String query) async {
    return _handleServiceAction(() async {
      final formattedQuery = query.toLowerCase().trim();
      var querySnapshot = await _firestore
          .collection('users')
          .where('pseudo', isGreaterThanOrEqualTo: formattedQuery)
          .where('pseudo', isLessThanOrEqualTo: '$formattedQuery\uf8ff')
          .get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    }, 'Failed to search users');
  }

  Stream<List<UserModel>> listAllUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });
  }

  DocumentSnapshot? _lastUserDocument;

  Future<List<UserModel>> loadMoreUsers({int limit = 10}) async {
    return _handleServiceAction(() async {
      Query queryRef = _firestore.collection('users').orderBy('pseudo');
      if (_lastUserDocument != null) {
        queryRef = queryRef.startAfterDocument(_lastUserDocument!);
      }
      var querySnapshot = await queryRef.limit(limit).get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      _lastUserDocument = querySnapshot.docs.last;
      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    }, 'Failed to load more users');
  }

  void resetPagination() {
    _lastUserDocument = null;
  }

  Future<bool> checkPseudoExists(String pseudo) async {
    return _handleServiceAction(() async {
      var querySnapshot = await _firestore
          .collection('users')
          .where('pseudo', isEqualTo: pseudo)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    }, 'Failed to check if pseudo exists');
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    await _handleServiceAction(() async {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId])
      });
    }, 'Failed to block user');
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    await _handleServiceAction(() async {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayRemove([blockedUserId])
      });
    }, 'Failed to unblock user');
  }

  Future<void> toggleFavoriteParcours(
      String userId, String parcoursId, bool isFavorite) async {
    await _handleServiceAction(() async {
      if (isFavorite) {
        await _firestore.collection('users').doc(userId).update({
          'fav': FieldValue.arrayUnion([parcoursId])
        });
      } else {
        await _firestore.collection('users').doc(userId).update({
          'fav': FieldValue.arrayRemove([parcoursId])
        });
      }
    }, 'Failed to toggle favorite parcours');
  }
}
