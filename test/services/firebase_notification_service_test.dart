import 'package:athlete_iq/services/firebase_notification_service.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athlete_iq/utils/routing/app_router.dart';

class _FakePlatform extends FlutterLocalNotificationsPlatform {
  @override
  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() async => null;

  @override
  Future<void> show(int id, String? title, String? body, {String? payload}) async {}
}

class _FakeRouter extends Fake implements GoRouter {
  _FakeRouter(this.onGo);
  final void Function(String) onGo;
  @override
  void go(String location, {Object? extra}) {
    onGo(location);
  }
}

void main() {
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    FlutterLocalNotificationsPlatform.instance = _FakePlatform();
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('showNotification does not throw', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
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

  testWidgets('initialize does not throw', (tester) async {
    await tester.pumpWidget(Container());
    FirebaseNotificationService.initialize(
      tester.element(find.byType(Container)),
    );
    expect(true, isTrue);
  });

  test('notificationHandlerProvider handles opened message', () async {
    String? navigated;
    final container = ProviderContainer(overrides: [
      goRouterProvider.overrideWithValue(_FakeRouter((r) => navigated = r)),
    ]);
    container.read(notificationHandlerProvider);
    FirebaseMessagingPlatform.onMessageOpenedApp
        .add(const RemoteMessage(data: {'route': '/home'}));
    await Future<void>.delayed(Duration.zero);
    expect(navigated, '/home');
  });
}
