import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../storage/fcm_token_manager.dart';
import 'local_notification_service.dart';
import 'notification_payload.dart';

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
    final token = await _messaging.getToken();
    if (token != null) {
      await _fcmTokenManager.saveToken(token);
      if (kDebugMode) print('Device FCM Token (saved): $token');
    }

    // 3. Listen for token refreshes and save the new one.
    _messaging.onTokenRefresh.listen((String newToken) async {
      await _fcmTokenManager.saveToken(newToken);
      if (kDebugMode) print('FCM Token refreshed & saved: $newToken');
    });

    // 4. Foreground notifications: show locally (no system tray in foreground)
    //    and let the user tap to deep-link via setOnNotificationTapped.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      final title =
          notification?.title ?? message.data['title']?.toString() ?? '';
      final body = notification?.body ?? message.data['body']?.toString() ?? '';
      if (title.isEmpty && body.isEmpty) return;

      await _localNotifications.showNotification(
        title: title,
        body: body,
        data: message.data,
      );
    });

    // 5. Background tap: app was opened from the system tray notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateFromData(message.data);
    });

    // 6. Terminated (app fully closed) tap: the message that launched the app.
    //    getInitialMessage() returns the RemoteMessage only when the app was
    //    launched by a notification tap, so a normal open never navigates here.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateFromData(initialMessage.data);
    }
  }

  void _navigateFromData(Map<String, dynamic>? data) {
    if (_router == null || data == null) return;
    final payload = NotificationPayload.fromJson(data);
    if (payload.type != 'product' || payload.id == null) return;
    _router!.push(AppRoutes.productDetails, extra: payload.id);
  }
}
