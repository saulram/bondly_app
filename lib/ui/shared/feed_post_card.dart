import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/ui/shared/badge_icon_button.dart';
import 'package:bondly_app/ui/shared/tag_pill.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Data for a single comment preview shown inside the expanded post card.
class FeedCommentData {
  final String userName;
  final String? userAvatarUrl;
  final String timeAgo;
  final String message;

  const FeedCommentData({
    required this.userName,
    this.userAvatarUrl,
    required this.timeAgo,
    required this.message,
  });
}

class FeedPostCard extends StatelessWidget {
  // Badge banner
  final String? badgeName;
  final String? badgeCategory;
  final BadgeType badgeType;
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
  final VoidCallback? onBadgeTap;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onViewAllCommentsTap;

  // Comments list — toggled by parent via showComments
  final bool showComments;
  final List<FeedCommentData> commentsPreview;

  // Comment input — shown when commentCount > 0
  final String? currentUserAvatarUrl;
  final TextEditingController? commentController;
  final VoidCallback? onSendComment;
  final bool isCommentBusy;

  const FeedPostCard({
    super.key,
    this.badgeName,
    this.badgeCategory,
    this.badgeType = BadgeType.competencias,
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
    this.onBadgeTap,
    this.onAvatarTap,
    this.onViewAllCommentsTap,
    this.showComments = false,
    this.commentsPreview = const [],
    this.currentUserAvatarUrl,
    this.commentController,
    this.onSendComment,
    this.isCommentBusy = false,
  });

  bool get _hasActivity => likeCount > 0 || commentCount > 0;

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
          // Comments list — only when parent toggled showComments
          if (showComments && commentsPreview.isNotEmpty)
            _buildCommentsPreview(colors),
          // Comment input — always visible when there are comments
          if (commentCount > 0) _buildCommentInput(colors),
        ],
      ),
    );
  }

  // ─── Badge Banner ───────────────────────────────────────────────────

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

  // ─── Post Content ───────────────────────────────────────────────────

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

  // ─── Actions Bar (unified, adapts per count) ────────────────────────

  Widget _buildActionsBar(BondlyColorScheme colors) {
    // Like label: count "N" when likeCount > 0, otherwise "Me gusta"
    final likeLabel =
        likeCount > 0 ? likeCount.toString() : StringsHome.feedLike;
    final likeFontWeight =
        likeCount > 0 ? FontWeight.w600 : FontWeight.w500;

    // Comment label: count "N" when commentCount > 0, otherwise "Comentar"
    final commentLabel =
        commentCount > 0 ? commentCount.toString() : StringsHome.feedComment;

    return Container(
      padding: _hasActivity
          ? const EdgeInsets.fromLTRB(20, 12, 20, 12)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Like button
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
                      isLiked ? LucideIcons.heart : LucideIcons.heart,
                      size: 18,
                      color: isLiked ? colors.likeColor : colors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      likeLabel,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: likeFontWeight,
                        color: isLiked ? colors.likeColor : colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Comment button
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
                    commentLabel,
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
        ],
      ),
    );
  }

  // ─── Comments Preview (toggled by showComments) ─────────────────────

  Widget _buildCommentsPreview(BondlyColorScheme colors) {
    final previewItems = commentsPreview.take(2).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...previewItems.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCommentBubble(c, colors),
              )),
          if (commentCount > 2)
            GestureDetector(
              onTap: onViewAllCommentsTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  StringsHome.feedViewAllComments(commentCount),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentBubble(
      FeedCommentData comment, BondlyColorScheme colors) {
    final hasAvatar =
        comment.userAvatarUrl != null && comment.userAvatarUrl!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: colors.surfaceElevated,
          backgroundImage:
              hasAvatar ? NetworkImage(comment.userAvatarUrl!) : null,
          child: !hasAvatar
              ? Icon(LucideIcons.user, size: 12, color: colors.textMuted)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      comment.timeAgo,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.message,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Comment Input (when commentCount > 0) ──────────────────────────

  Widget _buildCommentInput(BondlyColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          // Current user avatar
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: currentUserAvatarUrl == null
                  ? LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        colors.accentGradientStart,
                        colors.accentGradientEnd,
                      ],
                    )
                  : null,
              image: currentUserAvatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(currentUserAvatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: currentUserAvatarUrl == null
                ? const Icon(
                    LucideIcons.user, size: 12, color: BondlyColors.white)
                : null,
          ),
          const SizedBox(width: 10),
          // Text field
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: commentController,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: StringsHome.feedCommentPlaceholder,
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          GestureDetector(
            onTap: isCommentBusy ? null : onSendComment,
            child: AnimatedOpacity(
              opacity: isCommentBusy ? 0.4 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                LucideIcons.send,
                size: 18,
                color: colors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────

  static List<Color> _gradientColorsForType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return const [
          BondlyColors.badgeCompetenciasStart,
          BondlyColors.badgeCompetenciasEnd,
        ];
      case BadgeType.especiales:
        return const [
          BondlyColors.badgeEspecialesStart,
          BondlyColors.badgeEspecialesEnd,
        ];
      case BadgeType.valores:
        return const [
          BondlyColors.badgeValoresStart,
          BondlyColors.badgeValoresEnd,
        ];
    }
  }

  static IconData _defaultIconForType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return LucideIcons.award;
      case BadgeType.especiales:
        return LucideIcons.star;
      case BadgeType.valores:
        return LucideIcons.shieldCheck;
    }
  }
}
