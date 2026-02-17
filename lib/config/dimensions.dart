import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Spacing
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 10;
  static const double spacingLg = 16;
  static const double spacingXl = 24;
  static const double spacingXxl = 32;

  // Border Radius
  static const double radiusSm = 10;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusRound = 50;

  // Elevation / Shadows
  static List<BoxShadow> cardShadow(Color shadowColor) => [
    BoxShadow(
      color: shadowColor.withValues(alpha: 0.1),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];
}
