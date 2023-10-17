import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/screens/profile_screen.dart';
import 'package:bondly_app/features/start/ui/screens/start_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String startScreenRoute = "/";

  GoRouter get router => _router;
  // GoRouter configuration
  final _router = GoRouter(
    routes: [
      GoRoute(
          path: startScreenRoute,
          builder: (context, state) => StartScreen(
            model: getIt<AppModel>(),
          ),
      ),
      GoRoute(
          path: LoginScreen.route,
          builder: (context, state) => LoginScreen(
              getIt<LoginViewModel>()
          )
      ),
      GoRoute(
          path: HomeScreen.route,
          builder: (context, state) => const HomeScreen()
      ),
      GoRoute(
          path: ProfileScreen.route,
          builder: (context, state) => const ProfileScreen()
      )
    ],
  );
}
