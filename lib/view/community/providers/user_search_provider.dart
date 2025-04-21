import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final Ref ref;

  UserSearchNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> searchUsers(String query) async {
    state = const AsyncValue.loading();
    try {
      final users = await ref.read(userServiceProvider).searchUsers(query);
      state = AsyncValue.data(users);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, AsyncValue<List<UserModel>>>(
        (ref) {
  return UserSearchNotifier(ref);
});
