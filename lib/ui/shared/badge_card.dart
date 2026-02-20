import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BadgeCard extends StatelessWidget {
  final String name;
  final String categoryLabel;
  final List<Color> gradientColors;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback? onTap;

  const BadgeCard({
    super.key,
    required this.name,
    required this.categoryLabel,
    required this.gradientColors,
    required this.icon,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Column(
          children: [
            // Top area — soft gradient background + icon circle
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    gradientColors[0].withValues(alpha: 0.094),
                    gradientColors[1].withValues(alpha: 0.094),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: gradientColors,
                    ),
                  ),
                  child: _buildIconContent(colors),
                ),
              ),
            ),
            // Info area
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    categoryLabel,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContent(BondlyColorScheme colors) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            icon,
            size: 24,
            color: BondlyColors.white,
          ),
        ),
      );
    }
    return Icon(icon, size: 24, color: BondlyColors.white);
  }
}
