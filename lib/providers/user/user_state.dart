import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/user/user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    UserModel? user,
    @Default(false) bool isLoading,
    String? error,
  }) = _UserState;
  const UserState._();

  UserModel? get currentUser => user;
}
