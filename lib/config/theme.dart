import 'package:bondly_app/config/colors.dart';
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
    cardColor: AppColors.tertiaryColor,
    dividerColor: AppColors.darkDividerColor,
    unselectedWidgetColor: AppColors.backgroundColor,
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
      headlineLarge: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      headlineMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
      headlineSmall: GoogleFonts.montserrat(
        color: AppColors.bodyColorDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      counterStyle: GoogleFonts.poppins(
          color: AppColors.bodyColorDark, fontWeight: FontWeight.w300),
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: AppColors.secondaryColor,
      unselectedItemColor: AppColors.bodyColorDark,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(
        color: AppColors.secondaryColor,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.bodyColorDark,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColorLight,
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(AppColors.darkBackgroundColor),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        fixedSize: const Size(150, 48),
        foregroundColor: AppColors.primaryColor,
        textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        fixedSize: const Size(250, 48),
        foregroundColor: AppColors.bodyColorDark,
        backgroundColor: AppColors.tertiaryColor,
        textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      ),
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    useMaterial3: false,
  );

  final ThemeData _light = ThemeData(
    primaryColor: AppColors.primaryColor,
    primaryColorLight: AppColors.primaryColorLight,
    cardColor: AppColors.tertiaryColorLight,
    secondaryHeaderColor: AppColors.secondaryColor,
    dividerColor: AppColors.dividerColor,
    unselectedWidgetColor: AppColors.darkBackgroundColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondaryColor,
        extendedTextStyle: TextStyle(color: AppColors.bodyColorDark)),
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
      headlineLarge: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      headlineMedium: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      headlineSmall: GoogleFonts.montserrat(
        color: AppColors.bodyColor,
      ),
      labelSmall: GoogleFonts.montserrat(color: AppColors.bodyColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      counterStyle: GoogleFonts.poppins(
          color: AppColors.bodyColor, fontWeight: FontWeight.w300),
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundColor,
      selectedItemColor: AppColors.secondaryColor,
      unselectedItemColor: AppColors.darkBackgroundColor,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(
        color: AppColors.secondaryColor,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.darkBackgroundColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColorLight,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        fixedSize: const Size(150, 48),
        foregroundColor: AppColors.primaryColorLight,
        textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        fixedSize: const Size(250, 48),
        foregroundColor: AppColors.bodyColorDark,
        backgroundColor: AppColors.primaryButtonColor,
        textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
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
