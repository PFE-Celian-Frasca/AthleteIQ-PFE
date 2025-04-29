import 'dart:io';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/models/message/last_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ChatRepository(this._firestore, this._storage);

  Future<void> sendTextMessage({
    required MessageModel messageModel,
    required String groupId,
  }) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageModel.messageId)
          .set(messageModel.toJson());

      await _firestore.collection('groups').doc(groupId).update({
        'lastMessage': messageModel.message,
        'timeSent': Timestamp.fromDate(DateTime.now()),
        'senderUID': messageModel.senderUID,
        'messageType': messageModel.messageType.name,
      });
    } catch (e) {
      throw Exception("Failed to send text message: $e");
    }
  }

  Future<void> sendFileMessage({
    required MessageModel messageModel,
    required File file,
    required String groupId,
  }) async {
    try {
      final ref =
          'chatFiles/${messageModel.messageType.name}/${messageModel.senderUID}/${messageModel.messageId}';
      final fileUrl = await _storage
          .ref(ref)
          .putFile(file)
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

      final updatedMessageModel = messageModel.copyWith(message: fileUrl);

      await sendTextMessage(
          messageModel: updatedMessageModel, groupId: groupId);
    } catch (e) {
      throw Exception("Failed to send file message: $e");
    }
  }

  Future<void> sendReactionToMessage({
    required String senderUID,
    required String groupId,
    required String messageId,
    required String reaction,
  }) async {
    try {
      final messageData = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .get();

      final message = MessageModel.fromJson(messageData.data()!);
      final reactionToAdd = '$senderUID=$reaction';

      final uids = message.reactions.map((e) => e.split('=')[0]).toList();

      List<String> modifiableReactions = List.from(message.reactions);

      if (reaction.isEmpty) {
        modifiableReactions.removeWhere((e) => e.startsWith('$senderUID='));
      } else if (uids.contains(senderUID)) {
        final index = uids.indexOf(senderUID);
        modifiableReactions[index] = reactionToAdd;
      } else {
        modifiableReactions.add(reactionToAdd);
      }

      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .update({'reactions': modifiableReactions});
    } catch (e) {
      throw Exception("Failed to send reaction to message: $e");
    }
  }

  Future<void> setMessageStatus({
    required String currentUserId,
    required String groupId,
    required String messageId,
    required List<String> isSeenByList,
  }) async {
    try {
      if (isSeenByList.contains(currentUserId)) {
        return;
      } else {
        await _firestore
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(messageId)
            .update({
          'isSeenBy': FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      throw Exception("Failed to set message status: $e");
    }
  }

  Future<void> deleteMessage({
    required String currentUserId,
    required String groupId,
    required String messageId,
    required String messageType,
    required bool deleteForEveryone,
  }) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .update({
        'deletedBy': FieldValue.arrayUnion([currentUserId])
      });

      if (deleteForEveryone) {
        final groupData =
            await _firestore.collection('groups').doc(groupId).get();
        final List<String> groupMembers =
            List<String>.from(groupData.data()!['membersUIDs']);

        await _firestore
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(messageId)
            .update({'deletedBy': FieldValue.arrayUnion(groupMembers)});

        if (messageType != MessageEnum.text.name) {
          await deleteFileFromStorage(
            currentUserId: currentUserId,
            groupId: groupId,
            messageId: messageId,
            messageType: messageType,
          );
        }
      }
    } catch (e) {
      throw Exception("Failed to delete message: $e");
    }
  }

  Future<void> deleteFileFromStorage({
    required String currentUserId,
    required String groupId,
    required String messageId,
    required String messageType,
  }) async {
    try {
      final ref = 'chatFiles/$messageType/$currentUserId/$groupId/$messageId';
      await _storage.ref(ref).delete();
    } catch (e) {
      throw Exception("Failed to delete file from storage: $e");
    }
  }

  Stream<List<LastMessageModel>> getChatsListStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timeSent', descending: false)
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

  Stream<List<MessageModel>> getMessagesStream({
    required String groupId,
  }) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          return MessageModel.fromJson(doc.data());
        }).toList();
      } catch (e) {
        throw Exception("Failed to get messages stream: $e");
      }
    });
  }

  Stream<int> getUnreadMessagesStream({
    required String userId,
    required String groupId,
  }) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .snapshots()
        .asyncMap((event) {
      try {
        int count = 0;
        for (var doc in event.docs) {
          final message = MessageModel.fromJson(doc.data());
          if (!message.isSeenBy.contains(userId)) {
            count++;
          }
        }
        return count;
      } catch (e) {
        throw Exception("Failed to get unread messages stream: $e");
      }
    });
  }

  Stream<QuerySnapshot> getLastMessageStream({
    required String userId,
    required String groupId,
  }) {
    return groupId.isNotEmpty
        ? _firestore
            .collection('groups')
            .where('membersUIDs', arrayContains: userId)
            .snapshots()
        : _firestore
            .collection('users')
            .doc(userId)
            .collection('chats')
            .snapshots();
  }

  Future<void> deleteAllMessagesForUser(String userId) async {
    try {
      final userMessages = await _firestore
          .collectionGroup('messages')
          .where('senderUID', isEqualTo: userId)
          .get();

      for (var doc in userMessages.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception("Failed to delete all messages for user: $e");
    }
  }
}
