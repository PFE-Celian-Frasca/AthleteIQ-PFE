import 'dart:async';

import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:athlete_iq/view/community/chat-page/components/chat_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class TestChatController extends ChatController {
  TestChatController(this.messageStream) : super(MockChatRepository());
  final Stream<List<MessageModel>> messageStream;
  bool statusCalled = false;

  @override
  Stream<List<MessageModel>> getMessagesStream({required String groupId}) => messageStream;

  @override
  Future<void> setMessageStatus({
    required String currentUserId,
    required String groupId,
    required String messageId,
    required List<String> isSeenByList,
  }) async {
    statusCalled = true;
  }
}

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatList', () {
    late MockAuthRepository authRepo;
    late MockUser user;
    late StreamController<List<MessageModel>> controller;
    late TestChatController chatController;
    late ProviderContainer container;

    setUp(() {
      authRepo = MockAuthRepository();
      user = MockUser();
      when(() => user.uid).thenReturn('u1');
      when(() => authRepo.currentUser).thenReturn(user);
      controller = StreamController<List<MessageModel>>();
      chatController = TestChatController(controller.stream);
      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
        chatControllerProvider.overrideWith((ref) => chatController),
      ]);
    });

    tearDown(() async {
      await controller.close();
      container.dispose();
    });

    testWidgets('shows progress and empty state', (tester) async {
      controller.add([]);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (context, child) => const MaterialApp(
              home: ChatList(groupId: 'g1'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Commencez une conversation'), findsOneWidget);
    });
  });
}
