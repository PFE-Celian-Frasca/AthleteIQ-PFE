import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'user_search_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'group_search_state.dart';

final groupSearchProvider =
    StateNotifierProvider<GroupSearchNotifier, GroupSearchState>(
  (ref) => GroupSearchNotifier(ref),
);

// Provider for managing user search
final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, UserSearchState>(
  (ref) => UserSearchNotifier(ref),
);

class GroupSearchNotifier extends StateNotifier<GroupSearchState> {
  final Ref _ref;

  GroupSearchNotifier(this._ref) : super(GroupSearchState.initial()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreGroups(); // Call this method after the widget has been built
    });
  }

  Future<void> searchGroups(String query) async {
    state = state.copyWith(loading: true);
    try {
      final groups = await _ref.read(groupService).searchGroups(query);
      state = state.copyWith(groups: groups, query: query, loading: false);
      _ref.read(groupService).resetPagination();
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  void resetPagination() {
    state = state.copyWith(groups: [], hasMore: true);
    loadMoreGroups();
  }

  Future<void> updateState(GroupModel group) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(groups: [group], loading: false);
    print("lol${state.groups}");
  }

  Future<void> loadMoreGroups() async {
    if (state.loading || !state.hasMore) return;
    state = state.copyWith(loading: true);
    try {
      final moreGroups = await _ref.read(groupService).loadMoreGroups();
      if (moreGroups.isEmpty) {
        state = state.copyWith(hasMore: false);
      } else {
        final updatedGroups = List<GroupModel>.from(state.groups)
          ..addAll(moreGroups);
        state = state.copyWith(groups: updatedGroups);
        if (moreGroups.length < 10) {
          state = state.copyWith(hasMore: false);
          print("no more groups");
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}

// User Search Notifier
class UserSearchNotifier extends StateNotifier<UserSearchState> {
  final Ref _ref;

  UserSearchNotifier(this._ref) : super(UserSearchState.initial()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMoreUsers(); // Call this method after the widget has been built
    });
  }

  Future<void> searchUsers(String query) async {
    state = state.copyWith(loading: true);
    try {
      print(query);
      final users = await _ref.read(userServiceProvider).searchUsers(query);
      state = state.copyWith(users: users, query: query, loading: false);
      _ref.read(userServiceProvider).resetPagination();
      print(users.toString());
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  void resetPagination() {
    state = state.copyWith(users: [], hasMore: true);
    loadMoreUsers();
  }

  Future<void> loadMoreUsers() async {
    if (state.loading || !state.hasMore) return;
    state = state.copyWith(loading: true);
    print("loading more users");
    try {
      final moreUsers = await _ref.read(userServiceProvider).loadMoreUsers();
      print(moreUsers.toString());
      if (moreUsers.isEmpty) {
        state = state.copyWith(hasMore: false);
        print("no more users");
      } else {
        final updatedUsers = List<UserModel>.from(state.users)
          ..addAll(moreUsers);
        state = state.copyWith(users: updatedUsers);
        if (moreUsers.length < 10) {
          state = state.copyWith(hasMore: false);
          print("no more users");
        }
        print("users updated");
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(loading: false);
      print("loading false");
      print(state.hasMore);
      print(state.loading);
    }
  }
}
