import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'group_search_state.dart';
import 'user_search_state.dart';

final groupSearchProvider =
    StateNotifierProvider<GroupNotifier, GroupSearchState>((ref) {
  final groupServiceProvider = ref.watch(groupService);
  return GroupNotifier(groupServiceProvider);
});

final userSearchProvider =
    StateNotifierProvider<UserNotifier, UserSearchState>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserNotifier(userService);
});

class GroupNotifier extends StateNotifier<GroupSearchState> {
  GroupNotifier(this._groupService) : super(const GroupSearchState()) {
    _loadGroups();
  }

  final GroupService _groupService;

  void _loadGroups() {
    _groupService.listAllGroupsStream().listen((groups) {
      state = state.copyWith(
          allGroups: groups, filteredGroups: groups, loading: false);
    }).onError((error) {
      state = state.copyWith(error: error.toString(), loading: false);
    });
  }

  void searchGroups(String query) {
    final filteredGroups = state.allGroups.where((group) {
      return group.groupName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredGroups: filteredGroups);
  }
}

class UserNotifier extends StateNotifier<UserSearchState> {
  UserNotifier(this._userService) : super(const UserSearchState()) {
    _loadUsers();
  }

  final UserService _userService;

  void _loadUsers() {
    _userService.listAllUsersStream().listen((users) {
      state =
          state.copyWith(allUsers: users, filteredUsers: users, loading: false);
    }).onError((error) {
      state = state.copyWith(error: error.toString(), loading: false);
    });
  }

  void searchUsers(String query) {
    final filteredUsers = state.allUsers.where((user) {
      return user.pseudo.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredUsers: filteredUsers);
  }
}
