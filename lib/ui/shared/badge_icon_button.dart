import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum BadgeType { competencias, especiales, valores }

class BadgeIconButton extends StatelessWidget {
  final BadgeType type;
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const BadgeIconButton({
    super.key,
    required this.type,
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _gradientForType(type),
            ),
            child: Icon(
              icon ?? _defaultIconForType(type),
              size: 26,
              color: BondlyColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  static LinearGradient _gradientForType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            BondlyColors.badgeCompetenciasStart,
            BondlyColors.badgeCompetenciasEnd
          ],
        );
      case BadgeType.especiales:
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            BondlyColors.badgeEspecialesStart,
            BondlyColors.badgeEspecialesEnd
          ],
        );
      case BadgeType.valores:
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            BondlyColors.badgeValoresStart,
            BondlyColors.badgeValoresEnd
          ],
        );
    }
  }

  static IconData _defaultIconForType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return LucideIcons.award;
      case BadgeType.especiales:
        return LucideIcons.star;
      case BadgeType.valores:
        return LucideIcons.heart;
    }
  }
}
