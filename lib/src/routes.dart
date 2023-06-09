import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_view_model.dart';
import 'package:bondly_app/features/home/ui/home_screen.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter get router => _router;
  // GoRouter configuration
  final _router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              ),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => LoginScreen(
                getIt<LoginViewModel>()
              )
            ),
            GoRoute(
              path: 'home',
              builder: (context, state) => const HomeScreen()
            ),
          ]),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      if (getIt<AppModel>().loginState == false) {
        return '/login';
      } else {
        return null;
      }
    },
  );
}
