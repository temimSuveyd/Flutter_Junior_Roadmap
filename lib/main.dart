import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/di/injection.dart';
import 'package:juniorflutterroadmap/core/l10n/app_localizations.dart';
import 'package:juniorflutterroadmap/core/local/cubit/local_cubit.dart';
import 'package:juniorflutterroadmap/core/local/shared_prefs_locale_repository.dart';
import 'package:juniorflutterroadmap/core/services/device_features/location_service.dart';
import 'package:juniorflutterroadmap/core/services/notifications/notification_service.dart';
import 'package:juniorflutterroadmap/core/storage/address_store.dart';
import 'package:juniorflutterroadmap/core/theme/app_theme.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import 'package:juniorflutterroadmap/features/address/presentation/cubit/address_cubit.dart';
import 'package:juniorflutterroadmap/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // After Firebase starts, create NotificationService and connect the router,
  // then start the FCM pipeline (request permission, get/save token, listen).
  final notificationService = getIt<NotificationService>();
  notificationService.setRouter(getIt<GoRouter>());
  await notificationService.initializeNotificationPipeline();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(getIt<SharedPreferences>())),
        BlocProvider(create: (_) => LocaleCubit(getIt<LocaleRepository>())),
        BlocProvider(
          create: (_) => AddressCubit(
            getIt<LocationService>(),
            getIt<AddressStore>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final locale = context.watch<LocaleCubit>().state.locale;
          return MaterialApp.router(
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
            themeMode: themeMode,
            locale: locale,
            title: 'E commerce',
            routerConfig: getIt<GoRouter>(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
