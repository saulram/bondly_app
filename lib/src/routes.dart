import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String startScreenRoute = "/";
  static const String loginScreenRoute = "${startScreenRoute}login";
  static const String homeScreenRoute = "${startScreenRoute}home";

  GoRouter get router => _router;
  // GoRouter configuration
  final _router = GoRouter(
    initialLocation: startScreenRoute,
    routes: <RouteBase>[
      GoRoute(
          path: startScreenRoute,
          builder: (context, state) =>  HomeScreen(),
          routes: [
            GoRoute(
              path: loginScreenRoute.replaceFirst(startScreenRoute, ""),
              builder: (context, state) => LoginScreen(
                getIt<LoginViewModel>()
              )
            ),
            GoRoute(
              path: "home",
              builder: (context, state) =>  HomeScreen()
            ),
          ]),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      var model = getIt<AppModel>();
      model.load();
      if (!model.loginState) {
        return loginScreenRoute;
      } else {
        return null;
      }
    },
  );
}
