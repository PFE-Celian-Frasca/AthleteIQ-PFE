import 'dart:convert';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/auth/auth_provider.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/user/user_provider.dart';
import 'package:athlete_iq/utils/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseMessagingService = Provider<FirebaseMessagingService>((ref) {
  return FirebaseMessagingService(ref);
});

class FirebaseMessagingService {
  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessagingService(this._ref) {
    _initializeNotifications();
    _requestPermission();
    _initMessaging();
    handleForegroundMessages();
  }

  void _initializeNotifications() async {
    var androidInitialize = const AndroidInitializationSettings('app_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _handleNotificationResponse,
    );
  }

  void _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      sound: true,
      provisional: false,
    );
    print('User permission status: ${settings.authorizationStatus}');
  }

  void _initMessaging() async {
    String? token = await _messaging.getToken();
    print('Firebase Messaging Token: $token');

    final currentUser = _ref.read(globalProvider.select((value) =>
        value.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));
    if (token != null && currentUser != null) {
      final updatedUser = currentUser.copyWith(fcmToken: token);
      print("updateUserWIthToken: $updatedUser");
      final isAuth = _ref.watch(authProvider).whenOrNull(
          authenticated: (User) => true, unauthenticated: () => false);
      if (isAuth != null && isAuth) {
        _ref.read(userProvider.notifier).updateUserProfile(updatedUser);
      }
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Background Notification Tapped");
        rootNavigatorKey.currentState
            ?.pushNamed('${message.data['click_action']}');
      }
    });
  }

  void handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.data}');
      if (message.notification != null) {
        _showNotification(message.notification!, message);
      }
    });
  }

  Future<void> _showNotification(
      RemoteNotification notification, RemoteMessage message) async {
    // Obtention de l'URL de l'image à partir des données du message, si elle existe
    String? imageUrl = message.data['image'];

    // Création des détails de notification pour Android
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      largeIcon: imageUrl != null ? FilePathAndroidBitmap(imageUrl) : null,
    );

    // Création des détails de notification pour iOS
    DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      threadIdentifier: 'channel_name',
      attachments:
          imageUrl != null ? [DarwinNotificationAttachment(imageUrl)] : null,
    );

    // Configuration de la notification pour iOS et Android
    NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // Affichage de la notification
    await _flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification.title, notification.body, platformDetails,
        payload: json.encode({
          'groupId': message.data[
              'groupId'] // Vous pouvez passer un payload supplémentaire si nécessaire
        }));
  }

  void _handleNotificationResponse(NotificationResponse response) async {
    if (response.payload != null) {
      Map<String, dynamic> data = json.decode(response.payload!);
      if (data.containsKey('click_action')) {
        rootNavigatorKey.currentState?.pushNamed('${data['click_action']}');
      }
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
