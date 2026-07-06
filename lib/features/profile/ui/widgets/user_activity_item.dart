import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UserActivityItemWidget extends StatelessWidget {
  final String id;
  final String type;
  final String title;
  final String description;
  final String date;
  final bool read;
  final VoidCallback onTap;

  const UserActivityItemWidget({
    super.key,
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.read,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    final card = GestureDetector(
      onTap: onTap,
      child: read ? _buildReadCard(colors) : _buildUnreadCard(colors),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: card,
    );
  }

  Widget _buildUnreadCard(BondlyColorScheme colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.accent, width: 1),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 2, color: colors.accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildCardContent(colors),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadCard(BondlyColorScheme colors) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: _buildCardContent(colors),
      ),
    );
  }

  Widget _buildCardContent(BondlyColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: title + type icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildTypeIcon(colors),
          ],
        ),
        const SizedBox(height: 10),

        // Message
        PostMentionsWidget(
          text: description,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),

        // Date row
        _buildDateRow(colors),
      ],
    );
  }

  Widget _buildTypeIcon(BondlyColorScheme colors) {
    final IconData icon;
    final LinearGradient gradient;

    switch (type) {
      case "Reconocimientos":
        icon = LucideIcons.award;
        gradient = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [colors.accentGradientStart, colors.accentGradientEnd],
        );
        break;
      case "Recompensas":
        icon = LucideIcons.gift;
        gradient = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [colors.accentGradientStart, colors.accentGradientEnd],
        );
        break;
      default:
        icon = LucideIcons.shieldCheck;
        gradient = const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            BondlyColors.badgeValoresStart,
            BondlyColors.badgeValoresEnd,
          ],
        );
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, size: 18, color: BondlyColors.white),
    );
  }

  Widget _buildDateRow(BondlyColorScheme colors) {
    final parsedDate = _formatDate(date);

    if (!read) {
      return Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            parsedDate,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
        ],
      );
    }

    return Text(
      parsedDate,
      style: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.textMuted,
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      return '$day/$month/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
