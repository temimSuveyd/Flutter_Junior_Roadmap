import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:juniorflutterroadmap/core/local/shared_prefs_locale_repository.dart';
import 'package:juniorflutterroadmap/core/routing/app_router.dart';
import 'package:juniorflutterroadmap/core/services/device_features/location_service.dart';
import 'package:juniorflutterroadmap/core/services/device_features/permission_service.dart';
import 'package:juniorflutterroadmap/core/storage/address_store.dart';
import 'package:juniorflutterroadmap/core/storage/auth_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/fcm_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/shared_preferences_address_store.dart';
import 'package:juniorflutterroadmap/core/storage/shared_preferences_user_profile_store.dart';
import 'package:juniorflutterroadmap/core/storage/shared_prefs_fcm_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_store.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:juniorflutterroadmap/features/auth/data/services/auth_service.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_hive_model.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:juniorflutterroadmap/features/products/data/services/local_product_services.dart';
import 'package:juniorflutterroadmap/features/profile/data/repositories/profile_repository.dart';
import 'package:juniorflutterroadmap/features/profile/data/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/products/data/services/remote_product_services.dart';
import '../services/auth/token_refresher.dart';
import '../services/device_features/image_picker_service.dart';
import '../services/network/dio_client.dart';

import '../services/notifications/firebase_initializer.dart';
import '../services/notifications/local_notification_service.dart';
import '../services/notifications/notification_service.dart';

final GetIt getIt = GetIt.instance;

/// Service locator that registers all dependencies.
Future<void> setupLocator() async {
  // 0. Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductHiveModelAdapter());
  final productBox = await Hive.openBox('products_cache');

  // 1. Firebase 
  getIt.registerLazySingleton<FirebaseInitializer>(() => FirebaseInitializer());

  // 2. FireBase Notification
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );
  getIt.registerLazySingleton<LocalNotificationService>(
    () => FlutterLocalNotificationsService(getIt<FlutterLocalNotificationsPlugin>()),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => FirebaseNotificationService(
      getIt<FcmTokenManager>(),
      getIt<LocalNotificationService>(),
    ),
  );

  // ── Storage ──
  getIt.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
  getIt.registerLazySingleton<FcmTokenManager>(
    () => SharedPrefsFcmTokenManager(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<AuthTokenManager>(
    () => SecureStorageTokenManager(getIt<FlutterSecureStorage>()),
  );

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton<UserProfileStore>(
    () => SharedPreferencesUserProfileStore(getIt<SharedPreferences>()),
  );

  // ── Token Refresh (independent, to break the DioClient cycle) ──
  getIt.registerLazySingleton<TokenRefresher>(() => const TokenRefresher());

  // ── Dio ──
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      getIt<AuthTokenManager>(),
      tokenManager: getIt<AuthTokenManager>(),
      refreshTokenProvider: () => getIt<TokenRefresher>(),
    ),
  );

  // ── Services ──
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<LocalProductServices>(
    () => LocalProductServicesImpl(productBox),
  );
  getIt.registerLazySingleton<RemoteProductServices>(
    () => RemoteProductServicesImpl(getIt<DioClient>()),
  );

  // Permission and image-picker services shared across features.
  getIt.registerLazySingleton<PermissionService>(() => PermissionServiceImpl());
  getIt.registerLazySingleton<ImagePickerService>(
    () => ImagePickerServiceImpl(getIt<PermissionService>()),
  );

  // Location + persistent address store.
  getIt.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(getIt<PermissionService>()),
  );
  getIt.registerLazySingleton<AddressStore>(
    () => SharedPreferencesAddressStore(getIt<SharedPreferences>()),
  );
  // ── Repositories ──
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthService>(),
      getIt<AuthTokenManager>(),
      getIt<UserProfileStore>(),
    ),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      getIt<LocalProductServices>(),
      getIt<RemoteProductServices>(),
    ),
  );
  getIt.registerLazySingleton<ProfileService>(
    () => ProfileServiceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getIt<ProfileService>(),
      getIt<UserProfileStore>(),
      getIt<ImagePickerService>(),
    ),
  );

  // ── Locale ──
  getIt.registerLazySingleton<LocaleRepository>(
    () => SharedPrefsLocaleRepository(getIt<SharedPreferences>()),
  );

  // ── Routing ──
  getIt.registerLazySingleton<GoRouter>(
    () => AppRouter.create(getIt<AuthTokenManager>()),
  );

}
