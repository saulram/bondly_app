import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/single_post_widget.dart';
import 'package:bondly_app/ui/shared/app_body_layout.dart';
import 'package:bondly_app/ui/shared/app_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel model;

  @override
  void initState() {
    model = getIt<HomeViewModel>();
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
        SingleChildScrollView(
          child: Column(
            children: [
              //TBD IMPLEMENT API CALLS AND MAKE THIS DYNAMIC.

              SinglePostWidget(
                post: FeedPost(
                    image:
                        "https://api.bondly.mx/public/upload/1693518208339.jpg"),
              ),
              SinglePostWidget(
                post: FeedPost(),
              )
            ],
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
