import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/activity_detail_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/monthly_balance_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_activity_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_badges_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_data_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_rewards_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/profile_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/shopping_cart_screen.dart';
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
          path: LoginScreen.route, builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: HomeScreen.route,
          builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: ProfileScreen.route,
          builder: (context, state) => const ProfileScreen()),
      GoRoute(
          path: MyActivityScreen.route,
          builder: (context, state) => const MyActivityScreen()),
      GoRoute(
        path: MyRewardsScreen.route,
        builder: (context, state) => const MyRewardsScreen(),
      ),
      GoRoute(
          path: MyCartScreen.route,
          builder: (context, state) => const MyCartScreen()),
      GoRoute(
          path: MonthlyBalanceScreen.route,
          builder: (context, state) => const MonthlyBalanceScreen()),
      GoRoute(
          path: MyBadgesScreen.route,
          builder: (context, state) => const MyBadgesScreen()),
      GoRoute(
          path: MyDataScreen.route,
          builder: (context, state) => const MyDataScreen()
      ),
      GoRoute(
          path: ActivityDetailScreen.route,
          builder: (context, state) {
            var params = state.extra as Map<String, dynamic>;
            return ActivityDetailScreen(
                activityId: params[ActivityDetailScreen.idParam] ?? "",
                feedId: params[ActivityDetailScreen.feedIdParam] ?? "",
                isRead: params[ActivityDetailScreen.readParam] ?? false);
          })
    ],
  );
}
