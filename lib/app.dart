import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/di/injection.dart';
import 'package:juniorflutterroadmap/core/l10n/app_localizations.dart';
import 'package:juniorflutterroadmap/core/local/cubit/local_cubit.dart';
import 'package:juniorflutterroadmap/core/local/shared_prefs_locale_repository.dart';
import 'package:juniorflutterroadmap/core/services/device_features/location_service.dart';
import 'package:juniorflutterroadmap/core/storage/address_store.dart';
import 'package:juniorflutterroadmap/core/theme/app_theme.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import 'package:juniorflutterroadmap/features/address/presentation/cubit/address_cubit.dart';
import 'package:juniorflutterroadmap/features/cart/data/repositories/cart_repository.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/favorites/data/repositories/favorite_repository.dart';
import 'package:juniorflutterroadmap/features/favorites/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flavors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(getIt<SharedPreferences>())),
        BlocProvider(create: (_) => LocaleCubit(getIt<LocaleRepository>())),
        BlocProvider(
          create: (_) =>
              AddressCubit(getIt<LocationService>(), getIt<AddressStore>()),
        ),
        BlocProvider(
          create: (_) =>
              FavoriteBloc(getIt<FavoriteRepository>())
                ..add(FavoritesLoaded()),
        ),
        BlocProvider(
          create: (_) =>
              CartBloc(getIt<CartRepository>())
                ..add(CartItemsLoaded()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final locale = context.watch<LocaleCubit>().state.locale;
          return MaterialApp.router(
            title: F.title,
            debugShowCheckedModeBanner: false,
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
            themeMode: themeMode,
            locale: locale,
            routerConfig: getIt<GoRouter>(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) {
              return _flavorBanner(
                child: child ?? const SizedBox.shrink(),
                show: F.appFlavor != Flavor.production,
              );
            },
          );
        },
      ),
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => show
      ? Banner(
          location: BannerLocation.topStart,
          message: F.name,
          color: Colors.green.withAlpha(150),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          textDirection: TextDirection.ltr,
          child: child,
        )
      : Container(child: child);
}
