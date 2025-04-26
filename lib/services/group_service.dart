import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/group/group_model.dart';
import '../models/message/message_model.dart';
import '../utils/internal_notification/internal_notification_service.dart';

// Provider for GroupService
final groupService = Provider<GroupService>((ref) {
  return GroupService(FirebaseFirestore.instance, FirebaseStorage.instance);
});

// GroupService class definition
class GroupService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  GroupService(this._firestore, this._storage);

  // Fetch user groups as a stream
  Stream<List<GroupModel>> getUserGroupsStream(String userId) {
    return _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupModel.fromJson(doc.data()))
            .toList());
  }

  // Stream all groups
  Stream<List<GroupModel>> listAllGroupsStream() {
    return _firestore.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GroupModel.fromJson(doc.data());
      }).toList();
    });
  }

  // Upload group image
  Future<String> uploadGroupImage(String groupId, File imageFile) async {
    try {
      var snapshot =
          await _storage.ref('group_images/$groupId').putFile(imageFile);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Failed to upload group image: $e');
      handleError(e, 'uploadGroupImage');
      rethrow;
    }
  }

  // Create a new group
  Future<void> createGroup(GroupModel newGroup, {File? imageFile}) async {
    DocumentReference documentReference = _firestore.collection('groups').doc();
    String imageUrl = '';

    if (imageFile != null) {
      try {
        imageUrl = await uploadGroupImage(documentReference.id, imageFile);
      } catch (e) {
        handleError(e, 'createGroup');
      }
    }

    final groupWithId =
        newGroup.copyWith(groupId: documentReference.id, groupImage: imageUrl);
    try {
      await _firestore
          .collection('groups')
          .doc(groupWithId.groupId)
          .set(groupWithId.toJson());
    } catch (e) {
      debugPrint('Failed to create group: $e');
      handleError(e, 'createGroup');
      rethrow;
    }
  }

  // Update group image
  Future<void> updateGroupImage(String groupId, File newImageFile) async {
    String newImageUrl = await uploadGroupImage(groupId, newImageFile);
    await _firestore
        .collection('groups')
        .doc(groupId)
        .update({'imageUrl': newImageUrl});
  }

  // Update group details
  Future<void> updateGroup(GroupModel updatedGroup) async {
    await _firestore
        .collection('groups')
        .doc(updatedGroup.groupId)
        .update(updatedGroup.toJson());
  }

  // Delete a group
  Future<void> deleteGroup(String groupId) async {
    try {
      await _storage.ref('group_images/$groupId').delete();
    } catch (e) {
      rethrow;
    }

    try {
      await _firestore.collection('groups').doc(groupId).delete();
    } catch (e) {
      throw Exception('Failed to delete group');
    }
  }

  // Fetch group details by ID
  Future<GroupModel> getUserGroupById(String groupId) async {
    final docSnapshot =
        await _firestore.collection('groups').doc(groupId).get();
    if (docSnapshot.exists) {
      return GroupModel.fromJson(docSnapshot.data()!);
    } else {
      throw Exception("Group not found!");
    }
  }

  // Add a member to a group
  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId])
    });
  }

  // Remove a member from a group
  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([userId])
    });
  }

  // Toggle group notifications
  Future<void> toggleGroupNotifications(String groupId, bool isEnabled) async {
    // Cette fonctionnalité peut nécessiter la mise à jour d'un champ spécifique dans Firestore ou la gestion via une autre méthode selon l'implémentation des notifications.
  }

  // Update group privacy settings
  Future<void> updateGroupPrivacySettings(
      String groupId, bool isPrivate) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .update({'type': isPrivate ? 'private' : 'public'});
  }

  // Moderate group content
  Future<void> moderateGroupContent(
      String groupId, String contentId, bool isRemove) async {
    if (isRemove) {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(contentId)
          .delete();
    }
  }

  // Search groups
  Future<List<GroupModel>> searchGroups(String query, {int limit = 10}) async {
    try {
      final formattedQuery = query.toLowerCase().trim();
      var querySnapshot = await _firestore
          .collection('groups')
          .where('groupName', isGreaterThanOrEqualTo: formattedQuery)
          .where('groupName', isLessThanOrEqualTo: '$formattedQuery\uf8ff')
          .limit(limit)
          .get();
      return querySnapshot.docs
          .map((doc) => GroupModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search groups: $e');
    }
  }

  // List all groups
  Future<List<GroupModel>> listAllGroups() async {
    final querySnapshot = await _firestore.collection('groups').get();
    return querySnapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data()))
        .toList();
  }

  // Stream group messages
// Stream group messages
  Stream<List<MessageModel>> getGroupMessagesStream(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> addReaction(
      String groupId, String messageId, String userId, String reaction) async {
    final messageRef = _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId);
    await messageRef.update({'reactions.$userId': reaction});
  }

  Future<void> removeReaction(
      String groupId, String messageId, String userId) async {
    final messageRef = _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId);
    await messageRef.update({'reactions.$userId': FieldValue.delete()});
  }

  Future<void> markMessageAsRead(
      String groupId, String messageId, String userId) async {
    final messageRef = _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId);

    await messageRef.update({
      'readBy': FieldValue.arrayUnion([userId])
    });
  }

  // Stream group details
  Stream<GroupModel> getGroupDetailsStream(String groupId) {
    return _firestore.collection('groups').doc(groupId).snapshots().map((doc) {
      if (doc.exists) {
        return GroupModel.fromJson(doc.data()!);
      } else {
        throw Exception("Group not found!");
      }
    });
  }
}
