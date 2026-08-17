import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/constants/app_constants.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/create_account_page.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/home_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/main_shell.dart';

/// Uygulama geneli go_router yapılandırması.
///
/// Route tanımları, auth guard ve ShellRoute burada merkezileştirilir.
/// Roadmap Day 9: Route, Redirect, Authentication Guard, ShellRoute.
final class AppRouter {
  AppRouter._();

  static GoRouter create(SecureStorage secureStorage) {
    return GoRouter(
      initialLocation: AppRoutes.signIn,
      routes: [
        GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const CreateAccountPage(),
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
      redirect: (context, state) async {
        final token = await secureStorage.getToken();
        final isAuthenticated = token != null;
        final isAuthRoute =
            state.matchedLocation == AppRoutes.signIn ||
            state.matchedLocation == AppRoutes.signup;

        if (!isAuthenticated && !isAuthRoute) {
          return AppRoutes.signIn;
        }
        if (isAuthenticated && isAuthRoute) {
          return AppRoutes.home;
        }
        return null;
      },
    );
  }
}
