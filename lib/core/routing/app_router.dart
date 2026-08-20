import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/constants/app_constants.dart';

import 'package:juniorflutterroadmap/features/auth/presentation/pages/create_account_page.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/pages/profile_page.dart';
import 'package:juniorflutterroadmap/features/products/presentation/pages/home_page.dart';
import 'package:juniorflutterroadmap/features/products/presentation/pages/main_shell.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';
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
            create: (context) => getIt<AuthBloc>(),
            child: const SignInPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const CreateAccountPage(),
          ),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => BlocProvider(
                    create: (context) => getIt<ProductBloc>()..add(ProductsRequested()),
                child: const HomePage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<ProfileBloc>(),
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
