import 'dart:convert';
import 'package:athlete_iq/utils/routing/app_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FirebaseNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );
  }

  static void showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }
}

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

final notificationHandlerProvider = Provider<void>((ref) {
  final goRouter = ref.read(goRouterProvider);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FirebaseNotificationService.showNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleMessage(message, goRouter);
  });
});

void _handleMessage(RemoteMessage message, GoRouter goRouter) {
  final data = message.data;
  if (data['route'] != null) {
    goRouter.go(data['route'] as String);
  }
}
