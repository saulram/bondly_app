import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/single_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {

   HomeScreen({Key? key}) : super(key: key);

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
    return ModelProvider(model: model,
      child: ModelBuilder<HomeViewModel>(
        builder: (context, homeViewModel, child) {
      return Scaffold(
        appBar: AppBar(

        ),
        body: _buildBody(homeViewModel),
        bottomNavigationBar:_buildBottomNavBar(homeViewModel),
      );
    },
      ),
    );
  }
 Widget _buildBody(HomeViewModel homeViewModel) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 12/6,
          child: Container(
            color: Colors.red,
            child: Text("This is the space for banners"),
          ),
        ),
        Expanded(
          child:PageView(
            controller: homeViewModel.pageController,
            onPageChanged: (index){
              homeViewModel.onPageChanged(index);
            },
            children: [
              SinglePostWidget(),
              Container(color: Colors.green,),
              Container(color: Colors.yellow,),
            ],
          )
        )
      ],
    );
  }

 Widget _buildBottomNavBar(HomeViewModel homeViewModel){
    return BottomNavigationBar(
      currentIndex: homeViewModel.currentIndex,
      onTap: (index){
        homeViewModel.onTabTapped(index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.home), label: StringsHome.tabHome),
        BottomNavigationBarItem(icon: Icon(Iconsax.notification_bing), label: StringsHome.tabNews),
        BottomNavigationBarItem(icon: Icon(Iconsax.medal), label: StringsHome.tabBadges),
      ],
    );
  }
}
