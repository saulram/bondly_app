import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_app_bar.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class ScaffoldLayout extends StatelessWidget {
  final Widget body;
  final bool enableBottomNavBar;
  final String? avatar;
  final VoidCallback? afterProfileCall;

  const ScaffoldLayout(
      {Key? key,
      required this.body,
      this.enableBottomNavBar = false,
      this.avatar,
      this.afterProfileCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var f = FocusScope.of(context);

        if (!f.hasPrimaryFocus) {
          f.unfocus();
        }
      },
      child: Scaffold(
        appBar: BondlyAppBar(
          avatar,
          onExitProfileCallback: afterProfileCall,
        ),
        resizeToAvoidBottomInset: true,
        //TBD add endDrawer With the different routes.
        body: body,
        bottomNavigationBar: enableBottomNavBar
            ? _buildBottomNavBar(getIt<HomeViewModel>())
            : null,
      ),
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
          icon: Icon(IconsaxOutline.archive_book),
          label: StringsHome.tabFeed,
        ),
        BottomNavigationBarItem(
          icon: Icon(IconsaxOutline.add_square),
          label: StringsHome.tabRecognize,
        ),
        BottomNavigationBarItem(
          icon: Icon(IconsaxOutline.medal),
          label: StringsHome.tabBadges,
        ),
      ],
    );
  }
}
