import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/routing/app_router.dart';
import 'package:juniorflutterroadmap/core/services/network/dio_clint.dart';
import 'package:juniorflutterroadmap/core/storage/auth_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage_token_manager.dart';
import 'package:juniorflutterroadmap/core/storage/shared_preferences_user_profile_store.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_store.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:juniorflutterroadmap/features/auth/data/services/auth_service.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:juniorflutterroadmap/features/profile/data/repositories/profile_repository.dart';
import 'package:juniorflutterroadmap/features/profile/data/services/profile_service.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:juniorflutterroadmap/features/products/data/services/local_product_services.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/products/data/services/remote_product_services.dart';

final GetIt getIt = GetIt.instance;

/// Tüm bağımlılıkları kaydeden servis locator.
Future<void> setupLocator() async {
  // ── Storage ──
  getIt.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);

  getIt.registerLazySingleton<AuthTokenManager>(
    () => SecureStorageTokenManager(getIt<FlutterSecureStorage>()),
  );

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton<UserProfileStore>(
    () => SharedPreferencesUserProfileStore(getIt<SharedPreferences>()),
  );

  // ── Dio ──
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      getIt<AuthTokenManager>(),
      tokenManager: getIt<AuthTokenManager>(),
      refreshTokenProvider: () => getIt<AuthService>(),
    ),
  );

  // ── Services ──
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<LocalProductServices>(
    () => LocalProductServicesImpl(
      // getIt<DioClient>(),
      getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<RemoteProductServices>(
    () => RemoteProductServicesImpl(getIt<DioClient>()),
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
    ),
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
}
