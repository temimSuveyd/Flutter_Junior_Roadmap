import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/constants/app_constants.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/create_account_page.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/home_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/main_shell.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../di/injection.dart';

final class AppRouter {
  AppRouter._();

  static GoRouter create(SecureStorage secureStorage) {
    return GoRouter(
      initialLocation: AppRoutes.signIn,
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
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
      ],
      // redirect: (context, state) async {
      //   final token = await secureStorage.getToken();
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
