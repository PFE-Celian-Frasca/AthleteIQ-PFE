import 'package:athlete_iq/services/group_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../group_state.dart';

final groupListProvider =
    StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  return GroupNotifier(ref);
});

class GroupNotifier extends StateNotifier<GroupState> {
  final Ref _ref;
  GroupNotifier(this._ref) : super(const GroupState.initial());

  Future<void> loadUserGroups(String userId) async {
    state = const GroupState.loading();
    try {
      final groups = await _ref.read(groupService).getUserGroups(userId);
      state = GroupState.loaded(groups);
    } catch (e) {
      state = GroupState.error(e.toString());
    }
  }
}
