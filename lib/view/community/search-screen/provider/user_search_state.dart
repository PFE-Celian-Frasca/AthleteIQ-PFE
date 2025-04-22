import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlete_iq/models/user/user_model.dart';

part 'user_search_state.freezed.dart';

@freezed
class UserSearchState with _$UserSearchState {
  const factory UserSearchState({
    @Default([]) List<UserModel> allUsers,
    @Default([]) List<UserModel> filteredUsers,
    @Default(false) bool loading,
    String? error,
  }) = _UserSearchState;
}
