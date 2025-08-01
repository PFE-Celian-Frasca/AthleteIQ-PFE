import 'dart:io';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/group/group_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';

final groupControllerProvider = StateNotifierProvider<GroupController, GroupModel>((ref) {
  return GroupController(ref.read(groupRepositoryProvider));
});

class GroupController extends StateNotifier<GroupModel> {
  final GroupRepository _groupRepository;

  GroupController(this._groupRepository) : super(GroupModel.empty());

  void setEditSettings(bool value) {
    state = state.copyWith(editSettings: value);
    if (state.groupId.isNotEmpty) {
      _groupRepository.updateGroupDataInFireStore(state);
    }
  }

  Future<void> createGroup({
    required GroupModel newGroupModel,
    required File? fileImage,
    required VoidCallback onSuccess,
    required void Function(String) onFail,
  }) async {
    state = newGroupModel;
    await _groupRepository.createGroup(
      newGroupModel: newGroupModel,
      fileImage: fileImage,
      onSuccess: () {
        state = newGroupModel.copyWith(
          membersUIDs: [newGroupModel.creatorUID, ...newGroupModel.membersUIDs],
          adminsUIDs: [newGroupModel.creatorUID, ...newGroupModel.adminsUIDs],
        );
        onSuccess();
      },
      onFail: onFail,
    );
  }

  Future<void> addMemberToGroup({required UserModel groupMember}) async {
    state = state.copyWith(
      membersUIDs: [...state.membersUIDs, groupMember.id],
    );
    await _groupRepository.addMemberToGroup(groupMember: groupMember, groupModel: state);
  }

  Future<void> addMemberToAdmins({required UserModel groupAdmin}) async {
    state = state.copyWith(
      adminsUIDs: [...state.adminsUIDs, groupAdmin.id],
    );
    await _groupRepository.addMemberToAdmins(groupAdmin: groupAdmin, groupModel: state);
  }

  Future<void> removeGroupMember({required UserModel groupMember}) async {
    state = state.copyWith(
      membersUIDs: state.membersUIDs.where((uid) => uid != groupMember.id).toList(),
    );
    await _groupRepository.removeGroupMember(groupMember: groupMember, groupModel: state);
  }

  Future<void> removeGroupAdmin({required UserModel groupAdmin}) async {
    state = state.copyWith(
      adminsUIDs: state.adminsUIDs.where((uid) => uid != groupAdmin.id).toList(),
    );
    await _groupRepository.removeGroupAdmin(groupAdmin: groupAdmin, groupModel: state);
  }

  Stream<List<GroupModel>> getPrivateGroupsStream({required String userId}) {
    return _groupRepository.getPrivateGroupsStream(userId: userId);
  }

  Stream<List<GroupModel>> getPublicGroupsStream({required String userId}) {
    return _groupRepository.getPublicGroupsStream(userId: userId);
  }

  void changeGroupType() {
    state = state.copyWith(isPrivate: !state.isPrivate);
    _groupRepository.updateGroupDataInFireStore(state);
  }
}
