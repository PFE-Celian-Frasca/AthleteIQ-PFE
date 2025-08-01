import 'dart:async';
import 'dart:io';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/providers/groupe/group_state.dart';

final groupActionsProvider = StateNotifierProvider<GroupActionsNotifier, GroupState>((ref) {
  return GroupActionsNotifier(ref);
});

class GroupActionsNotifier extends StateNotifier<GroupState> {
  final Ref _ref;
  GroupActionsNotifier(this._ref) : super(const GroupState.initial());

  Future<void> createGroup(GroupModel newGroup, {File? imageFile}) async {
    state = const GroupState.loading();
    try {
      await _ref.read(groupService).createGroup(newGroup, imageFile: imageFile);
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref
          .read(internalNotificationProvider)
          .showErrorToast("Erreur lors de la création du groupe. Veuillez réessayer.");
      rethrow;
    }
  }

  Future<void> updateGroup(GroupModel updatedGroup, String userId) async {
    try {
      await _ref.read(groupService).updateGroup(updatedGroup);
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref
          .read(internalNotificationProvider)
          .showErrorToast("Erreur lors de la mise à jour des informations du groupe");
      rethrow;
    }
  }

  Future<void> leaveGroup({required GroupModel group, required UserModel currentUser}) async {
    try {
      final updatedGroup = group.copyWith(
        membersUIDs: group.membersUIDs.where((member) => member != currentUser.id).toList(),
      );
      await _ref.read(groupService).updateGroup(updatedGroup);
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref.read(internalNotificationProvider).showErrorToast("Erreur lors de la sortie du groupe");
      rethrow;
    }
  }

  Future<void> joinGroup({required GroupModel group, required UserModel currentUser}) async {
    try {
      final updatedGroup = group.copyWith(
        membersUIDs: [...group.membersUIDs, currentUser.id],
      );
      await _ref.read(groupService).updateGroup(updatedGroup);
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref.read(internalNotificationProvider).showErrorToast("Erreur lors de l'ajout au groupe");
      rethrow;
    }
  }

  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    try {
      await _ref.read(groupService).removeMemberFromGroup(groupId, userId);
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref
          .read(internalNotificationProvider)
          .showErrorToast("Erreur lors de la suppression du membre du groupe");
      rethrow;
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await _ref.read(groupService).deleteGroup(groupId);
      _ref.read(internalNotificationProvider).showToast("Groupe supprimé avec succès.");
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref
          .read(internalNotificationProvider)
          .showErrorToast("Erreur lors de la suppression du groupe. Veuillez réessayer.");
      rethrow;
    }
  }
}
