import 'dart:async';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/group/group_repository.dart';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  StreamSubscription<UserModel?>? _userSubscription;
  StreamSubscription? _otherSubscription;

  @override
  bool build() {
    ref.onDispose(() {
      _userSubscription?.cancel();
      _otherSubscription?.cancel();
    });
    return false;
  }

  Future<void> updateProfile(UserModel updatedUser, {required bool emailChanged}) async {
    state = true;
    try {
      if (emailChanged) {
        await ref.read(authRepositoryProvider).updateEmail(updatedUser.email);
      }
      await ref.read(userRepositoryProvider).updateUser(updatedUser);
      ref.read(internalNotificationProvider).showToast("Profil mis à jour avec succès.");
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
      ref.read(internalNotificationProvider).showToast("Mot de passe mis à jour avec succès.");
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
      await ref.read(userRepositoryProvider).deleteUser(userId);
      await ref.read(authRepositoryProvider).deleteAccount();
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        ref
            .read(internalNotificationProvider)
            .showErrorToast('Veuillez vous ré-authentifier avant de supprimer votre compte.');
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
        await deleteAccount();
      } else {
        ref
            .read(internalNotificationProvider)
            .showErrorToast("Le mot de passe est requis pour se ré-authentifier.");
      }
    } catch (e) {
      ref.read(internalNotificationProvider).showErrorToast("Échec de la ré-authentification : $e");
    }
  }

  Future<String?> _promptForPassword() {
    return Future.value("user_password");
  }

  Future<void> deleteUserRelatedFilesAndData(String userId) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final storage = ref.read(firebaseStorageProvider);

      final userDoc = await db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final UserModel user = UserModel.fromJson(userDoc.data()!);

        if (user.image.isNotEmpty && isValidUrl(user.image)) {
          final ref = storage.refFromURL(user.image);
          await ref.delete();
        }

        await Future.wait([
          deleteAllParcoursForUser(userId),
          removeUserFromFavorites(userId),
          deleteAllGroupsForUser(userId),
          deleteAllMessagesForUser(userId),
          removeUserFromFriends(userId),
        ]);
      }
    } catch (e) {
      throw Exception("Échec de la suppression des fichiers et données liés à l'utilisateur : $e");
    }
  }

  Future<void> deleteAllParcoursForUser(String userId) async {
    try {
      await ref.read(parcoursRepositoryProvider).deleteAllParcoursForUser(userId);
    } catch (e) {
      throw Exception("Échec de la suppression de tous les parcours pour l'utilisateur : $e");
    }
  }

  Future<void> removeUserFromFavorites(String userId) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final userFavoritesSnapshot = await db.collection('users').get();
      for (final doc in userFavoritesSnapshot.docs) {
        await db.collection('users').doc(doc.id).update({
          'fav': FieldValue.arrayRemove([userId])
        });
      }
    } catch (e) {
      throw Exception("Échec de la suppression de l'utilisateur des favoris : $e");
    }
  }

  Future<void> deleteAllGroupsForUser(String userId) async {
    try {
      await ref.read(groupRepositoryProvider).deleteAllGroupsForUser(userId);
    } catch (e) {
      throw Exception("Échec de la suppression de tous les groupes pour l'utilisateur : $e");
    }
  }

  Future<void> deleteAllMessagesForUser(String userId) async {
    try {
      await ref.read(chatRepositoryProvider).deleteAllMessagesForUser(userId);
    } catch (e) {
      throw Exception("Échec de la suppression de tous les messages pour l'utilisateur : $e");
    }
  }

  Future<void> removeUserFromFriends(String userId) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);
      final friendsSnapshot = await db.collection('users').get();
      for (final doc in friendsSnapshot.docs) {
        await db.collection('users').doc(doc.id).update({
          'friends': FieldValue.arrayRemove([userId]),
          'sentFriendRequests': FieldValue.arrayRemove([userId]),
          'receivedFriendRequests': FieldValue.arrayRemove([userId])
        });
      }
    } catch (e) {
      throw Exception("Échec de la suppression de l'utilisateur des amis : $e");
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
}
