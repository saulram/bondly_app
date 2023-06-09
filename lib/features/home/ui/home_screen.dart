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
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Esto es home Desktop, user auth'),
          onPressed: () => print("go to root"),
        ),
      ),
    );
  }

  //build Tablet Layout
  Widget _buildTabletLayout() {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Esto es home Tablet, user auth'),
          onPressed: () => print("go to root"),
        ),
      ),
    );
  }

  //build Mobile Layout
  Widget _buildMobileLayout() {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Esto es home Mobile, user auth'),
          onPressed: () => print("go to root"),
        ),
      ),
    );
  }
}
