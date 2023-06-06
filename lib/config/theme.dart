import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// We create a class AppTheme that will hold all the theme data for our app.
/// We will have a light theme and a dark theme.
/// We will also have a static method called getTheme that will return the
/// current theme based on the isDarkMode parameter.
/// This is the class that we will use to get the theme data in our app.
/// We will also use this class to create the theme data for our app.
///
class AppTheme extends ChangeNotifier {
  final ThemeData _dark = ThemeData(
    primaryColor: AppColors.primaryColor,
    primaryColorLight: AppColors.primaryColorLight,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      titleSmall: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      bodyLarge: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      bodyMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      bodySmall: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      labelLarge: GoogleFonts.montserrat(color: AppColors.bodyColorDark),
      labelMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      labelSmall: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.bodyColorDark),
      ),
      prefixIconColor: AppColors.bodyColorDark,
      iconColor: AppColors.bodyColorDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.secondaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColorLight,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        fixedSize:const Size(250,48),
        foregroundColor: AppColors.bodyColorDark,
        backgroundColor: AppColors.tertiaryColor,
        textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700
        ),
      ),
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    useMaterial3: false,
  );

  final ThemeData _light = ThemeData(
    primaryColor: AppColors.primaryColor,
    primaryColorLight: AppColors.primaryColorLight,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      titleSmall: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      bodyLarge: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      bodyMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      bodySmall: GoogleFonts.montserrat(color: AppColors.bodyColor),
      labelLarge: GoogleFonts.montserrat(color: AppColors.bodyColor),
      labelMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      labelSmall: GoogleFonts.montserrat(color: AppColors.bodyColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColorLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      prefixIconColor: AppColors.primaryColorLight,
      iconColor: AppColors.primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColorLight,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        fixedSize:const Size(250,48),
        foregroundColor: AppColors.bodyColorDark,
        backgroundColor: AppColors.primaryButtonColor,
        textStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700
        ),
      ),
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    useMaterial3: false,
  );

  ThemeData get lightTheme => _light;

  ThemeData get darkTheme => _dark;
}

///with this extension you can check whether device is dark mode or not by simply calling:
///context.isDarkMode
///or
///context.isDarkMode ? doSomething() : doSomethingElse()

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

///
/// This is an extension for the context to get the current theme data
/// by simply calling:
/// context.themeData
///
extension ThemeExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);
}
