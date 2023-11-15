import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/widgets/gold_bordered_container.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/bondly_badges_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/widgets/badges_grid.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:ficonsax/ficonsax.dart';
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
            title: "Insignias",
            child: Column(
              children: [
                _buildHeaderCard(Theme.of(context)),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tabSwitcher(
                        () => viewModel.scrollController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                        "Embajadas"),
                    _tabSwitcher(
                        () => viewModel.scrollController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                        "Mis Insignias"),
                    _tabSwitcher(
                        () => viewModel.scrollController.animateToPage(2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                        "Insignias"),
                  ],
                )),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  flex: 1,
                  child: viewModel.busy
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : PageView(
                          controller: viewModel.scrollController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GoldBorderedContainer(
                                child: BadgesGrid(
                                    size: size,
                                    embassys: viewModel.bondlyBadges.embassys,
                                    type: BadgeType.embassys),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GoldBorderedContainer(
                                child: BadgesGrid(
                                  size: size,
                                  myBadges: viewModel.bondlyBadges.myBadges,
                                  type: BadgeType.myBadges,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GoldBorderedContainer(
                                child: BadgesGrid(
                                  size: size,
                                  categories: viewModel.bondlyBadges.categories,
                                  type: BadgeType.categories,
                                ),
                              ),
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

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryColor,
              theme.primaryColor,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Insignas Bondly",
            style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12.0),
          Text(
            StringsProfile.bondlyBadgesSubHeader,
            style: theme.textTheme.labelLarge!
                .copyWith(height: 1.4, fontSize: 16.0, color: Colors.white),
          )
        ],
      ),
    );
  }

  GestureDetector _tabSwitcher(VoidCallback onTap, String label) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Chip(
        elevation: 1,
        avatar: Icon(IconsaxOutline.award,
            color: Theme.of(context).scaffoldBackgroundColor),
        label: Text(label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).scaffoldBackgroundColor,
                )),
      ),
    );
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }
}
