import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/di/injection.dart';
import 'package:juniorflutterroadmap/core/services/notifications/notification_service.dart';
import 'package:juniorflutterroadmap/core/storage/auth_token_manager.dart';
import 'package:juniorflutterroadmap/firebase_options.dart';
import 'app.dart';
import 'flavors.dart';

Future<void> initServices() async {
  await setupLocator();
  await getIt<AuthTokenManager>().load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

/// Fire-and-forget: notification pipeline runs after the app is visible
/// so any APNS delay on iOS never blocks the UI.
void initNotifications() {
  final notificationService = getIt<NotificationService>();
  notificationService.setRouter(getIt<GoRouter>());
  notificationService.initializeNotificationPipeline().catchError((e) {
    // Non-fatal: app works without push notifications.
    debugPrint('Notification init failed: $e');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final flavorName = appFlavor;
  F.appFlavor = flavorName != null
      ? Flavor.values.firstWhere(
          (element) => element.name == flavorName,
          orElse: () => Flavor.dev,
        )
      : Flavor.dev;

  await initServices();
  runApp(const App());
  initNotifications();
}
