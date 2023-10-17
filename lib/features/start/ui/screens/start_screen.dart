import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:flutter/cupertino.dart';

class StartScreen extends StatelessWidget {
  final AppModel model;
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";

  const StartScreen(
    {super.key, required this.model}
  );


  @override
  Widget build(BuildContext context) {
    model.load();

    return Center(
      child: Image.asset(
        context.isDarkMode
          ? _logoDarkImagePath
          : _logoImagePath
      ),
    );
  }
}