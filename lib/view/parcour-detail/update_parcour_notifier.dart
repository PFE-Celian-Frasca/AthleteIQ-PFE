import 'dart:async';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:athlete_iq/view/parcour-detail/update_parcour_state.dart';

class UpdateParcourNotifier extends StateNotifier<UpdateParcourState> {
  final Ref ref;
  final String parcourId;

  UpdateParcourNotifier(this.ref, this.parcourId) : super(const UpdateParcourState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await _initUserData();
    await _initParcourData();
    state = state.copyWith(isLoading: false);
  }

  Future<void> _initUserData() async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      ref.read(internalNotificationProvider).showErrorToast("Utilisateur non authentifié.");
      state = state.copyWith(isLoading: false);
      return;
    }

    final userId = currentUser.uid;
    final user = await ref.read(userRepositoryProvider).getUserData(userId);
    state = state.copyWith(owner: user);

    try {
      final List<UserModel> friendsDetails = [];
      for (final String friendId in user.friends) {
        final friend = await ref.read(userRepositoryProvider).getUserData(friendId);
        friendsDetails.add(friend);
      }
      state = state.copyWith(friends: friendsDetails);
    } catch (e) {
      ref.read(internalNotificationProvider).showErrorToast("Erreur lors du chargement des amis");
    }
  }

  Future<void> _initParcourData() async {
    try {
      final parcour = await ref.read(parcoursRepositoryProvider).getParcoursById(parcourId);
      state = state.copyWith(
        title: parcour.title,
        description: parcour.description,
        parcourType: parcour.type,
        friendsToShare: parcour.shareTo,
      );
    } catch (e) {
      ref
          .read(internalNotificationProvider)
          .showErrorToast("Erreur lors du chargement du parcours");
    }
  }

  void setTitle(String? title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void setParcourType(ParcourVisibility type) {
    state = state.copyWith(parcourType: type);
  }

  void addFriendToShare(String friendId) {
    state = state.copyWith(friendsToShare: [...state.friendsToShare, friendId]);
  }

  void removeFriendToShare(String friendId) {
    state = state.copyWith(
      friendsToShare: state.friendsToShare.where((id) => id != friendId).toList(),
    );
  }

  Future<void> updateParcours(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    if (state.title == null || state.title!.isEmpty) {
      ref.read(internalNotificationProvider).showErrorToast("Veuillez entrer un titre");
      state = state.copyWith(isLoading: false);
      return;
    }

    try {
      final updates = {
        'title': state.title!,
        'description': state.description,
        'type': state.parcourType.toString().split('.').last,
        'shareTo':
            state.parcourType == ParcourVisibility.shared ? state.friendsToShare : <String>[],
      };

      await ref.read(parcoursRepositoryProvider).updateParcoursById(parcourId, updates);
      if (context.mounted) {
        GoRouter.of(context).pop();
      }
    } catch (e) {
      ref
          .read(internalNotificationProvider)
          .showErrorToast("Échec de la mise à jour du parcours: $e");
      state = state.copyWith(isLoading: false);
    }
  }
}

final updateParcourNotifierProvider =
    StateNotifierProvider.family<UpdateParcourNotifier, UpdateParcourState, String>(
        (ref, parcourId) => UpdateParcourNotifier(ref, parcourId));
