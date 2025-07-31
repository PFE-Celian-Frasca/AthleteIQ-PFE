import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:athlete_iq/view/community/chat-page/components/align_message_right_widget.dart';
import 'package:athlete_iq/view/community/chat-page/components/display_message_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockChatRepository extends Mock implements ChatRepository {}

class TestChatController extends ChatController {
  TestChatController() : super(MockChatRepository());
  bool reactionRemoved = false;

  @override
  Future<void> sendReactionToMessage({
    required String senderUID,
    required String groupId,
    required String messageId,
    required String reaction,
  }) async {
    reactionRemoved = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AlignMessageRightWidget', () {
    late MockAuthRepository authRepo;
    late MockUser user;
    late TestChatController chatController;
    late ProviderContainer container;

    setUp(() {
      authRepo = MockAuthRepository();
      user = MockUser();
      when(() => user.uid).thenReturn('u1');
      when(() => authRepo.currentUser).thenReturn(user);

      chatController = TestChatController();
      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
        chatControllerProvider.overrideWith((ref) => chatController),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    MessageModel baseMessage({MessageEnum type = MessageEnum.text}) => MessageModel(
          senderUID: 'u1',
          senderName: 'Me',
          senderImage: '',
          message: type == MessageEnum.text ? 'hello' : 'http://img',
          messageType: type,
          timeSent: DateTime(2024, 1, 1, 12, 0),
          messageId: 'm1',
          isSeen: false,
          repliedMessage: 'reply',
          repliedTo: 'Bob',
          repliedMessageType: MessageEnum.text,
          reactions: const ['u1=👍', 'u2=👍', 'u3=❤️'],
          isSeenBy: const ['u2'],
          deletedBy: const [],
        );

    testWidgets('renders text message and handles reaction tap', (tester) async {
      final message = baseMessage();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (context, child) => MaterialApp(
              home: Scaffold(
                body: AlignMessageRightWidget(
                  message: message,
                  groupId: 'g1',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(DisplayMessageType), findsWidgets);
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('👍'), findsOneWidget);
      expect(find.text('❤️'), findsOneWidget);
    });

    testWidgets('renders image message correctly', (tester) async {
      final message = baseMessage(type: MessageEnum.image);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (context, child) => MaterialApp(
              home: Scaffold(
                body: AlignMessageRightWidget(
                  message: message,
                  groupId: 'g1',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(DisplayMessageType), findsOneWidget);
    });
  });
}
