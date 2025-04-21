import 'dart:io';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../message/group_chat_provider.dart';
import '../list/group_list_provider.dart';
import '../group_state.dart';

final groupPrivacyProvider = StateProvider.family<bool, String>((ref, groupId) {
  final groupDetails = ref
      .read(groupChatProvider(groupId))
      .maybeWhen(loaded: (group, _, __) => group, orElse: () => null);
  return groupDetails?.type == "private" ??
      true; // default à true si la donnée n'est pas chargée
});

final groupActionsProvider =
    StateNotifierProvider<GroupActionsNotifier, GroupState>((ref) {
  return GroupActionsNotifier(ref);
});

class GroupActionsNotifier extends StateNotifier<GroupState> {
  final Ref _ref;
  GroupActionsNotifier(this._ref) : super(const GroupState.initial());

  Future<void> createGroup(GroupModel newGroup, {File? imageFile}) async {
    state = const GroupState.loading();
    try {
      await _ref.read(groupService).createGroup(newGroup, imageFile: imageFile);
      // Après la création, rechargez ou mettez à jour la liste des groupes.
      _ref
          .read(groupListProvider.notifier)
          .loadUserGroups(newGroup.admin); // Assuming admin ID is available
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref.read(notificationNotifierProvider.notifier).showErrorToast(
          "Erreur lors de la création du groupe. Veuillez réessayer.");
      rethrow;
    }
  }

  Future<void> updateGroup(GroupModel updatedGroup, String userId) async {
    try {
      await _ref.read(groupService).updateGroup(updatedGroup);
      await _ref.read(groupListProvider.notifier).loadUserGroups(userId);
      await _ref
          .read(groupChatProvider(updatedGroup.id!).notifier)
          .loadGroupAndSubscribeToMessages();
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref.read(notificationNotifierProvider.notifier).showErrorToast(
          "Erreur lors de la mise à jour des informations du groupe");
      rethrow;
    }
  }

  Future<void> leaveGroup(
      {required GroupModel group, required UserModel currentUser}) async {
    try {
      final updatedGroup = group.copyWith(
        members:
            group.members.where((member) => member != currentUser.id).toList(),
      );
      await _ref.read(groupService).updateGroup(updatedGroup);
      await _ref
          .read(groupListProvider.notifier)
          .loadUserGroups(currentUser.id!);
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref
          .read(notificationNotifierProvider.notifier)
          .showErrorToast("Erreur lors de la sortie du groupe");
      rethrow;
    }
  }

  Future<void> joinGroup(
      {required GroupModel group, required UserModel currentUser}) async {
    try {
      print("inside join group");
      final updatedGroup = group.copyWith(
        members: [...group.members, currentUser.id!],
      );
      await _ref.read(groupService).updateGroup(updatedGroup);
      await _ref
          .read(groupListProvider.notifier)
          .loadUserGroups(currentUser.id!);
      print("group joined end");
    } catch (e) {
      state = GroupState.error(e.toString());
      _ref
          .read(notificationNotifierProvider.notifier)
          .showErrorToast("Erreur lors de la sortie du groupe");
      rethrow;
    }
  }
}
