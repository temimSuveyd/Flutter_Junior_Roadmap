import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LocalNotificationService {
  Future<void> initialize();
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
  void setOnNotificationTapped(void Function(Map<String, dynamic>? data) onTap);
}

class FlutterLocalNotificationsService implements LocalNotificationService {
  FlutterLocalNotificationsService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  void Function(Map<String, dynamic>? data)? _onTap;

  static const _channelId = 'high_importance_channel';
  static const _channelName = 'High Importance Notifications';

  @override
  void setOnNotificationTapped(
    void Function(Map<String, dynamic>? data) onTap,
  ) {
    _onTap = onTap;
  }

  @override
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            importance: Importance.high,
          ),
        );

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    _onTap?.call(_payloadToData(response.payload));
  }

  Map<String, dynamic>? _payloadToData(String? payload) {
    if (payload == null) return null;
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: data == null ? null : jsonEncode(data),
    );
  }
}
