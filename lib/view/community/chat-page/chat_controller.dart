import 'dart:async';
import 'dart:io';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/last_message_model.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:athlete_iq/models/message/message_reply_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:athlete_iq/view/community/chat-page/chat_state.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(FirebaseFirestore.instance, FirebaseStorage.instance);
});

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatController(chatRepository);
});

class ChatController extends StateNotifier<ChatState> {
  final ChatRepository _chatRepository;

  ChatController(this._chatRepository) : super(const ChatState());

  StreamSubscription<List<MessageModel>>? _messageStreamSubscription;

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
    super.dispose();
  }

  Stream<List<MessageModel>> getMessagesStream({required String groupId}) {
    return _chatRepository.getMessagesStream(groupId: groupId);
  }

  Future<void> sendTextMessage({
    required UserModel sender,
    required String message,
    required MessageEnum messageType,
    required String groupId,
    required VoidCallback onSuccess,
    required void Function(String) onError,
  }) async {
    _setButtonLoadingState();
    try {
      final messageId = const Uuid().v4();

      final repliedMessage = state.messageReplyModel?.message ?? '';
      final repliedTo = state.messageReplyModel == null
          ? ''
          : state.messageReplyModel!.isMe
              ? 'You'
              : state.messageReplyModel!.senderName;
      final repliedMessageType = state.messageReplyModel?.messageType ?? MessageEnum.text;

      final messageModel = MessageModel(
        senderUID: sender.id,
        senderName: sender.pseudo,
        senderImage: sender.image,
        message: message,
        messageType: messageType,
        timeSent: DateTime.now(),
        messageId: messageId,
        isSeen: false,
        repliedMessage: repliedMessage,
        repliedTo: repliedTo,
        repliedMessageType: repliedMessageType,
        reactions: [],
        isSeenBy: [sender.id],
        deletedBy: [],
      );

      await _chatRepository.sendTextMessage(messageModel: messageModel, groupId: groupId);
      _resetState();
      onSuccess();
    } catch (e) {
      _setErrorState(e);
      onError(e.toString());
    }
  }

  Future<void> sendFileMessage({
    required UserModel sender,
    required File file,
    required MessageEnum messageType,
    required String groupId,
    required VoidCallback onSuccess,
    required void Function(String) onError,
  }) async {
    _setButtonLoadingState();
    try {
      final messageId = const Uuid().v4();

      final repliedMessage = state.messageReplyModel?.message ?? '';
      final repliedTo = state.messageReplyModel == null
          ? ''
          : state.messageReplyModel!.isMe
              ? 'Vous'
              : state.messageReplyModel!.senderName;
      final repliedMessageType = state.messageReplyModel?.messageType ?? MessageEnum.text;

      final messageModel = MessageModel(
        senderUID: sender.id,
        senderName: sender.pseudo,
        senderImage: sender.image,
        message: '',
        messageType: messageType,
        timeSent: DateTime.now(),
        messageId: messageId,
        isSeen: false,
        repliedMessage: repliedMessage,
        repliedTo: repliedTo,
        repliedMessageType: repliedMessageType,
        reactions: [],
        isSeenBy: [sender.id],
        deletedBy: [],
      );

      await _chatRepository.sendFileMessage(
          messageModel: messageModel, file: file, groupId: groupId);
      _resetState();
      onSuccess();
    } catch (e) {
      _setErrorState(e);
      onError(e.toString());
    }
  }

  Future<void> sendReactionToMessage({
    required String senderUID,
    required String groupId,
    required String messageId,
    required String reaction,
  }) async {
    _setLoadingState();
    try {
      await _chatRepository.sendReactionToMessage(
        senderUID: senderUID,
        groupId: groupId,
        messageId: messageId,
        reaction: reaction,
      );
      _resetState();
    } catch (e) {
      _setErrorState(e);
    }
  }

  Stream<List<LastMessageModel>> getChatsListStream(String userId) {
    return _chatRepository.getChatsListStream(userId);
  }

  void subscribeToMessagesStream({
    required String groupId,
    required void Function(List<MessageModel>) onData,
    required void Function(Object) onError,
  }) {
    _messageStreamSubscription?.cancel();
    _messageStreamSubscription =
        _chatRepository.getMessagesStream(groupId: groupId).listen(onData, onError: onError);
  }

  Stream<int> getUnreadMessagesStream({
    required String userId,
    required String groupId,
  }) {
    return _chatRepository.getUnreadMessagesStream(
      userId: userId,
      groupId: groupId,
    );
  }

  Future<void> setMessageStatus({
    required String currentUserId,
    required String groupId,
    required String messageId,
    required List<String> isSeenByList,
  }) async {
    _setLoadingState();
    try {
      await _chatRepository.setMessageStatus(
        currentUserId: currentUserId,
        groupId: groupId,
        messageId: messageId,
        isSeenByList: isSeenByList,
      );
      _resetState();
    } catch (e) {
      _setErrorState(e);
    }
  }

  Future<void> deleteMessage({
    required String currentUserId,
    required String groupId,
    required String messageId,
    required String messageType,
    required bool deleteForEveryone,
  }) async {
    _setLoadingState();
    try {
      await _chatRepository.deleteMessage(
        currentUserId: currentUserId,
        groupId: groupId,
        messageId: messageId,
        messageType: messageType,
        deleteForEveryone: deleteForEveryone,
      );
      _resetState();
    } catch (e) {
      _setErrorState(e);
    }
  }

  Stream<QuerySnapshot> getLastMessageStream({
    required String userId,
    required String groupId,
  }) {
    return _chatRepository.getLastMessageStream(
      userId: userId,
      groupId: groupId,
    );
  }

  void _setLoadingState() {
    state = state.copyWith(isLoading: true);
  }

  void _setButtonLoadingState() {
    state = state.copyWith(isButtonLoading: true);
  }

  void _resetState() {
    state = state.copyWith(isLoading: false, isButtonLoading: false, messageReplyModel: null);
  }

  void _setErrorState(dynamic error) {
    state = state.copyWith(isLoading: false, isButtonLoading: false);
  }

  void setMessageReplyModel(MessageReplyModel? messageReply) {
    state = state.copyWith(messageReplyModel: messageReply);
  }
}
