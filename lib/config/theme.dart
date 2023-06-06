
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
  final ThemeData _light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    useMaterial3: false,
  );
  final ThemeData _dark = ThemeData(
    primaryColor: AppColors.primaryColor,

    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserrat(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      titleSmall: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      labelLarge: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      labelMedium: GoogleFonts.montserrat(
        color: Colors.white,
      ),
      labelSmall: GoogleFonts.montserrat(
        color: Colors.white,
      ),

    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:const  BorderSide(
          color: Colors.white,
        ),
      ),
      prefixIconColor: Colors.white,
      iconColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),

      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primaryButtonColor,
      textTheme: ButtonTextTheme.primary,
    ),
    scaffoldBackgroundColor:AppColors.darkBackgroundColor ,
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