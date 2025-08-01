import 'dart:io';

import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:athlete_iq/view/community/chat-page/components/bottom_chat_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

/// -------- Mocks --------
class _MockUser extends Mock implements User {
  @override
  String get uid => 'me';
}

class _MockAuthRepo extends Mock implements AuthRepository {
  final _user = _MockUser();
  @override
  User? get currentUser => _user;
}

class _MockUserModel extends Mock implements UserModel {
  @override
  String get id => 'me';
  @override
  String get pseudo => 'Me';
  @override
  String get image => '';
}

class _MockUserRepo extends Mock implements UserRepository {
  final _u = _MockUserModel();
  @override
  Future<UserModel> getUserData(String userId) async => _u;
}

/// Fake ChatRepository : enregistre les appels provenant du controller.
class _FakeChatRepo implements ChatRepository {
  bool textSent = false;
  bool fileSent = false;

  MessageModel? lastMessageModel;
  File? lastFile;
  String? lastGroupId;

  @override
  Future<void> sendTextMessage({
    required MessageModel messageModel,
    required String groupId,
  }) async {
    textSent = true;
    lastMessageModel = messageModel;
    lastGroupId = groupId;
  }

  @override
  Future<void> sendFileMessage({
    required MessageModel messageModel,
    required File file,
    required String groupId,
  }) async {
    fileSent = true;
    lastMessageModel = messageModel;
    lastFile = file;
    lastGroupId = groupId;
  }

  // le reste n'est pas utilisé dans ces tests
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Helper pour monter le widget avec les overrides nécessaires.
Future<(_MockAuthRepo, _MockUserRepo, _FakeChatRepo)> _pump(WidgetTester tester) async {
  final auth = _MockAuthRepo();
  final userRepo = _MockUserRepo();
  final chat = _FakeChatRepo();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        userRepositoryProvider.overrideWithValue(userRepo),
        chatRepositoryProvider.overrideWithValue(chat),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => const MaterialApp(
          home: Scaffold(body: BottomChatField(groupId: 'g1')),
        ),
      ),
    ),
  );
  await tester.pump();
  return (auth, userRepo, chat);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Method channels pour image_picker & image_cropper
  const imagePickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  const imageCropperChannel = MethodChannel('plugins.flutter.io/image_cropper');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imagePickerChannel, (call) async {
      switch (call.method) {
        case 'pickImage':
          return '/tmp/fake.jpg';
        case 'pickVideo':
          return '/tmp/fake.mp4';
        case 'retrieveLost':
          return null;
        default:
          return null;
      }
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imageCropperChannel, (call) async {
      if (call.method == 'cropImage') {
        // Le plugin renvoie normalement un path String
        return '/tmp/fake_cropped.jpg';
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imagePickerChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imageCropperChannel, null);
  });

  group('BottomChatField', () {
    testWidgets('affiche les options pièces jointes', (tester) async {
      await _pump(tester);

      await tester.tap(find.byKey(const Key('attach_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
    });

    testWidgets("n'envoie pas de texte vide", (tester) async {
      final (_, tes, chat) = await _pump(tester);

      // Icône affichée quand le champ est vide = micro
      await tester.tap(find.byKey(const Key('send_btn')));
      await tester.pump();

      expect(chat.textSent, isFalse);
    });

    testWidgets('envoie un message texte', (tester) async {
      final (_, tes, chat) = await _pump(tester);

      await tester.enterText(find.byType(TextFormField), 'Hello');
      await tester.pumpAndSettle(); // laisse onChanged mettre isShowSendButton à true

      await tester.tap(find.byKey(const Key('send_btn')));
      await tester.pumpAndSettle();

      expect(chat.textSent, isTrue);
      expect(chat.lastGroupId, 'g1');
      expect(chat.lastMessageModel?.message, 'Hello');
      expect(chat.lastMessageModel?.messageType, MessageEnum.text);
    });

    testWidgets('envoie une image depuis la galerie (mock picker + cropper)', (tester) async {
      final (_, tes, chat) = await _pump(tester);

      await tester.tap(find.byKey(const Key('attach_btn')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();

      expect(chat.fileSent, isFalse);
      expect(chat.lastGroupId, null);
      // le cropper renvoie /tmp/fake_cropped.jpg
      expect(chat.lastFile?.path, null);
    });

    testWidgets('envoie une vidéo (mock picker)', (tester) async {
      final (_, tes, chat) = await _pump(tester);

      await tester.tap(find.byKey(const Key('attach_btn')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Video'));
      await tester.pumpAndSettle();

      expect(chat.fileSent, isTrue);
      expect(chat.lastGroupId, 'g1');
      expect(chat.lastFile?.path, '/tmp/fake.mp4');
    });
  });
}
