import 'dart:io';

import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/utils/global_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const pickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      pickerChannel,
      (methodCall) async => '${Directory.systemTemp.path}/tmp',
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, null);
  });

  testWidgets('showSnackBar displays message', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return TextButton(
            onPressed: () => showSnackBar(context, 'hi'),
            child: const Text('tap'),
          );
        }),
      ),
    ));

    await tester.tap(find.text('tap'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('userImageWidget uses correct image provider', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: userImageWidget(
        imageUrl: 'url',
        radius: 10,
        onTap: () => tapped = true,
      ),
    ));

    await tester.tap(find.byType(GestureDetector));
    expect(tapped, isTrue);
    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(avatar.backgroundImage, isA<CachedNetworkImageProvider>());
  });

  group('pickImage', () {
    testWidgets('from camera success', (tester) async {
      final file = await tester.runAsync(() => pickImage(fromCamera: true, onFail: (_) {}));
      expect(file, isA<File>());
    });

    testWidgets('from gallery failure', (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pickerChannel, (methodCall) async => null);

      String? error;
      final file =
          await tester.runAsync(() => pickImage(fromCamera: false, onFail: (e) => error = e));
      expect(file, isNull);
      expect(error, isNotNull);
    });
  });

  testWidgets('pickVideo success', (tester) async {
    final file = await tester.runAsync(() => pickVideo(onFail: (_) {}));
    expect(file, isA<File>());
  });

  testWidgets('buildDateTime returns centered text', (tester) async {
    final message = MessageModel(
      senderUID: 's',
      senderName: 'n',
      senderImage: '',
      message: 'm',
      messageType: MessageEnum.text,
      timeSent: DateTime(2024, 1, 1),
      messageId: 'id',
      isSeen: false,
      repliedMessage: '',
      repliedTo: '',
      repliedMessageType: MessageEnum.text,
      reactions: const [],
      isSeenBy: const [],
      deletedBy: const [],
    );
    await tester.pumpWidget(MaterialApp(home: buildDateTime(message)));
    expect(find.text('01 Jan, 2024'), findsOneWidget);
  });

  test('messageToShow builds widgets', () {
    expect(messageToShow(type: MessageEnum.text, message: 'hi'), isA<Text>());
    expect(messageToShow(type: MessageEnum.image, message: ''), isA<Row>());
    expect(messageToShow(type: MessageEnum.video, message: ''), isA<Row>());
  });

  testWidgets('showMyAnimatedDialog returns action result', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return TextButton(
          onPressed: () => showMyAnimatedDialog(
            context: context,
            title: 't',
            content: 'c',
            textAction: 'ok',
            onActionTap: (v) => result = v,
          ),
          child: const Text('open'),
        );
      }),
    ));

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });
}
