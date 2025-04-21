import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/view/community/providers/states/user_list_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userListProvider =
    StateNotifierProvider<UserListNotifier, UserListState>((ref) {
  return UserListNotifier(ref);
});

class UserListNotifier extends StateNotifier<UserListState> {
  final Ref _ref;
  UserListNotifier(this._ref) : super(const UserListState());

  Future<void> loadUsers() async {
    if (state.isLoading ||
        !state.hasMore ||
        state.users.isNotEmpty && !state.isSearchActive) return;

    state = state.copyWith(isLoading: true);
    try {
      List<UserModel> newUsers =
          await _ref.read(userServiceProvider).loadMoreUsers();
      state = state.copyWith(
        users: [...state.users, ...newUsers],
        hasMore: newUsers.length == 10,
        isLoading: false,
        isSearchActive: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> searchUsers(String query) async {
    state = state.copyWith(isLoading: true, isSearchActive: true);
    try {
      List<UserModel> results =
          await _ref.read(userServiceProvider).searchUsers(query);
      state = state.copyWith(users: results, isLoading: false, hasMore: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void resetPagination() {
    state = const UserListState(
        hasMore: true, isLoading: false, users: [], isSearchActive: false);
    loadUsers(); // Recharge les utilisateurs immédiatement
  }
}
