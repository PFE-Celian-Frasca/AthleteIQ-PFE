import 'dart:async';
import 'dart:io';

import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/models/message/message_reply_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository repo;
  late ChatController controller;

  setUpAll(() {
    registerFallbackValue(MessageModel(
      senderUID: 'u',
      senderName: 'n',
      senderImage: 'i',
      message: 'm',
      messageType: MessageEnum.text,
      timeSent: DateTime.now(),
      messageId: 'id',
      isSeen: false,
      repliedMessage: '',
      repliedTo: '',
      repliedMessageType: MessageEnum.text,
      reactions: const [],
      isSeenBy: const [],
      deletedBy: const [],
    ));
    registerFallbackValue(File(''));
    registerFallbackValue(<MessageModel>[]);
  });

  setUp(() {
    repo = MockChatRepository();
    controller = ChatController(repo);
  });

  UserModel user() => UserModel(
        id: 'u1',
        pseudo: 'user',
        email: 'u1@mail.com',
        sex: 'M',
        createdAt: DateTime.now(),
      );

  MessageModel sampleMessage() => MessageModel(
        senderUID: 'u1',
        senderName: 'user',
        senderImage: 'img',
        message: 'hi',
        messageType: MessageEnum.text,
        timeSent: DateTime.now(),
        messageId: 'm1',
        isSeen: false,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
        reactions: const [],
        isSeenBy: const [],
        deletedBy: const [],
      );

  test('sendTextMessage success resets state and calls onSuccess', () async {
    when(() => repo.sendTextMessage(messageModel: any(named: 'messageModel'), groupId: 'g'))
        .thenAnswer((_) async {});

    bool called = false;
    await controller.sendTextMessage(
      sender: user(),
      message: 'hi',
      messageType: MessageEnum.text,
      groupId: 'g',
      onSuccess: () => called = true,
      onError: (_) {},
    );

    expect(controller.state.isButtonLoading, false);
    expect(called, true);
  });

  test('sendTextMessage error sets error state and calls onError', () async {
    when(() => repo.sendTextMessage(messageModel: any(named: 'messageModel'), groupId: 'g'))
        .thenThrow(Exception('fail'));

    String? error;
    await controller.sendTextMessage(
      sender: user(),
      message: 'hi',
      messageType: MessageEnum.text,
      groupId: 'g',
      onSuccess: () {},
      onError: (e) => error = e,
    );

    expect(controller.state.isButtonLoading, false);
    expect(error, isNotNull);
  });

  test('sendFileMessage success and failure', () async {
    when(() => repo.sendFileMessage(
        messageModel: any(named: 'messageModel'),
        file: any(named: 'file'),
        groupId: 'g')).thenAnswer((_) async {});

    bool ok = false;
    await controller.sendFileMessage(
      sender: user(),
      file: File(''),
      messageType: MessageEnum.image,
      groupId: 'g',
      onSuccess: () => ok = true,
      onError: (_) {},
    );
    expect(ok, true);

    when(() => repo.sendFileMessage(
        messageModel: any(named: 'messageModel'),
        file: any(named: 'file'),
        groupId: 'g')).thenThrow(Exception('err'));
    await controller.sendFileMessage(
      sender: user(),
      file: File(''),
      messageType: MessageEnum.image,
      groupId: 'g',
      onSuccess: () {},
      onError: (_) {},
    );
    expect(controller.state.isButtonLoading, false);
  });

  test('sendReactionToMessage handles success and error', () async {
    when(() => repo.sendReactionToMessage(
        senderUID: 'u1', groupId: 'g', messageId: 'm', reaction: '👍')).thenAnswer((_) async {});

    await controller.sendReactionToMessage(
      senderUID: 'u1',
      groupId: 'g',
      messageId: 'm',
      reaction: '👍',
    );
    expect(controller.state.isLoading, false);

    when(() => repo.sendReactionToMessage(
        senderUID: 'u1', groupId: 'g', messageId: 'm', reaction: '👍')).thenThrow(Exception('e'));
    await controller.sendReactionToMessage(
      senderUID: 'u1',
      groupId: 'g',
      messageId: 'm',
      reaction: '👍',
    );
    expect(controller.state.isLoading, false);
  });

  test('subscribeToMessagesStream forwards events', () async {
    final controllerStream = StreamController<List<MessageModel>>();
    when(() => repo.getMessagesStream(groupId: 'g')).thenAnswer((_) => controllerStream.stream);

    List<MessageModel>? received;
    controller.subscribeToMessagesStream(
      groupId: 'g',
      onData: (msgs) => received = msgs,
      onError: (_) {},
    );

    controllerStream.add([sampleMessage()]);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(received, isNotNull);
    await controllerStream.close();
  });

  test('getMessagesStream delegates to repository', () {
    when(() => repo.getMessagesStream(groupId: 'g')).thenAnswer((_) => const Stream.empty());
    expect(controller.getMessagesStream(groupId: 'g'), isA<Stream<List<MessageModel>>>());
  });

  test('getUnreadMessagesStream delegates to repository', () {
    when(() => repo.getUnreadMessagesStream(userId: 'u1', groupId: 'g'))
        .thenAnswer((_) => const Stream.empty());
    expect(controller.getUnreadMessagesStream(userId: 'u1', groupId: 'g'), isA<Stream<int>>());
  });

  test('setMessageStatus and deleteMessage set state', () async {
    when(() => repo.setMessageStatus(
        currentUserId: 'u1',
        groupId: 'g',
        messageId: 'm',
        isSeenByList: [])).thenAnswer((_) async {});
    await controller
        .setMessageStatus(currentUserId: 'u1', groupId: 'g', messageId: 'm', isSeenByList: []);
    expect(controller.state.isLoading, false);

    when(() => repo.deleteMessage(
        currentUserId: 'u1',
        groupId: 'g',
        messageId: 'm',
        messageType: 'text',
        deleteForEveryone: false)).thenAnswer((_) async {});
    await controller.deleteMessage(
        currentUserId: 'u1',
        groupId: 'g',
        messageId: 'm',
        messageType: 'text',
        deleteForEveryone: false);
    expect(controller.state.isLoading, false);
  });

  test('getLastMessageStream delegates to repository', () {
    when(() => repo.getLastMessageStream(userId: 'u1', groupId: 'g'))
        .thenAnswer((_) => const Stream.empty());
    expect(
        controller.getLastMessageStream(userId: 'u1', groupId: 'g'), isA<Stream<QuerySnapshot>>());
  });

  test('message reply model setter', () {
    controller.setMessageReplyModel(const MessageReplyModel(
      message: 'm',
      senderUID: 'u1',
      senderName: 'u',
      senderImage: 'img',
      messageType: MessageEnum.text,
      isMe: false,
    ));
    expect(controller.state.messageReplyModel?.message, 'm');
  });
}
