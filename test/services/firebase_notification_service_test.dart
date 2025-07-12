import 'dart:async';
import 'package:athlete_iq/services/firebase_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';

class _FakePlatform extends FlutterLocalNotificationsPlatform {
  @override
  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() async => null;

  @override
  Future<void> show(int id, String? title, String? body, {String? payload}) async {}
}

void main() {
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    FlutterLocalNotificationsPlatform.instance = _FakePlatform();
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  testWidgets('showNotification does not throw', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel, (MethodCall methodCall) async {
      return null;
    });

    const message = RemoteMessage(
      data: {'a': 'b'},
      notification: RemoteNotification(title: 't', body: 'b'),
    );
    await tester.runAsync(() async {
      FirebaseNotificationService.showNotification(message);
      await Future<void>.delayed(Duration.zero);
    });
    expect(true, isTrue); // if no exception thrown
  });
}
