import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/single_post_widget.dart';
import 'package:bondly_app/ui/shared/app_body_layout.dart';
import 'package:bondly_app/ui/shared/app_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/homeScreen";

  const HomeScreen({Key? key}) : super(key: key);

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
    return ModelProvider(
      model: model,
      child: ModelBuilder<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return ScaffoldLayout(
            body: BodyLayout(
              enableBanners: true,
              child: _buildBody(),
            ),
            enableBottomNavBar: true,
            avatar: model.user?.avatar,
            afterProfileCall: model.setUp,
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return PageView(
      controller: model.pageController,
      onPageChanged: (index) {
        model.onPageChanged(index);
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator.adaptive(
            onRefresh: model.getCompanyFeeds,
            child: ListView.builder(
              itemCount: model.feeds.data.length,
              itemBuilder: (context, index) {
                return SinglePostWidget(
                  post: model.feeds.data[index],
                  index: index,
                );
              },
            ),
          ),
        ),
        Container(
          color: Colors.green,
        ),
        Container(
          color: Colors.yellow,
        ),
      ],
    );
  }
}
