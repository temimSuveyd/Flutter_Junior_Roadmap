import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/routing/app_router.dart';
import 'package:juniorflutterroadmap/core/services/network/dio_clint.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:juniorflutterroadmap/features/auth/data/services/auth_service.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:juniorflutterroadmap/features/products/data/services/product_services.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Tüm bağımlılıkları kaydeden servis locator.
Future<void> setupLocator() async {

  // ── Storage ──
  getIt.registerLazySingleton<FlutterSecureStorage>(
    FlutterSecureStorage.new,
  );
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorageImpl(getIt<FlutterSecureStorage>()),
  );

  // ── Dio ──
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<SecureStorage>()),
  );

  // ── Services ──
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ProductServices>(
    () => ProductServicesImpl(getIt<DioClient>()),
  );

  // ── Repositories ──
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthService>(),
      getIt<SecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductServices>()),
  );

  // ── Routing ──
  getIt.registerLazySingleton<GoRouter>(
    () => AppRouter.create(getIt<SecureStorage>()),
  );

  // ── Blocs / Cubits ──
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>()),
  );
  getIt.registerFactory<ThemeCubit>(ThemeCubit.new);
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getIt<ProductRepository>()),
  );
}
