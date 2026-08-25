import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/firebase_options.dart';

import '../../constants/app_constants.dart';
import '../../storage/fcm_token_manager.dart';
import 'local_notification_service.dart';
import 'notification_payload.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final local = FlutterLocalNotificationsService(FlutterLocalNotificationsPlugin());
  await local.initialize();

  final notification = message.notification;
  final title = notification?.title ?? message.data['title']?.toString() ?? '';
  final body = notification?.body ?? message.data['body']?.toString() ?? '';
  if (title.isEmpty && body.isEmpty) return;

  await local.showNotification(
    title: title,
    body: body,
    data: message.data,
  );
}

abstract class NotificationService {
  void setRouter(GoRouter router);
  Future<void> initializeNotificationPipeline();
}

class FirebaseNotificationService implements NotificationService {
  FirebaseNotificationService(this._fcmTokenManager, this._localNotifications);

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FcmTokenManager _fcmTokenManager;
  final LocalNotificationService _localNotifications;
  GoRouter? _router;

  @override
  void setRouter(GoRouter router) {
    _router = router;
  }

  @override
  Future<void> initializeNotificationPipeline() async {
    await _localNotifications.initialize();
    _localNotifications.setOnNotificationTapped(_navigateFromData);

    // 1. Request notification permission from the OS (especially iOS and Android 13+).
    await _messaging.requestPermission();

    // 2. Get the device's unique token (FCM) and save it locally.
    String? token = await _messaging.getToken();
    if (token != null) {
      await _fcmTokenManager.saveToken(token);
      if (kDebugMode) print('Device FCM Token (saved): $token');
    }

    // 3. Listen for token refreshes and save the new one.
    _messaging.onTokenRefresh.listen((String newToken) async {
      await _fcmTokenManager.saveToken(newToken);
      if (kDebugMode) print('FCM Token refreshed & saved: $newToken');
    });

    // 4. Register the BACKGROUND and OFF state listener.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 5. Listen for notifications while the app is open (foreground).
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      final title = notification?.title ?? message.data['title']?.toString() ?? '';
      final body = notification?.body ?? message.data['body']?.toString() ?? '';
      if (title.isEmpty && body.isEmpty) return;

      await _localNotifications.showNotification(
        title: title,
        body: body,
        data: message.data,
      );
    });

    // 6. Listen for notification taps while the app is in the background.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateFromData(message.data);
    });

    // 7. Check the open state via a notification tap when the app is fully closed.
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateFromData(initialMessage.data);
    }
  }

  void _navigateFromData(Map<String, dynamic>? data) {
    if (_router == null || data == null) return;

    final payload = NotificationPayload.fromJson(data);
    if (payload.type != 'product' || payload.id == null) return;

    _router!.go(
      AppRoutes.productDetails,
      extra: payload.id,
    );
  }
}
