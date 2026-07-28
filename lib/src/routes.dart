import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_ambassadors_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_badges_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_banners_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_dashboard_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_exchanges_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_news_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_permissions_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_reports_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_rewards_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_settings_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_shell_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_users_screen.dart';
import 'package:bondly_app/features/admin/ui/screens/admin_zones_screen.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/auth/ui/screens/forgot_password_screen.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/auth/ui/screens/reset_password_confirmation_screen.dart';
import 'package:bondly_app/features/auth/ui/screens/reset_password_screen.dart';
import 'package:bondly_app/features/auth/ui/screens/verify_reset_token_screen.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/notifications/ui/screens/notifications_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/activity_detail_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/monthly_balance_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_activity_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_badges_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_data_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_rewards_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/profile_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/shopping_cart_screen.dart';
import 'package:bondly_app/features/ranking/ui/screens/ranking_screen.dart';
import 'package:bondly_app/features/start/ui/screens/start_screen.dart';
import 'package:bondly_app/ui/shared/desktop_shell.dart';
import 'package:go_router/go_router.dart';

List<String> _adminBreadcrumbs(String path) {
  if (path == '/admin') return [];
  if (path.startsWith('/admin/users')) return ['Usuarios'];
  if (path.startsWith('/admin/badges')) return ['Insignias'];
  if (path.startsWith('/admin/rewards')) return ['Recompensas'];
  if (path.startsWith('/admin/exchanges')) return ['Canjes'];
  if (path.startsWith('/admin/banners')) return ['Banners'];
  if (path.startsWith('/admin/news')) return ['Noticias'];
  if (path.startsWith('/admin/ambassadors')) return ['Embajadores'];
  if (path.startsWith('/admin/reports')) return ['Reportes'];
  if (path == '/admin/settings/zones') return ['Configuración', 'Zonas'];
  if (path == '/admin/settings/permissions') {
    return ['Configuración', 'Permisos'];
  }
  if (path.startsWith('/admin/settings')) return ['Configuración'];
  return [];
}

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
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: ForgotPasswordScreen.route,
          builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
          path: VerifyResetTokenScreen.route,
          builder: (context, state) {
            var params = state.extra as Map<String, dynamic>? ?? {};
            return VerifyResetTokenScreen(
                email: params[VerifyResetTokenScreen.emailParam] ?? "");
          }),
      GoRoute(
          path: ResetPasswordScreen.route,
          builder: (context, state) {
            var params = state.extra as Map<String, dynamic>? ?? {};
            return ResetPasswordScreen(
                token: params[ResetPasswordScreen.tokenParam] ?? "");
          }),
      GoRoute(
          path: ResetPasswordConfirmationScreen.route,
          builder: (context, state) =>
              const ResetPasswordConfirmationScreen()),
      // Admin panel shell — guarded: only admin/superAdmin
      ShellRoute(
        redirect: (context, state) {
          final user = getIt<HomeViewModel>().user;
          if (user == null || !user.isAdmin) {
            return HomeScreen.route;
          }
          return null;
        },
        builder: (context, state, child) => AdminShellScreen(
          breadcrumbs: _adminBreadcrumbs(state.uri.path),
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/admin',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: AdminUsersScreen.route,
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: AdminBadgesScreen.route,
            builder: (context, state) => const AdminBadgesScreen(),
          ),
          GoRoute(
            path: AdminRewardsScreen.route,
            builder: (context, state) => const AdminRewardsScreen(),
          ),
          GoRoute(
            path: AdminExchangesScreen.route,
            builder: (context, state) => const AdminExchangesScreen(),
          ),
          GoRoute(
            path: AdminBannersScreen.route,
            builder: (context, state) => const AdminBannersScreen(),
          ),
          GoRoute(
            path: AdminNewsScreen.route,
            builder: (context, state) => const AdminNewsScreen(),
          ),
          GoRoute(
            path: AdminAmbassadorsScreen.route,
            builder: (context, state) => const AdminAmbassadorsScreen(),
          ),
          GoRoute(
            path: AdminReportsScreen.route,
            builder: (context, state) => const AdminReportsScreen(),
          ),
          GoRoute(
            path: AdminSettingsScreen.route,
            builder: (context, state) => const AdminSettingsScreen(),
          ),
          GoRoute(
            path: AdminZonesScreen.route,
            builder: (context, state) => const AdminZonesScreen(),
          ),
          GoRoute(
            path: AdminPermissionsScreen.route,
            builder: (context, state) => const AdminPermissionsScreen(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => DesktopShell(
          currentRoute: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
              path: HomeScreen.route,
              builder: (context, state) => const HomeScreen()),
          GoRoute(
              path: ProfileScreen.route,
              builder: (context, state) => const ProfileScreen()),
          GoRoute(
              path: NotificationsScreen.route,
              builder: (context, state) => const NotificationsScreen()),
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
              path: RankingScreen.route,
              builder: (context, state) => const RankingScreen()),
          GoRoute(
              path: MyDataScreen.route,
              builder: (context, state) => const MyDataScreen()),
          GoRoute(
              path: ActivityDetailScreen.route,
              builder: (context, state) {
                var params = state.extra as Map<String, dynamic>;
                return ActivityDetailScreen(
                    activityId: params[ActivityDetailScreen.idParam] ?? "",
                    feedId: params[ActivityDetailScreen.feedIdParam] ?? "",
                    isRead: params[ActivityDetailScreen.readParam] ?? false);
              }),
        ],
      ),
    ],
  );
}
