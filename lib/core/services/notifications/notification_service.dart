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

    // 1. Request notification permission (iOS + Android 13+).
    await _messaging.requestPermission();

    // 2. Get FCM token with timeout.
    //    On iOS, getToken() waits for APNS internally — we add a safety
    //    timeout so the app never blocks indefinitely (e.g. simulator).
    await _fetchTokenWithTimeout();

    // 3. Listen for token refreshes and save the new one.
    _messaging.onTokenRefresh.listen((String newToken) async {
      await _fcmTokenManager.saveToken(newToken);
      if (kDebugMode) print('FCM Token refreshed & saved: $newToken');
    });

    // 4. Foreground notifications: show locally (no system tray in foreground)
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
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateFromData(initialMessage.data);
    }
  }

  /// Fetches FCM token with a timeout so the app never blocks.
  /// On iOS, [getToken] internally waits for the APNS token to arrive;
  /// the timeout guards against simulator / rare edge cases.
  Future<void> _fetchTokenWithTimeout() async {
    try {
      final token = await _messaging
          .getToken()
          .timeout(const Duration(seconds: 5));
      if (token != null) {
        await _fcmTokenManager.saveToken(token);
        if (kDebugMode) print('Device FCM Token (saved): $token');
      }
    } catch (e) {
      if (kDebugMode) print('FCM token fetch failed: $e');
    }
  }

  void _navigateFromData(Map<String, dynamic>? data) {
    if (_router == null || data == null) return;
    final payload = NotificationPayload.fromJson(data);
    if (payload.type != 'product' || payload.id == null) return;
    _router!.push(AppRoutes.productDetails, extra: payload.id);
  }
}
