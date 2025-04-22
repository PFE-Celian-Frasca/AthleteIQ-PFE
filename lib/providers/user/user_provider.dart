import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/user/user_model.dart';
import '../../services/user_service.dart';
import 'user_state.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(userServiceProvider));
});

class UserNotifier extends StateNotifier<UserState> {
  final UserService _userService;

  UserNotifier(this._userService) : super(const UserState.initial());

  Future<void> loadUserProfile(String userId) async {
    state = const UserState.loading();
    try {
      final user = await _userService.getUserData(userId);
      state = UserState.loaded(user);
    } catch (e) {
      state = UserState.error(e.toString());
    }
  }

  Future<void> createUserProfile(UserModel newUser) async {
    state = const UserState.loading();
    try {
      final createdUser = await _userService.createUser(newUser);
      state = UserState.loaded(createdUser);
    } catch (e) {
      state = UserState.error(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    state = const UserState.loading();
    try {
      await _userService.updateUserData(updatedUser);
      state = UserState.loaded(updatedUser);
    } catch (e) {
      state = UserState.error(e.toString());
    }
  }

  Future<void> updateUserImage(String userId, File newImageFile) async {
    state = const UserState.loading();
    try {
      await _userService.updateUserImage(userId, newImageFile);
      final updatedUser =
          await _userService.getUserData(userId); // Re-fetch the user data
      await updateUserProfile(
          updatedUser); // Update user data with new image URL
    } catch (e) {
      state = UserState.error(e.toString());
    }
  }

  Future<void> deleteUserImage(String userId) async {
    try {
      await _userService.deleteUserImage(userId);
      loadUserProfile(userId); // Reload to update the profile without the image
    } catch (e) {
      state = UserState.error(e.toString());
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _userService.deleteUser(userId);
      resetState();
    } catch (e) {
      state = UserState.error(e.toString());
      rethrow;
    }
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      await _userService.blockUser(userId, blockedUserId);
      // Reload to update any UI that depends on the block list
      loadUserProfile(userId);
    } catch (e) {
      state = UserState.error(e.toString());
    }
  }

  Future<void> requestFriend(
      {required UserModel user, required UserModel currentUser}) async {
    state = const UserState.loading();
    try {
      final updatedUser = user.copyWith(
        receivedFriendRequests: [
          ...user.receivedFriendRequests,
          currentUser.id
        ],
      );
      final updatedCurrentUser = currentUser.copyWith(
        sentFriendRequests: [...currentUser.sentFriendRequests, user.id],
      );
      await _userService.updateUserData(updatedUser);
      await updateUserProfile(updatedCurrentUser);
    } catch (e) {
      state = UserState.error(e.toString());
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(
      {required UserModel user, required UserModel currentUser}) async {
    state = const UserState.loading();
    try {
      final updatedUser = user.copyWith(
        friends: [...user.friends, currentUser.id],
        sentFriendRequests: user.sentFriendRequests
            .where((id) => id != currentUser.id)
            .toList(),
      );
      final updatedCurrentUser = currentUser.copyWith(
        friends: [...currentUser.friends, user.id],
        receivedFriendRequests: currentUser.receivedFriendRequests
            .where((id) => id != user.id)
            .toList(),
      );
      await _userService.updateUserData(updatedUser);
      await updateUserProfile(updatedCurrentUser);
    } catch (e) {
      state = UserState.error(e.toString());
      rethrow;
    }
  }

  Future<void> denyFriendRequest(
      {required UserModel user, required UserModel currentUser}) async {
    state = const UserState.loading();
    try {
      final updatedUser = user.copyWith(
        receivedFriendRequests: currentUser.receivedFriendRequests
            .where((id) => id != user.id)
            .toList(),
      );
      final updatedCurrentUser = currentUser.copyWith(
        sentFriendRequests: user.sentFriendRequests
            .where((id) => id != currentUser.id)
            .toList(),
      );
      await _userService.updateUserData(updatedUser);
      await updateUserProfile(updatedCurrentUser);
    } catch (e) {
      state = UserState.error(e.toString());
      rethrow;
    }
  }

  Future<void> removeFriend(
      {required UserModel user, required UserModel currentUser}) async {
    state = const UserState
        .loading(); // Assurez-vous que UserState a un constructeur .loading()
    try {
      final updatedUser = user.copyWith(
        friends: user.friends.where((id) => id != currentUser.id).toList(),
      );
      final updatedCurrentUser = currentUser.copyWith(
        friends: currentUser.friends.where((id) => id != user.id).toList(),
      );

      await _userService.updateUserData(updatedUser);
      await updateUserProfile(updatedCurrentUser);
    } catch (e) {
      state = UserState.error(e.toString());
      rethrow;
    }
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      await _userService.unblockUser(userId, blockedUserId);
      // Reload to reflect the changes
      loadUserProfile(userId);
    } catch (e) {
      state = UserState.error(e.toString());
    }
  }

// In UserNotifier
  Future<void> toggleFavoriteParcours(
      String userId, String parcoursId, bool isFavorite) async {
    try {
      UserModel user = state.maybeWhen(
        loaded: (user) => user,
        orElse: () => throw Exception("User not loaded"),
      );
      List<String> newFavorites = List<String>.from(user.fav);
      if (isFavorite) {
        if (!newFavorites.contains(parcoursId)) {
          newFavorites.add(parcoursId);
        }
      } else {
        newFavorites.remove(parcoursId);
      }

      // Optimistic update
      final newUser = user.copyWith(fav: newFavorites);
      // Attempt to toggle favorite on the server
      await _userService.toggleFavoriteParcours(userId, parcoursId, isFavorite);
      state = UserState.loaded(newUser);
    } catch (e) {
      state = UserState.error(e.toString());
      // Optionally rollback to previous state
      loadUserProfile(userId);
    }
  }

  void resetState() {
    state = const UserState.initial();
  }
}
