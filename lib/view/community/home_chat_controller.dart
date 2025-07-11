import 'dart:async';

import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeChatController extends StateNotifier<AsyncValue<List<GroupModel>>> {
  HomeChatController(this.ref) : super(const AsyncValue.loading());

  final Ref ref;
  StreamSubscription<List<GroupModel>>? _groupSubscription;

  void loadGroups(String userId) {
    _groupSubscription?.cancel(); // Cancel any existing subscription
    _groupSubscription = ref.read(groupService).getUserGroupsStream(userId).listen(
      (groups) {
        state = AsyncValue.data(groups);
      },
      onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> refreshGroups(String userId) async {
    state = const AsyncValue.loading();
    try {
      final groups = await ref.read(groupService).getUserGroupsStream(userId).first;
      state = AsyncValue.data(groups);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  @override
  void dispose() {
    _groupSubscription?.cancel();
    super.dispose();
  }
}

final homeChatControllerProvider =
    StateNotifierProvider<HomeChatController, AsyncValue<List<GroupModel>>>((ref) {
  return HomeChatController(ref);
});
