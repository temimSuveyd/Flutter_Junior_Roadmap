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

  final notificationService = getIt<NotificationService>();
  notificationService.setRouter(getIt<GoRouter>());
  await notificationService.initializeNotificationPipeline();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  await initServices();
  runApp(const App());
}
