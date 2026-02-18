import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/ui/shared/tag_pill.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FeedPostCard extends StatelessWidget {
  final String? badgeLabel;
  final IconData? badgeIcon;
  final LinearGradient? badgeGradient;
  final String userName;
  final String? userAvatarUrl;
  final String date;
  final String? tag;
  final String message;
  final String? mentionText;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;

  const FeedPostCard({
    super.key,
    this.badgeLabel,
    this.badgeIcon,
    this.badgeGradient,
    required this.userName,
    this.userAvatarUrl,
    required this.date,
    this.tag,
    required this.message,
    this.mentionText,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPost),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Badge banner
          if (badgeLabel != null) _buildBadgeBanner(colors),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserRow(colors),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: colors.textPrimary,
                    height: 1.5,
                  ),
                ),
                if (mentionText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    mentionText!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: colors.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Actions bar
          _buildActionsBar(colors),
        ],
      ),
    );
  }

  Widget _buildBadgeBanner(BondlyColorScheme colors) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: badgeGradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.accentGradientStart.withValues(alpha: 0.15),
                colors.accentGradientEnd.withValues(alpha: 0.15),
              ],
            ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusPost),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.accentGradientStart, colors.accentGradientEnd],
              ),
            ),
            child: Icon(
              badgeIcon ?? LucideIcons.award,
              size: 22,
              color: BondlyColors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              badgeLabel!,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(BondlyColorScheme colors) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: colors.surfaceElevated,
          backgroundImage:
              userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null,
          child: userAvatarUrl == null
              ? Icon(LucideIcons.user, size: 16, color: colors.textMuted)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
        if (tag != null) TagPill(label: tag!),
      ],
    );
  }

  Widget _buildActionsBar(BondlyColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onLikeTap,
            child: Row(
              children: [
                Icon(
                  isLiked ? LucideIcons.heart : LucideIcons.heart,
                  size: 20,
                  color: isLiked ? colors.likeColor : colors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  likeCount.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: onCommentTap,
            child: Row(
              children: [
                Icon(LucideIcons.messageCircle,
                    size: 20, color: colors.textMuted),
                const SizedBox(width: 6),
                Text(
                  commentCount.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onShareTap,
            child: Icon(LucideIcons.share2, size: 20, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
