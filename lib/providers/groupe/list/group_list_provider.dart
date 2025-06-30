import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final groupListStreamProvider =
    StreamProvider.autoDispose.family<List<GroupModel>, String>((ref, userId) {
  return ref.read(groupService).getUserGroupsStream(userId);
});
