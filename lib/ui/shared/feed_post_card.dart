import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/ui/shared/tag_pill.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Determines which badge gradient palette to use.
enum FeedBadgeType { competencia, especial, valor }

class FeedPostCard extends StatelessWidget {
  // Badge banner
  final String? badgeName;
  final String? badgeCategory;
  final FeedBadgeType badgeType;
  final IconData? badgeIcon;

  // Author
  final String userName;
  final String? userAvatarUrl;
  final String date;
  final String? tag;

  // Content
  final String? message;
  final Widget? mentionWidget;

  // Actions
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isLikeBusy;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onBadgeTap;
  final VoidCallback? onAvatarTap;

  // Expandable comments
  final Widget? commentsSection;

  const FeedPostCard({
    super.key,
    this.badgeName,
    this.badgeCategory,
    this.badgeType = FeedBadgeType.competencia,
    this.badgeIcon,
    required this.userName,
    this.userAvatarUrl,
    required this.date,
    this.tag,
    this.message,
    this.mentionWidget,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isLikeBusy = false,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
    this.onBadgeTap,
    this.onAvatarTap,
    this.commentsSection,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPost),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (badgeName != null) _buildBadgeBanner(colors),
          _buildPostContent(colors),
          _buildActionsBar(colors),
          if (commentsSection != null) commentsSection!,
        ],
      ),
    );
  }

  // ─── 3a. Badge Banner ─────────────────────────────────────────────────

  Widget _buildBadgeBanner(BondlyColorScheme colors) {
    final gradientColors = _gradientColorsForType(badgeType);

    return GestureDetector(
      onTap: onBadgeTap,
      child: Container(
        height: 100,
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradientColors[0].withValues(alpha: 0.10),
              gradientColors[1].withValues(alpha: 0.10),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: gradientColors,
                ),
              ),
              child: Icon(
                badgeIcon ?? _defaultIconForType(badgeType),
                size: 22,
                color: BondlyColors.white,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badgeName!,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                if (badgeCategory != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    badgeCategory!,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── 3b. Post Content ─────────────────────────────────────────────────

  Widget _buildPostContent(BondlyColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserRow(colors),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 14),
            mentionWidget ??
                Text(
                  message!,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserRow(BondlyColorScheme colors) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: colors.surfaceElevated,
            backgroundImage:
                userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null,
            child: userAvatarUrl == null
                ? Icon(LucideIcons.user, size: 14, color: colors.textMuted)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                date,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
        if (tag != null)
          TagPill(
            label: tag!,
            fontSize: 10,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
      ],
    );
  }

  // ─── 3c. Actions Bar ──────────────────────────────────────────────────

  Widget _buildActionsBar(BondlyColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Like
          AnimatedOpacity(
            opacity: isLikeBusy ? 0.4 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: isLikeBusy ? null : onLikeTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isLiked ? IconsaxBold.heart : LucideIcons.heart,
                      size: 18,
                      color: isLiked ? colors.likeColor : colors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      StringsHome.feedLike,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isLiked ? colors.likeColor : colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Comment
          GestureDetector(
            onTap: onCommentTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.messageCircle,
                    size: 18,
                    color: colors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    StringsHome.feedComment,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Share
          GestureDetector(
            onTap: onShareTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Icon(
                LucideIcons.share2,
                size: 16,
                color: colors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  static List<Color> _gradientColorsForType(FeedBadgeType type) {
    switch (type) {
      case FeedBadgeType.competencia:
        return const [
          BondlyColors.badgeCompetenciasStart,
          BondlyColors.badgeCompetenciasEnd,
        ];
      case FeedBadgeType.especial:
        return const [
          BondlyColors.badgeEspecialesStart,
          BondlyColors.badgeEspecialesEnd,
        ];
      case FeedBadgeType.valor:
        return const [
          BondlyColors.badgeValoresStart,
          BondlyColors.badgeValoresEnd,
        ];
    }
  }

  static IconData _defaultIconForType(FeedBadgeType type) {
    switch (type) {
      case FeedBadgeType.competencia:
        return LucideIcons.award;
      case FeedBadgeType.especial:
        return LucideIcons.star;
      case FeedBadgeType.valor:
        return LucideIcons.shieldCheck;
    }
  }
}
