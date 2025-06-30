import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final groupDetailsProvider =
    StreamProvider.family<GroupModel, String>((ref, groupId) {
  final groupServiceProvider = ref.watch(groupService);
  return groupServiceProvider.getGroupDetailsStream(groupId);
});
