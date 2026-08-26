import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/constants/app_constants.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/create_account_page.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:juniorflutterroadmap/features/products/presentation/pages/home_page.dart';
import 'package:juniorflutterroadmap/features/products/presentation/pages/product_details_page.dart';
import 'package:juniorflutterroadmap/features/profile/data/repositories/profile_repository.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/pages/profile_page.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/products/presentation/bloc/product_bloc/product_bloc.dart';
import '../../features/products/presentation/pages/main_shell.dart';
import '../../features/products/presentation/pages/search_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../di/injection.dart';
import '../storage/auth_token_manager.dart';

final class AppRouter {
  AppRouter._();

  static GoRouter create(AuthTokenManager secureStorage) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(getIt<AuthRepository>()),
            child: const SignInPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(getIt<AuthRepository>()),
            child: const CreateAccountPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: AppRoutes.productDetails,
          builder: (context, state) {
            final productId = state.extra is int ? state.extra as int : null;

            return BlocProvider(
              create: (_) => ProductDetailsBloc(
                getIt<ProductRepository>(),
                productId: productId,
              )..add(ProductDetailsRequested()),
              child: const ProductDetailsPage(),
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => BlocProvider(
                create: (context) =>
                    ProductBloc(getIt<ProductRepository>())
                      ..add(ProductsRequested()),
                child: const HomePage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => BlocProvider(
                create: (context) => ProfileBloc(getIt<ProfileRepository>()),
                child: const ProfilePage(),
              ),
            ),
          ],
        ),
      ],
      // redirect: (context, state) async {
      //   final token = await secureStorage.getAccessToken();
      //   final isAuthenticated = token != null;
      //   final isAuthRoute =
      //       state.matchedLocation == AppRoutes.signIn ||
      //       state.matchedLocation == AppRoutes.signup;

      //   if (!isAuthenticated && !isAuthRoute) {
      //     return AppRoutes.signIn;
      //   }
      //   if (isAuthenticated && isAuthRoute) {
      //     return AppRoutes.home;
      //   }
      //   return null;
      // },
    );
  }
}
