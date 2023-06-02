import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/domain/viewmodels/app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter with ChangeNotifier {
  GoRouter get router => _router;

  // GoRouter configuration
  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              ),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => Scaffold(
                body: Center(
                  child: TextButton(
                    child: const Text('Esta es la pantalla de login'),
                    onPressed: () => print("go to login"),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'home',
              builder: (context, state) => Scaffold(
                body: Center(
                  child: TextButton(
                    child: const Text('Esto es home, user auth'),
                    onPressed: () => print("go to root"),
                  ),
                ),
              ),
            ),
          ]),
    ],
  );
}

enum AppRoutes { splash, login, home, error, onBoarding, root }

extension AppRoutesExtension on AppRoutes {
  String get toPath {
    switch (this) {
      case AppRoutes.home:
        return "/home";
      case AppRoutes.login:
        return "/login";
      case AppRoutes.splash:
        return "splash";
      case AppRoutes.error:
        return "error";
      case AppRoutes.onBoarding:
        return "start";
      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case AppRoutes.home:
        return "HOME";
      case AppRoutes.login:
        return "LOGIN";
      case AppRoutes.splash:
        return "SPLASH";
      case AppRoutes.error:
        return "ERROR";
      case AppRoutes.onBoarding:
        return "START";
      default:
        return "ROOT";
    }
  }

  String get toTitle {
    switch (this) {
      case AppRoutes.home:
        return "My App";
      case AppRoutes.login:
        return "My App Log In";
      case AppRoutes.splash:
        return "My App Splash";
      case AppRoutes.error:
        return "My App Error";
      case AppRoutes.onBoarding:
        return "Welcome to My App";
      default:
        return "My App";
    }
  }
}
