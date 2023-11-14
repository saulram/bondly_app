import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/bondly_badges_viewmodel.dart';
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
            child: SingleChildScrollView(
              child: viewModel.busy
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: size.height * .3,
                          child: GridView.builder(
                            itemCount: viewModel.bondlyBadges.embassys.count,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final embassy = viewModel
                                  .bondlyBadges.embassys.embassys[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      embassy.badgeId.image,
                                      height: 50,
                                      width: 50,
                                    ),
                                    Text(
                                      embassy.badgeId.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${embassy.quantity}"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: size.height * .3,
                          child: GridView.builder(
                            itemCount: viewModel.bondlyBadges.myBadges.count,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final myBadge = viewModel
                                  .bondlyBadges.myBadges.myBadges[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      myBadge.badgeId.image,
                                      height: 50,
                                      width: 50,
                                    ),
                                    Text(
                                      myBadge.badgeId.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${myBadge.quantity}"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: size.height * .3,
                          width: size.width,
                          child: ListView.builder(
                              itemCount:
                                  viewModel.bondlyBadges.categories.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    Text(viewModel
                                        .bondlyBadges.categories[i].name),
                                    SizedBox(
                                      height: 100,
                                      child: GridView.builder(
                                        itemCount: viewModel
                                            .bondlyBadges.myBadges.count,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemBuilder: (context, index) {
                                          final myBadge = viewModel.bondlyBadges
                                              .myBadges.myBadges[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  myBadge.badgeId.image,
                                                  height: 50,
                                                  width: 50,
                                                ),
                                                Text(
                                                  myBadge.badgeId.name,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text("${myBadge.quantity}"),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
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
