import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';

class AppServices {
  void showSnackbar(GlobalKey<ScaffoldState> scaffoldKey, String msg) {
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 5000),
        showCloseIcon: true,
        closeIconColor: AppColors.bodyColorDark,
        content: Text(
          msg,
          style: const TextStyle(
            color: AppColors.bodyColorDark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.secondaryColor,
      ),
    );
  }
}
