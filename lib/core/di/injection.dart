import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/local/cubit/local_cubit.dart';
import 'package:juniorflutterroadmap/core/local/shared_prefs_locale_repository.dart';
import 'package:juniorflutterroadmap/core/routing/app_router.dart';
import 'package:juniorflutterroadmap/core/storage/auth_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/fcm_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/shared_preferences_user_profile_store.dart';
import 'package:juniorflutterroadmap/core/storage/shared_prefs_fcm_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_store.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:juniorflutterroadmap/features/auth/data/services/auth_service.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:juniorflutterroadmap/features/data/service/local/image_picker_service.dart';
import 'package:juniorflutterroadmap/features/data/service/local/permission_service.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:juniorflutterroadmap/features/products/data/services/local_product_services.dart';
import 'package:juniorflutterroadmap/features/profile/data/repositories/profile_repository.dart';
import 'package:juniorflutterroadmap/features/profile/data/services/profile_service.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/products/data/services/remote_product_services.dart';
import '../../features/products/presentation/bloc/product_bloc/product_bloc.dart';
import '../services/auth/token_refresher.dart';
import '../services/network/dio_client.dart';
import '../services/notifications/firebase_initializer.dart';
import '../services/notifications/notification_service.dart';

final GetIt getIt = GetIt.instance;

/// Tüm bağımlılıkları kaydeden servis locator.
Future<void> setupLocator() async {
  // 1. Firebase 
  getIt.registerLazySingleton<FirebaseInitializer>(() => FirebaseInitializer());

  // 2. FireBase Notification
  getIt.registerLazySingleton<NotificationService>(
    () => FirebaseNotificationService(getIt<FcmTokenManager>()),
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

  // ── Token Refresh (DioClient döngüsünü kırmak için bağımsız) ──
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
    () => LocalProductServicesImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<RemoteProductServices>(
    () => RemoteProductServicesImpl(getIt<DioClient>()),
  );

  // خدمات الأذونات واختيار الصور المشتركة بين الميزات.
  getIt.registerLazySingleton<PermissionService>(() => PermissionServiceImpl());
  getIt.registerLazySingleton<ImagePickerService>(
    () => ImagePickerServiceImpl(getIt<PermissionService>()),
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

  // ── Blocs / Cubits ──
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory<ThemeCubit>(
    () => ThemeCubit(getIt<SharedPreferences>()),
  );
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getIt<ProductRepository>()),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<LocaleCubit>(
    () => LocaleCubit(getIt<LocaleRepository>()),
  );
}
