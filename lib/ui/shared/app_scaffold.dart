import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ScaffoldLayout extends StatelessWidget {
  final Widget body;
  final bool enableBottomNavBar;

  const ScaffoldLayout({
    Key? key,
    required this.body,
    this.enableBottomNavBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BondlyAppBar(),
      //TBD add endDrawer With the different routes.
      endDrawer: const Drawer(backgroundColor: AppColors.backgroundColor),
      body: body,
      bottomNavigationBar: enableBottomNavBar
          ? _buildBottomNavBar(getIt<HomeViewModel>())
          : null,
    );
  }

  Widget _buildBottomNavBar(HomeViewModel homeViewModel) {
    return BottomNavigationBar(
      currentIndex: homeViewModel.currentIndex,
      onTap: (index) {
        homeViewModel.onTabTapped(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          label: StringsHome.tabHome,
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.notification_bing),
          label: StringsHome.tabNews,
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.medal),
          label: StringsHome.tabBadges,
        ),
      ],
    );
  }
}
