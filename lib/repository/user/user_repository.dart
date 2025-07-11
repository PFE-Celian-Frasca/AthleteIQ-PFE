import 'dart:async';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

class UserRepository {
  UserRepository(this._db);

  final FirebaseFirestore _db;

  Stream<UserModel> userStateChanges({required String userId}) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        throw Exception('User not found.');
      }
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  Future<void> createUser(UserModel newUser) async {
    await _db.collection('users').doc(newUser.id).set(newUser.toJson());
  }

  Future<UserModel> getUserData(String userId) async {
    final docSnapshot = await _db.collection('users').doc(userId).get();
    if (!docSnapshot.exists) {
      throw Exception('User not found.');
    }
    return UserModel.fromJson(docSnapshot.data()!);
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }

  Future<void> deleteUserImage(String userId) async {
    await _db.collection('users').doc(userId).update({'image': FieldValue.delete()});
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    await _db.collection('users').doc(userId).update({
      'blockedUsers': FieldValue.arrayUnion([blockedUserId])
    });
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    await _db.collection('users').doc(userId).update({
      'blockedUsers': FieldValue.arrayRemove([blockedUserId])
    });
  }

  Future<void> toggleFavoriteParcours(String userId, String parcoursId, bool isFavorite) async {
    await _db.collection('users').doc(userId).update({
      'fav': isFavorite ? FieldValue.arrayUnion([parcoursId]) : FieldValue.arrayRemove([parcoursId])
    });
  }

  Future<bool> checkIfPseudoExist(String pseudo) async {
    final querySnapshot = await _db.collection('users').where('pseudo', isEqualTo: pseudo).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> updateUserFcmToken(String userId, String fcmToken) async {
    await _db.collection('users').doc(userId).update({'fcmToken': fcmToken});
  }

  bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Friend request and relationship management
  Future<void> requestFriend(String userId, String friendId) async {
    await _db.collection('users').doc(userId).update({
      'sentFriendRequests': FieldValue.arrayUnion([friendId])
    });
    await _db.collection('users').doc(friendId).update({
      'receivedFriendRequests': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> acceptFriendRequest({required String userId, required String friendId}) async {
    await _db.collection('users').doc(userId).update({
      'friends': FieldValue.arrayUnion([friendId]),
      'receivedFriendRequests': FieldValue.arrayRemove([friendId])
    });
    await _db.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayUnion([userId]),
      'sentFriendRequests': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> denyFriendRequest({required String userId, required String friendId}) async {
    await _db.collection('users').doc(userId).update({
      'receivedFriendRequests': FieldValue.arrayRemove([friendId])
    });
    await _db.collection('users').doc(friendId).update({
      'sentFriendRequests': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> removeFriend({required String userId, required String friendId}) async {
    await _db.collection('users').doc(userId).update({
      'friends': FieldValue.arrayRemove([friendId])
    });
    await _db.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayRemove([userId])
    });
  }
}

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(ref.watch(firebaseFirestoreProvider));
}

@riverpod
Stream<UserModel?> userStateChanges(Ref ref, String userId) {
  return ref.watch(userRepositoryProvider).userStateChanges(userId: userId);
}

@riverpod
Future<UserModel?> currentUser(Ref ref, String userId) async {
  return await ref.watch(userRepositoryProvider).getUserData(userId);
}
