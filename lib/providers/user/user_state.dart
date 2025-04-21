import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/user/user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = Initial;
  const factory UserState.loading() = Loading;
  const factory UserState.loaded(UserModel user) = Loaded;
  const factory UserState.error(String message) = Error;
}
