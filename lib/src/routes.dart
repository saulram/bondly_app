import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/home/ui/home_screen.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String startScreenRoute = "/";
const String loginScreenRoute = "${startScreenRoute}login";
const String homeScreenRoute = "${startScreenRoute}home";

class AppRouter {
  GoRouter get router => _router;
  // GoRouter configuration
  final _router = GoRouter(
    initialLocation: startScreenRoute,
    routes: <RouteBase>[
      GoRoute(
          path: startScreenRoute,
          builder: (context, state) => const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              ),
          routes: [
            GoRoute(
              path: loginScreenRoute.replaceFirst(startScreenRoute, ""),
              builder: (context, state) => LoginScreen(
                getIt<LoginViewModel>()
              )
            ),
            GoRoute(
              path: loginScreenRoute.replaceFirst(startScreenRoute, ""),
              builder: (context, state) => const HomeScreen()
            ),
          ]),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      var model = getIt<AppModel>();
      if (!model.loginState) {
        return loginScreenRoute;
      } else {
        return homeScreenRoute;
      }
    },
  );
}
