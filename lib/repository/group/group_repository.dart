import 'dart:io';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/message/last_message_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/utils/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) {
  return GroupRepository(FirebaseFirestore.instance);
});

class GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository(this._firestore);

  Future<void> updateGroupDataInFireStore(GroupModel groupModel) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupModel.groupId)
          .update(groupModel.toJson());
    } catch (e) {
      throw Exception("Failed to update group data: $e");
    }
  }

  Future<void> setGroupModel(GroupModel groupModel) async {
    try {
      await updateGroupDataInFireStore(groupModel);
    } catch (e) {
      throw Exception("Failed to set group model: $e");
    }
  }

  Future<void> createGroup({
    required GroupModel newGroupModel,
    required File? fileImage,
    required Function onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      var groupId = const Uuid().v4();
      newGroupModel = newGroupModel.copyWith(groupId: groupId);

      if (fileImage != null) {
        final String imageUrl = await storeFileToStorage(
            file: fileImage, reference: 'groupImages/$groupId');
        newGroupModel = newGroupModel.copyWith(groupImage: imageUrl);
      }

      newGroupModel = newGroupModel.copyWith(
        adminsUIDs: [newGroupModel.creatorUID, ...newGroupModel.adminsUIDs],
        membersUIDs: [newGroupModel.creatorUID, ...newGroupModel.membersUIDs],
      );

      await _firestore
          .collection('groups')
          .doc(groupId)
          .set(newGroupModel.toJson());

      onSuccess();
    } catch (e) {
      onFail(e.toString());
    }
  }

  Future<void> addMemberToGroup(
      {required UserModel groupMember, required GroupModel groupModel}) async {
    // Créer une copie mutable de membersUIDs
    final updatedMembersUIDs = List<String>.from(groupModel.membersUIDs);
    updatedMembersUIDs.add(groupMember.id);
    final updatedGroupModel = groupModel.copyWith(membersUIDs: updatedMembersUIDs);

    await updateGroupDataInFireStore(updatedGroupModel);
  }

  Future<void> addMemberToAdmins(
      {required UserModel groupAdmin, required GroupModel groupModel}) async {
    // Créer une copie mutable de adminsUIDs
    final updatedAdminsUIDs = List<String>.from(groupModel.adminsUIDs);
    updatedAdminsUIDs.add(groupAdmin.id);
    final updatedGroupModel = groupModel.copyWith(adminsUIDs: updatedAdminsUIDs);

    await updateGroupDataInFireStore(updatedGroupModel);
  }

  Future<void> removeGroupMember(
      {required UserModel groupMember, required GroupModel groupModel}) async {
    // Créer une copie mutable de membersUIDs
    final updatedMembersUIDs = List<String>.from(groupModel.membersUIDs);
    updatedMembersUIDs.remove(groupMember.id);

    // Créer une copie mutable de adminsUIDs
    final updatedAdminsUIDs = List<String>.from(groupModel.adminsUIDs);
    updatedAdminsUIDs.remove(groupMember.id);

    final updatedGroupModel = groupModel.copyWith(
      membersUIDs: updatedMembersUIDs,
      adminsUIDs: updatedAdminsUIDs,
    );

    await updateGroupDataInFireStore(updatedGroupModel);
  }

  Future<void> removeGroupAdmin(
      {required UserModel groupAdmin, required GroupModel groupModel}) async {
    // Créer une copie mutable de adminsUIDs
    final updatedAdminsUIDs = List<String>.from(groupModel.adminsUIDs);
    updatedAdminsUIDs.remove(groupAdmin.id);
    final updatedGroupModel = groupModel.copyWith(adminsUIDs: updatedAdminsUIDs);

    await updateGroupDataInFireStore(updatedGroupModel);
  }

  Stream<List<GroupModel>> getPrivateGroupsStream({required String userId}) {
    return _firestore
        .collection('groups')
        .where('membersUIDs', arrayContains: userId)
        .where('isPrivate', isEqualTo: true)
        .snapshots()
        .asyncMap((event) {
      try {
        return event.docs
            .map((doc) => GroupModel.fromJson(doc.data()))
            .toList();
      } catch (e) {
        throw Exception("Failed to get private groups stream: $e");
      }
    });
  }

  Stream<List<GroupModel>> getPublicGroupsStream({required String userId}) {
    return _firestore
        .collection('groups')
        .where('isPrivate', isEqualTo: false)
        .snapshots()
        .asyncMap((event) {
      try {
        return event.docs
            .map((doc) => GroupModel.fromJson(doc.data()))
            .toList();
      } catch (e) {
        throw Exception("Failed to get public groups stream: $e");
      }
    });
  }

  Stream<List<GroupModel>> getGroupsStream(String userId) {
    return _firestore
        .collection('groups')
        .where('membersUIDs', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          return GroupModel.fromJson(doc.data());
        }).toList();
      } catch (e) {
        throw Exception("Failed to get groups stream: $e");
      }
    });
  }

  Stream<List<LastMessageModel>> getChatsListStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          return LastMessageModel.fromJson(doc.data());
        }).toList();
      } catch (e) {
        throw Exception("Failed to get chats list stream: $e");
      }
    });
  }

  Future<void> deleteAllGroupsForUser(String userId) async {
    try {
      final userGroups = await _firestore
          .collection('groups')
          .where('membersUIDs', arrayContains: userId)
          .get();

      for (var doc in userGroups.docs) {
        if (doc.data()['adminsUIDs'].length == 1 &&
            doc.data()['adminsUIDs'].contains(userId)) {
          // Si l'utilisateur est le seul admin, supprimez le groupe
          await _firestore.collection('groups').doc(doc.id).delete();
        } else {
          // Sinon, retirez l'utilisateur des membres et des admins
          await _firestore.collection('groups').doc(doc.id).update({
            'membersUIDs': FieldValue.arrayRemove([userId]),
            'adminsUIDs': FieldValue.arrayRemove([userId])
          });
        }
      }
    } catch (e) {
      throw Exception("Failed to delete all groups for user: $e");
    }
  }
}
