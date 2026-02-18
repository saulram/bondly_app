import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';

class AppServices {
  void showSnackbar(GlobalKey<ScaffoldState> scaffoldKey, String msg) {
    final context = scaffoldKey.currentContext!;
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 5000),
        showCloseIcon: true,
        closeIconColor: BondlyColors.white,
        content: Text(
          msg,
          style: const TextStyle(
            color: BondlyColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colors.accent,
      ),
    );
  }
}
