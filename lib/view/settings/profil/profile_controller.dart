import 'dart:async';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  StreamSubscription<UserModel?>? _userSubscription;

  @override
  bool build() {
    ref.onDispose(() {
      _userSubscription?.cancel();
    });
    return false; // Initial loading state
  }

  Future<void> updateProfile(UserModel updatedUser,
      {required bool emailChanged}) async {
    state = true;
    try {
      if (emailChanged) {
        await ref.read(authRepositoryProvider).updateEmail(updatedUser.email);
      }
      await ref.read(userRepositoryProvider).updateUser(updatedUser);
    } catch (e) {
      ref.read(internalNotificationProvider).showErrorToast(e.toString());
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> changePassword(String newPassword) async {
    state = true;
    try {
      await ref.read(authRepositoryProvider).updatePassword(newPassword);
    } catch (e) {
      ref.read(internalNotificationProvider).showErrorToast(e.toString());
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    state = true;
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (e) {
      ref.read(internalNotificationProvider).showErrorToast(e.toString());
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> deleteAccount() async {
    state = true;
    try {
      final userId = ref.read(authRepositoryProvider).currentUser!.uid;
      await deleteUserRelatedFilesAndData(userId);
      await ref.read(authRepositoryProvider).deleteAccount();
      await ref.read(userRepositoryProvider).deleteUser(userId);
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        ref.read(internalNotificationProvider).showErrorToast(
            'Please reauthenticate before deleting your account.');
        reauthenticateAndDeleteAccount();
      } else {
        ref.read(internalNotificationProvider).showErrorToast(e.toString());
      }
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> reauthenticateAndDeleteAccount() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final user = authRepository.currentUser;

      final email = user?.email ?? "";
      final password = await _promptForPassword();

      if (password != null) {
        await authRepository.reauthenticate(email, password);
        await deleteAccount(); // Retry deleting the account
      } else {
        ref
            .read(internalNotificationProvider)
            .showErrorToast("Password is required to reauthenticate.");
      }
    } catch (e) {
      ref
          .read(internalNotificationProvider)
          .showErrorToast("Failed to reauthenticate: $e");
    }
  }

  Future<String?> _promptForPassword() async {
    // Implement the logic to prompt the user for their password.
    // This could be a dialog or any other method to securely get the password from the user.
    // Returning a dummy password for example purposes.
    return Future.value("user_password");
  }

  Future<void> deleteUserRelatedFilesAndData(String userId) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final storage = ref.read(firebaseStorageProvider);

      var userDoc = await db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        UserModel user = UserModel.fromJson(userDoc.data()!);
        if (user.image.isNotEmpty && isValidUrl(user.image)) {
          try {
            final ref = storage.refFromURL(user.image);
            await ref.getDownloadURL(); // Verify if the image exists
            await ref.delete();
          } catch (e) {
            ref.read(internalNotificationProvider).showErrorToast(
                "Problème lors de la suppression de l'image: $e");
          }
        }

        // Delete all parcours related to the user
        await deleteAllParcoursForUser(userId);

        // Check and remove parcours from other users' favorite lists
        final userFavoritesSnapshot = await db.collection('users').get();
        for (var doc in userFavoritesSnapshot.docs) {
          await db.collection('users').doc(doc.id).update({
            'fav': FieldValue.arrayRemove([userId])
          });
        }

        // Delete all groups and remove the user from member/admin lists
        await deleteAllGroupsForUser(userId);

        // Delete all messages sent by the user
        await deleteAllMessagesForUser(userId);

        // Remove user from friends and friend requests
        final friendsSnapshot = await db.collection('users').get();
        for (var doc in friendsSnapshot.docs) {
          await db.collection('users').doc(doc.id).update({
            'friends': FieldValue.arrayRemove([userId]),
            'sentFriendRequests': FieldValue.arrayRemove([userId]),
            'receivedFriendRequests': FieldValue.arrayRemove([userId])
          });
        }
      }
    } catch (e) {
      throw Exception("Failed to delete user related files and data: $e");
    }
  }

  bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteAllParcoursForUser(String userId) async {
    final db = ref.read(firebaseFirestoreProvider);
    final userParcoursSnapshot = await db
        .collection('parcours')
        .where('userId', isEqualTo: userId)
        .get();
    for (var doc in userParcoursSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteAllGroupsForUser(String userId) async {
    final db = ref.read(firebaseFirestoreProvider);
    final userGroupsSnapshot =
        await db.collection('groups').where('userId', isEqualTo: userId).get();
    for (var doc in userGroupsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteAllMessagesForUser(String userId) async {
    final db = ref.read(firebaseFirestoreProvider);
    final userMessagesSnapshot = await db
        .collection('messages')
        .where('userId', isEqualTo: userId)
        .get();
    for (var doc in userMessagesSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
