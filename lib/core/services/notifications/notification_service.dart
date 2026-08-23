import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../storage/fcm_token_manager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("تم القبض على الإخطار في الخلفية: ${message.messageId}");
  }
}

class NotificationService {
  NotificationService(this._fcmTokenManager);

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FcmTokenManager _fcmTokenManager;
  GoRouter? _router;

  void setRouter(GoRouter router) {
    _router = router;
  }

  Future<void> initializeNotificationPipeline() async {
    // 1. طلب ​​إذن الإشعارات من نظام التشغيل (خاصة iOS وAndroid 13+)
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2. احصل على العنوان الفريد للجهاز (رمز FCM) واحفظه محليًا
    String? token = await _messaging.getToken();
    if (token != null) {
      await _fcmTokenManager.saveToken(token);
      if (kDebugMode) print("Device FCM Token (saved): $token");
    }

    // 3. استمع إلى تحديثات الرمز المميز واحفظ الجديد
    _messaging.onTokenRefresh.listen((String newToken) async {
      await _fcmTokenManager.saveToken(newToken);
      if (kDebugMode) print("FCM Token refreshed & saved: $newToken");
    });

    // 4. سجل المستمع BACKGROUND و OFF STATE
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 5. استمع إلى الإشعارات عندما يكون التطبيق مفتوحًا (المقدمة)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) log("app open: ${message.notification?.title}");

      ///TODO: show snack bar or any action
    });

    // 6. استمع إلى نقرات الإشعارات أثناء وجود التطبيق في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleDeepLinkNavigation(message);
    });

    // 7. تحقق من حالة الافتتاح من خلال النقر على الإشعار عندما يكون التطبيق مغلقًا تمامًا
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleDeepLinkNavigation(initialMessage);
    }
  }

  void _handleDeepLinkNavigation(RemoteMessage message) {
    Map<String, dynamic> data = message.data;

    if (data.containsKey('sayfa') && _router != null) {
      String targetPage = data['sayfa'] as String;

      if (targetPage == 'profil') {
        _router!.go(AppRoutes.profile);
      }
    }
  }
}
