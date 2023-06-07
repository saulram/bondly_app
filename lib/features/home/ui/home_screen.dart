import 'package:bondly_app/ui/shared/app_scaffold.dart';
import 'package:bondly_app/ui/shared/responsive.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        desktop: _buildDesktopLayout(), mobile: _buildMobileLayout());
  }

  //build Desktop Layout
  Widget _buildDesktopLayout() {
    return AppScaffold(
      isBusy: false,
      child: Center(
        child: TextButton(
          child: const Text('Esto es home Desktop, user auth'),
          onPressed: () => print("go to root"),
        ),
      ),
    );
  }

  //build Tablet Layout
  Widget _buildTabletLayout() {
    return AppScaffold.tabletLayout(
      isBusy: false,
      child: Center(
        child: TextButton(
          child: const Text('Esto es home Tablet, user auth'),
          onPressed: () => print("go to root"),
        ),
      ),
    );
  }

  //build Mobile Layout
  Widget _buildMobileLayout() {
    return AppScaffold.mobileLayout(
      isBusy: false,
      child: Center(
        child: TextButton(
          child: const Text('Esto es home Mobile, user auth'),
          onPressed: () => print("go to root"),
        ),
      ),
    );
  }
}
