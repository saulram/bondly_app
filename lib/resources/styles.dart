import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:bondly_app/resources/colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  // Text

  static TextStyle baseTextStyle = const TextStyle(
    color: AppColors.bodyColor,
    fontFamily: "Montserrat"
  );

  static TextStyle primaryButtonTextStyle = baseTextStyle.copyWith(
      color: Colors.white
  );

  static TextStyle transparentButtonTextStyle = baseTextStyle.copyWith(
      color: AppColors.transparentButtonColor
  );

  // Buttons
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryButtonColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.dp),
    ),
  );

  static ButtonStyle transparentButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.dp),
    ),
  );
}