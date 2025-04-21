import 'package:athlete_iq/models/user/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_list_state.freezed.dart';

@freezed
class UserListState with _$UserListState {
  const factory UserListState({
    @Default([]) List<UserModel> users,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(true) bool hasMore,
    @Default(false) bool isSearchActive,
  }) = _UserListState;
}
