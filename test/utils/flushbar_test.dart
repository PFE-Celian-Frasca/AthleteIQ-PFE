import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/utils/internal_notification/flushbar.dart';

void main() {
  const channel = MethodChannel('PonnamKarthik/fluttertoast');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      return true; // prevent missing plugin exceptions
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('fieldFocusChange moves focus', (tester) async {
    final focus1 = FocusNode();
    final focus2 = FocusNode();
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: Column(
          children: [
            TextField(focusNode: focus1),
            TextField(focusNode: focus2),
          ],
        ),
      ),
    ));

    focus1.requestFocus();
    await tester.pump();
    expect(focus1.hasFocus, isTrue);

    FlushBarUtils.fieldFocusChange(
        tester.element(find.byType(TextField).first), focus1, focus2);
    await tester.pump();
    expect(focus2.hasFocus, isTrue);
  });

  testWidgets('toastMessage sends method channel call', (tester) async {
    bool called = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      if (methodCall.method == 'showToast') {
        called = true;
      }
      return true;
    });

    await tester.runAsync(() async {
      FlushBarUtils.toastMessage('hello');
    });
    await tester.pump();
    expect(called, isTrue);
  });

  testWidgets('snackBar shows SnackBar widget', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () {
                FlushBarUtils.snackBar('msg', context);
              },
              child: const Text('tap'),
            ),
          ),
        );
      }),
    ));

    await tester.tap(find.text('tap'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
