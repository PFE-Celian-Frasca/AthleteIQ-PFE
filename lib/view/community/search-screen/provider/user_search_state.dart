import 'package:athlete_iq/models/user/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_search_state.freezed.dart';

@freezed
class UserSearchState with _$UserSearchState {
  const factory UserSearchState({
    @Default([]) List<UserModel> users,
    String? query,
    String? error,
    @Default(false) bool loading,
    @Default(true) bool hasMore,
  }) = _UserSearchState;

  // Factory constructor for initializing with default values
  factory UserSearchState.initial() => const UserSearchState();
}
