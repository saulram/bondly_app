import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/screens/profile_screen.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:bondly_app/features/ranking/ui/screens/ranking_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_rewards_screen.dart';
import 'package:bondly_app/ui/shared/bondly_side_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopShell extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const DesktopShell({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  int _computeSelectedIndex(int homeTabIndex) {
    if (currentRoute == HomeScreen.route) {
      if (homeTabIndex == 0) return 2; // Feed
      if (homeTabIndex == 2) return 5; // Embajadas
      return 0; // Inicio (tab 1)
    }
    if (currentRoute == ProfileScreen.route) return 1;
    if (currentRoute == RankingScreen.route) return 3;
    if (currentRoute == MyRewardsScreen.route) return 4;
    return -1;
  }

  void _onNavTap(BuildContext context, int index) {
    final homeVM = getIt<HomeViewModel>();
    switch (index) {
      case 0: // Inicio → HomeScreen tab 1 (Reconocer)
        context.go(HomeScreen.route);
        homeVM.jumpToTab(1);
      case 1: // Mi Perfil
        context.go(ProfileScreen.route);
      case 2: // Feed → HomeScreen tab 0
        context.go(HomeScreen.route);
        homeVM.jumpToTab(0);
      case 3: // Ranking
        context.go(RankingScreen.route);
      case 4: // Recompensas
        context.go(MyRewardsScreen.route);
      case 5: // Embajadas → HomeScreen tab 2
        context.go(HomeScreen.route);
        homeVM.jumpToTab(2);
    }
  }

  void _onLogout(BuildContext context) {
    getIt<ProfileViewModel>().closeSession();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= Constants.desktopBreakpoint) {
          return child;
        }
        final homeVM = getIt<HomeViewModel>();
        return ListenableBuilder(
          listenable: homeVM,
          builder: (context, _) {
            final selectedIndex = _computeSelectedIndex(homeVM.currentIndex);
            return Row(
              children: [
                BondlySideNav(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _onNavTap(context, index),
                  onLogout: () => _onLogout(context),
                ),
                Expanded(child: child),
              ],
            );
          },
        );
      },
    );
  }
}
