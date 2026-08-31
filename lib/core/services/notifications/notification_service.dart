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

    // 2. On iOS, APNS token must be available before getToken() can succeed.
    //    Wait up to ~3s with retries (each getAPNSToken call is itself guarded).
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      for (var i = 0; i < 15; i++) {
        try {
          final apnsToken = await _messaging.getAPNSToken();
          if (apnsToken != null) break;
        } catch (_) {
          // APNS token not yet ready — continue waiting.
        }
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }

    // 3. Get the device's unique token (FCM) and save it locally.
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _fcmTokenManager.saveToken(token);
        if (kDebugMode) print('Device FCM Token (saved): $token');
      }
    } catch (e) {
      if (kDebugMode) print('Failed to get FCM token: $e');
    }

    // 4. Listen for token refreshes and save the new one.
    _messaging.onTokenRefresh.listen((String newToken) async {
      await _fcmTokenManager.saveToken(newToken);
      if (kDebugMode) print('FCM Token refreshed & saved: $newToken');
    });

    // 5. Foreground notifications: show locally (no system tray in foreground)
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

    // 6. Background tap: app was opened from the system tray notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateFromData(message.data);
    });

    // 7. Terminated (app fully closed) tap: the message that launched the app.
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
