import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PodiumEntry {
  final String name;
  final String? avatarUrl;
  final int count;
  final String countLabel;

  const PodiumEntry({
    required this.name,
    this.avatarUrl,
    required this.count,
    required this.countLabel,
  });
}

class PodiumWidget extends StatelessWidget {
  final PodiumEntry first;
  final PodiumEntry second;
  final PodiumEntry third;

  const PodiumWidget({
    super.key,
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingScreen,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _buildSecondPlace(colors)),
            Expanded(child: _buildFirstPlace(colors)),
            Expanded(child: _buildThirdPlace(colors)),
          ],
        ),
      ),
    );
  }

  // ─── 1st Place (Center — tallest) ────────────────────────────────────

  Widget _buildFirstPlace(BondlyColorScheme colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.crown, size: 20, color: colors.podiumGold),
        const SizedBox(height: 4),
        _buildAvatarStack(
          entry: first,
          colors: colors,
          wrapSize: 64,
          avatarSize: 60,
          borderColor: colors.podiumGold,
          iconSize: 28,
          iconColor: BondlyColors.white,
          avatarGradient: AppDimensions.accentGradient(colors),
          medalColor: colors.podiumGold,
          medalSize: 22,
          medalText: '1',
          medalFontSize: 11,
          medalX: 21,
          medalY: 50,
        ),
        const SizedBox(height: 6),
        Text(
          first.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${first.count} ${first.countLabel}',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.accent,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 72,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.accentGradientStart,
                colors.accentGradientStart.withValues(alpha: 0.06),
              ],
            ),
          ),
          child: Center(
            child: Icon(LucideIcons.trophy, size: 28, color: colors.accent),
          ),
        ),
      ],
    );
  }

  // ─── 2nd Place (Left) ────────────────────────────────────────────────

  Widget _buildSecondPlace(BondlyColorScheme colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatarStack(
          entry: second,
          colors: colors,
          wrapSize: 56,
          avatarSize: 52,
          borderColor: colors.silver,
          iconSize: 24,
          iconColor: colors.textMuted,
          avatarBg: colors.surfaceElevated,
          medalColor: colors.silver,
          medalSize: 20,
          medalText: '2',
          medalFontSize: 10,
          medalX: 18,
          medalY: 42,
        ),
        const SizedBox(height: 6),
        Text(
          second.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${second.count} ${second.countLabel}',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            color: colors.silver.withValues(alpha: 0.094),
          ),
          child: Center(
            child: Icon(LucideIcons.medal, size: 24, color: colors.silver),
          ),
        ),
      ],
    );
  }

  // ─── 3rd Place (Right) ───────────────────────────────────────────────

  Widget _buildThirdPlace(BondlyColorScheme colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatarStack(
          entry: third,
          colors: colors,
          wrapSize: 52,
          avatarSize: 48,
          borderColor: colors.bronze,
          iconSize: 22,
          iconColor: colors.textMuted,
          avatarBg: colors.surfaceElevated,
          medalColor: colors.bronze,
          medalSize: 20,
          medalText: '3',
          medalFontSize: 10,
          medalX: 16,
          medalY: 38,
        ),
        const SizedBox(height: 6),
        Text(
          third.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${third.count} ${third.countLabel}',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            color: colors.bronze.withValues(alpha: 0.094),
          ),
          child: Center(
            child: Icon(LucideIcons.medal, size: 22, color: colors.bronze),
          ),
        ),
      ],
    );
  }

  // ─── Avatar Stack Helper ─────────────────────────────────────────────

  Widget _buildAvatarStack({
    required PodiumEntry entry,
    required BondlyColorScheme colors,
    required double wrapSize,
    required double avatarSize,
    required Color borderColor,
    required double iconSize,
    required Color iconColor,
    Color? avatarBg,
    Gradient? avatarGradient,
    required Color medalColor,
    required double medalSize,
    required String medalText,
    required double medalFontSize,
    required double medalX,
    required double medalY,
  }) {
    final hasAvatar = entry.avatarUrl != null && entry.avatarUrl!.isNotEmpty;

    return SizedBox(
      width: wrapSize,
      height: wrapSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: avatarGradient == null ? avatarBg : null,
              gradient: avatarGradient,
              border: Border.all(color: borderColor, width: 2.5),
            ),
            child: hasAvatar
                ? ClipOval(
                    child: Image.network(
                      entry.avatarUrl!,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          LucideIcons.user,
                          size: iconSize,
                          color: iconColor,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      LucideIcons.user,
                      size: iconSize,
                      color: iconColor,
                    ),
                  ),
          ),
          Positioned(
            left: medalX,
            top: medalY,
            child: Container(
              width: medalSize,
              height: medalSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: medalColor,
              ),
              child: Center(
                child: Text(
                  medalText,
                  style: GoogleFonts.montserrat(
                    fontSize: medalFontSize,
                    fontWeight: FontWeight.w800,
                    color: BondlyColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
