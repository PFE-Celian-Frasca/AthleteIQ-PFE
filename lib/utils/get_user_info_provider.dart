import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getUserInfoProvider =
    FutureProvider.family<UserModel, String>((ref, userId) {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserData(userId);
});
