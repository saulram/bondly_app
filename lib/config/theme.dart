import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ChangeNotifier {
  ThemeData get lightTheme => _buildTheme(Brightness.light);
  ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final bondly = isLight ? BondlyColorScheme.light : BondlyColorScheme.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: bondly.accent,
      onPrimary: BondlyColors.white,
      secondary: bondly.accentGradientEnd,
      onSecondary: BondlyColors.white,
      tertiary: bondly.gold,
      onTertiary: bondly.textPrimary,
      surface: bondly.surface,
      onSurface: bondly.textPrimary,
      error: isLight ? const Color(0xFFB00020) : const Color(0xFFCF6679),
      onError: BondlyColors.white,
      outline: bondly.border,
      surfaceContainerHighest: bondly.surfaceElevated,
    );

    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );

    final textTheme = baseTextTheme.copyWith(
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: bondly.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        color: bondly.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        color: bondly.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: bondly.textPrimary,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: bondly.textSecondary,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: bondly.textMuted,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        color: bondly.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        color: bondly.textSecondary,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        color: bondly.textMuted,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        color: bondly.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        color: bondly.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        color: bondly.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      brightness: brightness,
      primaryColor: bondly.accent,
      primaryColorLight: bondly.accentSoft,
      cardColor: bondly.surface,
      dividerColor: bondly.border,
      unselectedWidgetColor: bondly.textSecondary,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: bondly.bg,
      useMaterial3: false,
      chipTheme: ChipThemeData(
        backgroundColor: bondly.accentSoft,
        labelStyle: textTheme.labelSmall?.copyWith(color: bondly.accent),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: bondly.accent,
        foregroundColor: BondlyColors.white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: bondly.border,
        linearTrackColor: bondly.border,
        color: bondly.accent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        counterStyle: GoogleFonts.inter(
          color: bondly.textMuted,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: bondly.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: bondly.accent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: bondly.border),
        ),
        prefixIconColor: bondly.textSecondary,
        iconColor: bondly.textSecondary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bondly.surface,
        selectedItemColor: bondly.tabActive,
        unselectedItemColor: bondly.tabInactive,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(color: bondly.tabActive),
        unselectedIconTheme: IconThemeData(color: bondly.tabInactive),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: bondly.accent,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all<Color>(bondly.surface),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          fixedSize: const Size(150, 48),
          side: BorderSide(color: bondly.accent),
          foregroundColor: bondly.accent,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size(250, 48),
          foregroundColor: BondlyColors.white,
          backgroundColor: bondly.accent,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      extensions: [bondly],
    );
  }
}

extension DarkMode on BuildContext {
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);
}
