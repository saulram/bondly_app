import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:flutter/material.dart';

class AppStyles {
  // Text
  static const fontFamily = "Montserrat";

  static TextStyle baseTextStyle =
      const TextStyle(color: AppColors.bodyColor, fontFamily: fontFamily);

  static TextStyle primaryButtonTextStyle =
      baseTextStyle.copyWith(color: Colors.white);

  static TextStyle transparentButtonTextStyle =
      baseTextStyle.copyWith(color: AppColors.transparentButtonColor);

  // Buttons
  @Deprecated("Use Theme of primaryButton instead")
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.dp),
      ),
      minimumSize: Size.fromHeight(48.dp));

  static ButtonStyle transparentButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.dp),
    ),
  );
}
