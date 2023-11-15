import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/bondly_badges_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/widgets/badges_grid.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:flutter/material.dart';

class MyBadgesScreen extends StatefulWidget {
  static const String route = "/myBadges";

  const MyBadgesScreen({super.key});

  @override
  State<MyBadgesScreen> createState() => _MyBadgesScreenState();
}

class _MyBadgesScreenState extends State<MyBadgesScreen> {
  late BondlyBadgesViewModel model;

  @override
  void initState() {
    model = getIt<BondlyBadgesViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ModelProvider<BondlyBadgesViewModel>(
      model: model,
      child: ModelBuilder<BondlyBadgesViewModel>(
        builder: (context, viewModel, child) {
          return BondlySliverLayout(
            title: "Mis Insignias",
            child: Column(
              children: [
                SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => viewModel.scrollController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          ),
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Embajadas",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => viewModel.scrollController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          ),
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Mis Insignias",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => viewModel.scrollController.animateToPage(
                            2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          ),
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Insignias Bondly",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 1,
                  child: PageView(
                    controller: viewModel.scrollController,
                    children: [
                      BadgesGrid(
                          size: size,
                          embassys: viewModel.bondlyBadges.embassys,
                          type: BadgeType.embassys),
                      BadgesGrid(
                        size: size,
                        myBadges: viewModel.bondlyBadges.myBadges,
                        type: BadgeType.myBadges,
                      ),
                      BadgesGrid(
                        size: size,
                        categories: viewModel.bondlyBadges.categories,
                        type: BadgeType.categories,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }
}
