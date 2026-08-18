import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/routing/app_router.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:juniorflutterroadmap/features/auth/data/services/auth_service.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/bloc/auth_bloc.dart';

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

  // ── Services ──
  getIt.registerLazySingleton<AuthService>(AuthServiceImpl.new);

  // ── Repositories ──
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthService>(),
      getIt<SecureStorage>(),
    ),
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
}
