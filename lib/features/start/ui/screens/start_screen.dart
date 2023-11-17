import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  final AppModel model = getIt<AppModel>();
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";

  StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    model.load();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset(
            context.isDarkMode
              ? _logoDarkImagePath
              : _logoImagePath
          ),
        ),
      ),
    );
  }
}