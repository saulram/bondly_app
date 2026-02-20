import 'package:flutter/material.dart';

/// Legacy color references — kept for backward compatibility during migration.
/// New code should use `BondlyColorScheme` via `Theme.of(context).extension`.
class AppColors {
  AppColors._();

  // Background
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color darkBackgroundColor = Color(0xFF1A1A1A);
  static const Color greyBackGroundColor = Color(0xFFE8E7EC);
  static const Color greyBackGroundColorDark = Color(0xFF656363);

  static const Color dividerColor = Color(0xFFF7F7FD);
  static const Color darkDividerColor = Color(0xFF342F2F);

  // App Global Colors
  static const Color primaryColor = Color(0xFF655B80);
  static const Color primaryColorLight = Color(0xFF928AAA);

  static const Color secondaryColor = Color(0xFFCB156C);
  static const Color secondaryColorLight = Color(0xFFCB996C);

  static const Color tertiaryColor = Color(0xFF026C68);
  static const Color tertiaryColorLight = Color(0xFFDBC5A5);

  // Text
  static const Color bodyColor = Color(0xFF1A1A1A);
  static const Color bodyColorDark = Color(0xFFF5F5F5);

  // Buttons
  static const Color primaryButtonColor = Color(0xFFD9A76C);
  static const Color transparentButtonColor = Color(0xFF655B87);
}

/// New Bondly design-system color tokens.
class BondlyColors {
  BondlyColors._();

  // ─── Light palette ───
  static const Color lightBg = Color(0xFFF6F6F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF0F0F3);

  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6B6B80);
  static const Color lightTextMuted = Color(0xFFA0A0B0);

  static const Color lightAccent = Color(0xFF7C5CFC);
  static const Color lightAccentGradientStart = Color(0xFF7c3aed);
  static const Color lightAccentGradientEnd = Color(0xFFec4899);
  static const Color lightAccentSoft = Color(0xFFEDE7FF);

  static const Color lightBorder = Color(0xFFE5E5EA);
  static const Color lightGold = Color(0xFFFFD648);
  static const Color lightLikeColor = Color(0xFFFF4D6A);

  static const Color lightTagBg = Color(0xFFEDE7FF);
  static const Color lightTagText = Color(0xFF7C5CFC);

  static const Color lightTabActive = Color(0xFF7C5CFC);
  static const Color lightTabInactive = Color(0xFFA0A0B0);

  static const Color lightSliderDotActive = Color(0xFFFFFFFF);
  static const Color lightSliderDotInactive = Color(0x80FFFFFF);

  // ─── Dark palette ───
  static const Color darkBg = Color(0xFF0c0c0c);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceElevated = Color(0xFF2A2A40);

  static const Color darkTextPrimary = Color(0xFFF5F5F8);
  static const Color darkTextSecondary = Color(0xFFCBCBEA);
  static const Color darkTextMuted = Color(0xFFB9B9BC);

  static const Color darkAccent = Color(0xFF9B7FFF);
  static const Color darkAccentGradientStart = Color(0xFFa78bfa);
  static const Color darkAccentGradientEnd = Color(0xFFf472b6);
  static const Color darkAccentSoft = Color(0xFF2A2040);

  static const Color darkBorder = Color(0xFF2E2E44);
  static const Color darkGold = Color(0xFFFFD648);
  static const Color darkLikeColor = Color(0xFFFF6680);

  static const Color darkTagBg = Color(0xFF2A2040);
  static const Color darkTagText = Color(0xFF9B7FFF);

  static const Color darkTabActive = Color(0xFF9B7FFF);
  static const Color darkTabInactive = Color(0xFF6B6B80);

  static const Color darkSliderDotActive = Color(0xFFFFFFFF);
  static const Color darkSliderDotInactive = Color(0x80FFFFFF);

  // ─── Badge gradients ───
  static const Color badgeCompetenciasStart = Color(0xFF7C3AED);
  static const Color badgeCompetenciasEnd = Color(0xFFEC4899);
  static const Color badgeEspecialesStart = Color(0xFFF59E0B);
  static const Color badgeEspecialesEnd = Color(0xFFEF4444);
  static const Color badgeValoresStart = Color(0xFF10B981);
  static const Color badgeValoresEnd = Color(0xFF3B82F6);

  // ─── Podium ───
  static const Color lightPodiumGold = Color(0xFFF59E0B);
  static const Color darkPodiumGold = Color(0xFFFBBF24);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);

  // ─── Fixed ───
  static const Color white = Color(0xFFFFFFFF);
}

/// Theme extension that exposes the Bondly color tokens through the theme.
///
/// Access via: `Theme.of(context).extension<BondlyColorScheme>()!`
class BondlyColorScheme extends ThemeExtension<BondlyColorScheme> {
  final Color bg;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentGradientStart;
  final Color accentGradientEnd;
  final Color accentSoft;
  final Color border;
  final Color gold;
  final Color likeColor;
  final Color tagBg;
  final Color tagText;
  final Color tabActive;
  final Color tabInactive;
  final Color sliderDotActive;
  final Color sliderDotInactive;
  final Color podiumGold;
  final Color silver;
  final Color bronze;

  const BondlyColorScheme({
    required this.bg,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentGradientStart,
    required this.accentGradientEnd,
    required this.accentSoft,
    required this.border,
    required this.gold,
    required this.likeColor,
    required this.tagBg,
    required this.tagText,
    required this.tabActive,
    required this.tabInactive,
    required this.sliderDotActive,
    required this.sliderDotInactive,
    required this.podiumGold,
    required this.silver,
    required this.bronze,
  });

  static const light = BondlyColorScheme(
    bg: BondlyColors.lightBg,
    surface: BondlyColors.lightSurface,
    surfaceElevated: BondlyColors.lightSurfaceElevated,
    textPrimary: BondlyColors.lightTextPrimary,
    textSecondary: BondlyColors.lightTextSecondary,
    textMuted: BondlyColors.lightTextMuted,
    accent: BondlyColors.lightAccent,
    accentGradientStart: BondlyColors.lightAccentGradientStart,
    accentGradientEnd: BondlyColors.lightAccentGradientEnd,
    accentSoft: BondlyColors.lightAccentSoft,
    border: BondlyColors.lightBorder,
    gold: BondlyColors.lightGold,
    likeColor: BondlyColors.lightLikeColor,
    tagBg: BondlyColors.lightTagBg,
    tagText: BondlyColors.lightTagText,
    tabActive: BondlyColors.lightTabActive,
    tabInactive: BondlyColors.lightTabInactive,
    sliderDotActive: BondlyColors.lightSliderDotActive,
    sliderDotInactive: BondlyColors.lightSliderDotInactive,
    podiumGold: BondlyColors.lightPodiumGold,
    silver: BondlyColors.silver,
    bronze: BondlyColors.bronze,
  );

  static const dark = BondlyColorScheme(
    bg: BondlyColors.darkBg,
    surface: BondlyColors.darkSurface,
    surfaceElevated: BondlyColors.darkSurfaceElevated,
    textPrimary: BondlyColors.darkTextPrimary,
    textSecondary: BondlyColors.darkTextSecondary,
    textMuted: BondlyColors.darkTextMuted,
    accent: BondlyColors.darkAccent,
    accentGradientStart: BondlyColors.darkAccentGradientStart,
    accentGradientEnd: BondlyColors.darkAccentGradientEnd,
    accentSoft: BondlyColors.darkAccentSoft,
    border: BondlyColors.darkBorder,
    gold: BondlyColors.darkGold,
    likeColor: BondlyColors.darkLikeColor,
    tagBg: BondlyColors.darkTagBg,
    tagText: BondlyColors.darkTagText,
    tabActive: BondlyColors.darkTabActive,
    tabInactive: BondlyColors.darkTabInactive,
    sliderDotActive: BondlyColors.darkSliderDotActive,
    sliderDotInactive: BondlyColors.darkSliderDotInactive,
    podiumGold: BondlyColors.darkPodiumGold,
    silver: BondlyColors.silver,
    bronze: BondlyColors.bronze,
  );

  @override
  BondlyColorScheme copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentGradientStart,
    Color? accentGradientEnd,
    Color? accentSoft,
    Color? border,
    Color? gold,
    Color? likeColor,
    Color? tagBg,
    Color? tagText,
    Color? tabActive,
    Color? tabInactive,
    Color? sliderDotActive,
    Color? sliderDotInactive,
    Color? podiumGold,
    Color? silver,
    Color? bronze,
  }) {
    return BondlyColorScheme(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentGradientStart: accentGradientStart ?? this.accentGradientStart,
      accentGradientEnd: accentGradientEnd ?? this.accentGradientEnd,
      accentSoft: accentSoft ?? this.accentSoft,
      border: border ?? this.border,
      gold: gold ?? this.gold,
      likeColor: likeColor ?? this.likeColor,
      tagBg: tagBg ?? this.tagBg,
      tagText: tagText ?? this.tagText,
      tabActive: tabActive ?? this.tabActive,
      tabInactive: tabInactive ?? this.tabInactive,
      sliderDotActive: sliderDotActive ?? this.sliderDotActive,
      sliderDotInactive: sliderDotInactive ?? this.sliderDotInactive,
      podiumGold: podiumGold ?? this.podiumGold,
      silver: silver ?? this.silver,
      bronze: bronze ?? this.bronze,
    );
  }

  @override
  BondlyColorScheme lerp(BondlyColorScheme? other, double t) {
    if (other == null) return this;
    return BondlyColorScheme(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentGradientStart:
          Color.lerp(accentGradientStart, other.accentGradientStart, t)!,
      accentGradientEnd:
          Color.lerp(accentGradientEnd, other.accentGradientEnd, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      border: Color.lerp(border, other.border, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      likeColor: Color.lerp(likeColor, other.likeColor, t)!,
      tagBg: Color.lerp(tagBg, other.tagBg, t)!,
      tagText: Color.lerp(tagText, other.tagText, t)!,
      tabActive: Color.lerp(tabActive, other.tabActive, t)!,
      tabInactive: Color.lerp(tabInactive, other.tabInactive, t)!,
      sliderDotActive: Color.lerp(sliderDotActive, other.sliderDotActive, t)!,
      sliderDotInactive:
          Color.lerp(sliderDotInactive, other.sliderDotInactive, t)!,
      podiumGold: Color.lerp(podiumGold, other.podiumGold, t)!,
      silver: Color.lerp(silver, other.silver, t)!,
      bronze: Color.lerp(bronze, other.bronze, t)!,
    );
  }
}
