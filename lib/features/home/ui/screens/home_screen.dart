import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/screens/ambassadors_tab.dart';
import 'package:bondly_app/features/home/ui/screens/tab_feed.dart';
import 'package:bondly_app/features/home/ui/screens/tab_recognize.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/notifications/ui/screens/notifications_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/profile_screen.dart';
import 'package:bondly_app/ui/shared/bondly_bottom_tab_bar.dart';
import 'package:bondly_app/ui/shared/bondly_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/homeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel model;

  @override
  void initState() {
    model = getIt<HomeViewModel>();
    model.setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return ModelProvider(
      model: model,
      child: ModelBuilder<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return GestureDetector(
            onTap: () {
              final f = FocusScope.of(context);
              if (!f.hasPrimaryFocus) f.unfocus();
            },
            child: Scaffold(
              backgroundColor: colors.bg,
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Header
                    BondlyHeader(
                      avatarUrl: model.user?.avatar,
                      onAvatarTap: () {
                        context.push(ProfileScreen.route).then(
                              (_) => model.setUp(),
                            );
                      },
                      onNotificationTap: () {
                        context.push(NotificationsScreen.route);
                      },
                    ),
                    // Body (PageView for tabs)
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: model.pageController,
                        onPageChanged: model.onPageChanged,
                        children: [
                          FeedTab(model: model),
                          RecognizeTab(model: model),
                          AmbassadorsTab(model: model),
                        ],
                      ),
                    ),
                    // Bottom Tab Bar (hidden on desktop — sidebar handles navigation)
                    if (MediaQuery.of(context).size.width <=
                        Constants.desktopBreakpoint)
                      BondlyBottomTabBar(
                        currentIndex: model.currentIndex,
                        onTap: model.onTabTapped,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
