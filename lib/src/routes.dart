import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/domain/viewmodels/app_viewmodel.dart';
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
    redirect: (BuildContext context, GoRouterState state) {
      if (getIt<AppModel>().loginState == false) {
        return '/login';
      } else {
        return null;
      }
    },
  );
}
