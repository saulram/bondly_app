import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/monthly_balance_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_activity_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_rewards_screen.dart';
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
          builder: (context, state) => StartScreen(),
      ),
      GoRoute(
          path: LoginScreen.route,
          builder: (context, state) => LoginScreen()
      ),
      GoRoute(
          path: HomeScreen.route,
          builder: (context, state) => const HomeScreen()
      ),
      GoRoute(
          path: ProfileScreen.route,
          builder: (context, state) => ProfileScreen()
      ),
      GoRoute(
          path: MyActivityScreen.route,
          builder: (context, state) => MyActivityScreen()
      ),
      GoRoute(
          path: MyRewardsScreen.route,
          builder: (context, state) => const MyRewardsScreen()
      ),
      GoRoute(
          path: MonthlyBalanceScreen.route,
          builder: (context, state) => const MonthlyBalanceScreen()
      )
    ],
  );
}
