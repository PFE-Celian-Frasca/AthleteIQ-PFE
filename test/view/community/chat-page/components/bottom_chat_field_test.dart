import 'dart:io';

import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:athlete_iq/view/community/chat-page/components/bottom_chat_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}
class MockUserRepository extends Mock implements UserRepository {}
class MockChatRepository extends Mock implements ChatRepository {}

class TestChatController extends ChatController {
  TestChatController() : super(MockChatRepository());
  bool textSent = false;
  bool fileSent = false;

  @override
  Future<void> sendTextMessage({
    required UserModel sender,
    required String message,
    required MessageEnum messageType,
    required String groupId,
    required VoidCallback onSuccess,
    required void Function(String) onError,
  }) async {
    textSent = true;
    onSuccess();
  }

  @override
  Future<void> sendFileMessage({
    required UserModel sender,
    required File file,
    required MessageEnum messageType,
    required String groupId,
    required VoidCallback onSuccess,
    required void Function(String) onError,
  }) async {
    fileSent = true;
    onSuccess();
  }
}


class TestBottomChatField extends BottomChatField {
  const TestBottomChatField({super.key, required super.groupId});

  @override
  BottomChatFieldState createState() => TestBottomChatFieldState();
}

class TestBottomChatFieldState extends BottomChatFieldState {
  @override
  Future<bool> checkMicrophonePermission() async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  const recordChannel = MethodChannel('com.josephcrowell.flutter_sound_record');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getTemporaryDirectory') return '/tmp';
      return null;
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, null);
  });

  group('BottomChatField', () {
    late MockAuthRepository authRepo;
    late MockUserRepository userRepo;
    late MockUser user;
    late TestChatController chatController;
    late ProviderContainer container;

    setUp(() {
      authRepo = MockAuthRepository();
      userRepo = MockUserRepository();
      user = MockUser();
      when(() => user.uid).thenReturn('u1');
      when(() => authRepo.currentUser).thenReturn(user);
      when(() => userRepo.getUserData('u1')).thenAnswer((_) async => UserModel(
            id: 'u1',
            pseudo: 'me',
            email: 'e',
            sex: 'M',
            createdAt: DateTime.now(),
          ));

      chatController = TestChatController();
      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
        userRepositoryProvider.overrideWithValue(userRepo),
        chatControllerProvider.overrideWith((ref) => chatController),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('send text and audio message', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(body: TestBottomChatField(groupId: 'g1')),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextFormField), 'hi');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(chatController.textSent, isTrue);

      final state = tester.state<TestBottomChatFieldState>(find.byType(TestBottomChatField));
      state.startRecording();
      await tester.pump();
      expect(state.isRecording, isTrue);
      state.stopRecording();
      await tester.pump();
      expect(chatController.fileSent, isTrue);
    });
  });
}
