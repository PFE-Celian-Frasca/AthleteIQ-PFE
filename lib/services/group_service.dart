import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/group/group_model.dart';
import '../models/message/message_model.dart';
import '../utils/internal_notification/internal_notification_provider.dart';

final groupService = Provider<GroupService>((ref) {
  return GroupService(FirebaseFirestore.instance, FirebaseStorage.instance);
});

class GroupService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  GroupService(this._firestore, this._storage);

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      // Query to find groups where the user is a member
      final memberSnapshot = await _firestore
          .collection('groups')
          .where('members', arrayContains: userId)
          .get();

      // Query to find groups where the user is an admin
      final adminSnapshot = await _firestore
          .collection('groups')
          .where('admin', isEqualTo: userId)
          .get();

      // Combine the documents from both queries
      final documents = {
        ...memberSnapshot.docs.map((doc) => doc.id),
        ...adminSnapshot.docs.map((doc) => doc.id)
      }.toList(); // Removes duplicates by converting to a set first

      // Map combined document snapshots to GroupModel
      List<GroupModel> groups = [];
      for (var docId in documents) {
        var docSnapshot =
            await _firestore.collection('groups').doc(docId).get();
        groups.add(
            GroupModel.fromJson(docSnapshot.data() as Map<String, dynamic>));
      }

      return groups;
    } catch (e) {
      handleError(e, 'get user groups');
      rethrow; // Ensure the caller is aware that an error occurred
    }
  }

  Stream<List<GroupModel>> listAllGroupsStream() {
    return _firestore.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GroupModel.fromJson(doc.data());
      }).toList();
    });
  }

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
        newGroup.copyWith(id: documentReference.id, groupIcon: imageUrl);
    try {
      await _firestore
          .collection('groups')
          .doc(groupWithId.id)
          .set(groupWithId.toJson());
    } catch (e) {
      debugPrint('Failed to create group: $e');
      handleError(e, 'createGroup');
      rethrow;
    }
  }

  Future<void> updateGroupImage(String groupId, File newImageFile) async {
    String newImageUrl = await uploadGroupImage(groupId, newImageFile);
    await _firestore
        .collection('groups')
        .doc(groupId)
        .update({'imageUrl': newImageUrl});
  }

  Future<void> updateGroup(GroupModel updatedGroup) async {
    await _firestore
        .collection('groups')
        .doc(updatedGroup.id)
        .update(updatedGroup.toJson());
  }

  Future<void> deleteGroup(String groupId) async {
    // First, delete the group image from Firebase Storage if it exists.
    try {
      await _storage.ref('group_images/$groupId').delete();
    } catch (e) {
      print("No image to delete or deletion failed: $e");
    }

    // Then, delete the group document from Firestore.
    try {
      await _firestore.collection('groups').doc(groupId).delete();
    } catch (e) {
      print("Failed to delete group: $e");
      throw Exception('Failed to delete group');
    }
  }

  Future<GroupModel> getUserGroupById(String groupId) async {
    final docSnapshot =
        await _firestore.collection('groups').doc(groupId).get();
    if (docSnapshot.exists) {
      return GroupModel.fromJson(docSnapshot.data()!);
    } else {
      throw Exception("Group not found!");
    }
  }

  Future<void> sendMessageToGroup(String groupId, String senderId,
      String content, List<File> imageFiles) async {
    var messageId = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Generate unique ID for message
    List<String> imageUrls = [];

    // First, upload all images and collect their URLs
    for (File imageFile in imageFiles) {
      var imageUrl = await uploadMessageImage(groupId, messageId, imageFile);
      imageUrls.add(imageUrl);
    }

    // Create a new message model with both text and image URLs
    var newMessage = MessageModel(
      id: messageId,
      sender: senderId,
      content: content,
      createdAt: DateTime.now(),
      images: imageUrls,
    );

    // Save the message to Firestore
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toJson());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<String> uploadMessageImage(
      String groupId, String messageId, File image) async {
    var snapshot = await _storage
        .ref('message_images/$groupId/$messageId/${image.path.split('/').last}')
        .putFile(image);
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> toggleGroupNotifications(String groupId, bool isEnabled) async {
    // Cette fonctionnalité peut nécessiter la mise à jour d'un champ spécifique dans Firestore ou la gestion via une autre méthode selon l'implémentation des notifications.
  }

  Future<void> updateGroupPrivacySettings(
      String groupId, bool isPrivate) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .update({'type': isPrivate ? 'private' : 'public'});
  }

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

  DocumentSnapshot? _lastGroupDocument;

  Future<List<GroupModel>> searchGroups(String query, {int limit = 10}) async {
    try {
      final formattedQuery = query.toLowerCase().trim();
      var querySnapshot = await _firestore
          .collection('groups')
          .where('groupName', isGreaterThanOrEqualTo: formattedQuery)
          .where('groupName', isLessThanOrEqualTo: formattedQuery + '\uf8ff')
          .limit(limit)
          .get();
      return querySnapshot.docs
          .map((doc) => GroupModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search groups: $e');
    }
  }

  Future<List<GroupModel>> loadMoreGroups({int limit = 10}) async {
    try {
      Query queryRef = _firestore.collection('groups').orderBy('groupName');
      if (_lastGroupDocument != null) {
        queryRef = queryRef.startAfterDocument(_lastGroupDocument!);
      }
      var querySnapshot = await queryRef.limit(limit).get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      _lastGroupDocument = querySnapshot.docs.last; // Update last document
      return querySnapshot.docs
          .map((doc) => GroupModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search groups: $e');
    }
  }

  void resetPagination() {
    _lastGroupDocument = null;
  }

  // Lister tous les groupes (pourrait être filtré selon les besoins)
  Future<List<GroupModel>> listAllGroups() async {
    final querySnapshot = await _firestore.collection('groups').get();

    return querySnapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data()))
        .toList();
  }

  Stream<List<MessageModel>> getGroupMessagesStream(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }
}
