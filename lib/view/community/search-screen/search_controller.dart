import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/community/search-screen/provider/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchController extends StateNotifier<bool> {
  SearchController(this.ref) : super(false);

  final Ref ref;

  void refresh(String query) {
    if (query.isEmpty) {
      ref.read(userSearchProvider.notifier).searchUsers('');
      ref.read(groupSearchProvider.notifier).searchGroups('');
    } else {
      ref.read(userSearchProvider.notifier).searchUsers(query);
      ref.read(groupSearchProvider.notifier).searchGroups(query);
    }
  }

  Future<void> handleUserAction(UserModel user, UserModel currentUser) async {
    if (user.friends.contains(currentUser.id)) {
      await ref
          .read(userRepositoryProvider)
          .removeFriend(userId: currentUser.id, friendId: user.id);
      ref
          .read(internalNotificationProvider)
          .showToast('Vous avez supprimé ${user.pseudo} de vos amis.');
    } else if (user.receivedFriendRequests.contains(currentUser.id)) {
      await ref
          .read(userRepositoryProvider)
          .acceptFriendRequest(userId: currentUser.id, friendId: user.id);
      ref
          .read(internalNotificationProvider)
          .showToast('Vous êtes maintenant amis avec ${user.pseudo}');
    } else {
      await ref
          .read(userRepositoryProvider)
          .requestFriend(currentUser.id, user.id);
      ref
          .read(internalNotificationProvider)
          .showToast('Demande d\'ami envoyée à ${user.pseudo}');
    }
  }

  Future<void> handleGroupAction(
      GroupModel group, UserModel currentUser) async {
    if (group.membersUIDs.contains(currentUser.id)) {
      await ref
          .read(groupActionsProvider.notifier)
          .leaveGroup(group: group, currentUser: currentUser);
      ref
          .read(internalNotificationProvider)
          .showToast('Vous avez quitté le groupe ${group.groupName}');
    } else {
      await ref
          .read(groupActionsProvider.notifier)
          .joinGroup(group: group, currentUser: currentUser);
      ref
          .read(internalNotificationProvider)
          .showToast('Vous avez rejoint le groupe ${group.groupName}');
    }
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, bool>((ref) {
  return SearchController(ref);
});
