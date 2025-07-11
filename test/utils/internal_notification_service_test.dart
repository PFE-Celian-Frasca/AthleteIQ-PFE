import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('PonnamKarthik/fluttertoast');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async => true);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('handleError throws formatted exception', () {
    expect(() => handleError('error', 'load'), throwsA(isA<Exception>()));
  });

  testWidgets('showToast delegates to FlushBarUtils', (tester) async {
    bool called = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      if (methodCall.method == 'showToast') called = true;
      return true;
    });

    final service = InternalNotificationService();
    await tester.runAsync(() async {
      service.showToast('msg');
    });
    await tester.pump();
    expect(called, isTrue);
  });

  testWidgets('showErrorToast delegates to FlushBarUtils', (tester) async {
    bool called = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      if (methodCall.method == 'showToast') called = true;
      return true;
    });

    final service = InternalNotificationService();
    await tester.runAsync(() async {
      service.showErrorToast('msg');
    });
    await tester.pump();
    expect(called, isTrue);
  });
}
