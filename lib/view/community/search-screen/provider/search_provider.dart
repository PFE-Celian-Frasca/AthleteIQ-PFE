import 'dart:async';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
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
  StreamSubscription<List<GroupModel>>? _groupsSubscription;

  void _loadGroups() {
    _groupsSubscription = _groupService.listAllGroupsStream().listen((groups) {
      state = state.copyWith(
        allGroups: groups,
        filteredGroups: groups,
        loading: false,
      );
    }, onError: (error) {
      state = state.copyWith(error: error.toString(), loading: false);
    });
  }

  void searchGroups(String query) {
    final filteredGroups = state.allGroups.where((group) {
      return group.groupName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredGroups: filteredGroups);
  }

  @override
  void dispose() {
    _groupsSubscription?.cancel();
    super.dispose();
  }
}

class UserNotifier extends StateNotifier<UserSearchState> {
  UserNotifier(this._userService) : super(const UserSearchState()) {
    _loadUsers();
  }

  final UserService _userService;
  StreamSubscription<List<UserModel>>? _usersSubscription;

  void _loadUsers() {
    _usersSubscription = _userService.listAllUsersStream().listen((users) {
      state = state.copyWith(
        allUsers: users,
        filteredUsers: users,
        loading: false,
      );
    }, onError: (error) {
      state = state.copyWith(error: error.toString(), loading: false);
    });
  }

  void searchUsers(String query) {
    final filteredUsers = state.allUsers.where((user) {
      return user.pseudo.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredUsers: filteredUsers);
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }
}
