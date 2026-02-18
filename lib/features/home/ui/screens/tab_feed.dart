import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/post_coments_widget.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:bondly_app/ui/shared/feed_post_card.dart';
import 'package:bondly_app/ui/shared/slider_banner_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:moment_dart/moment_dart.dart';

class FeedTab extends StatefulWidget {
  final HomeViewModel model;
  const FeedTab({super.key, required this.model});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  HomeViewModel get model => widget.model;

  /// Track which posts have their comments section expanded.
  final Set<String> _expandedComments = {};

  /// Track which posts have a like request in progress.
  final Set<String> _likesInProgress = {};

  Future<void> _onRefresh() async {
    await model.getCompanyFeeds();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final posts = model.feeds.data;

    if (posts.isEmpty) {
      return RefreshIndicator(
        color: colors.accent,
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            _buildSliderSection(),
            const SizedBox(height: 12),
            _buildEmptyState(colors),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: colors.accent,
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: posts.length + 1, // +1 for the slider header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                _buildSliderSection(),
                const SizedBox(height: 12),
              ],
            );
          }

          final post = posts[index - 1];
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.paddingScreen,
              0,
              AppDimensions.paddingScreen,
              index == posts.length ? 20 : 16,
            ),
            child: _buildPostCard(post, index - 1, colors),
          );
        },
      ),
    );
  }

  // ─── Slider Section ───────────────────────────────────────────────────

  Widget _buildSliderSection() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        8,
        AppDimensions.paddingScreen,
        0,
      ),
      child: SliderBannerCard(
        items: [
          BannerItem(
            tag: StringsHome.bannerTag1,
            title: StringsHome.bannerTitle1,
            subtitle: StringsHome.bannerSubtitle1,
          ),
          BannerItem(
            tag: StringsHome.bannerTag2,
            title: StringsHome.bannerTitle2,
            subtitle: StringsHome.bannerSubtitle2,
          ),
          BannerItem(
            title: StringsHome.bannerTitle3,
            subtitle: StringsHome.bannerSubtitle3,
          ),
        ],
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────

  Widget _buildEmptyState(BondlyColorScheme colors) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.inbox,
              size: 48,
              color: colors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              StringsHome.feedEmptyTitle,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              StringsHome.feedEmptyBody,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Post Card ────────────────────────────────────────────────────────

  Widget _buildPostCard(FeedData post, int index, BondlyColorScheme colors) {
    final badgeType = _resolveBadgeType(post.type);
    final postId = post.id ?? index.toString();
    final isExpanded = _expandedComments.contains(postId);

    return FeedPostCard(
      // Badge
      badgeName: post.badge?.name,
      badgeCategory: _resolveBadgeCategory(post.type),
      badgeType: badgeType,
      // Author
      userName: post.sender.completeName.trim(),
      userAvatarUrl: safeImageUrl(post.sender.avatar, isAvatar: true),
      date: _formatDate(post.createdAt),
      tag: StringsHome.feedTagRecognition,
      // Content
      message: post.body,
      mentionWidget: PostMentionsWidget(
        text: post.body,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: colors.textSecondary,
          height: 1.5,
        ),
      ),
      // Actions
      likeCount: post.likes.length,
      commentCount: post.comments.length,
      isLiked: post.isLiked ?? false,
      isLikeBusy: _likesInProgress.contains(postId),
      onLikeTap: () => _handleLike(post),
      onCommentTap: () {
        setState(() {
          if (isExpanded) {
            _expandedComments.remove(postId);
          } else {
            _expandedComments.add(postId);
          }
        });
      },
      onShareTap: () {
        // TODO: Implement native share sheet
      },
      // Comments
      commentsSection: isExpanded
          ? PostCommentsWidget(
              comments: post.comments,
              feedId: post.id!,
              feedIndex: index,
            )
          : null,
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  Future<void> _handleLike(FeedData post) async {
    final postId = post.id;
    if (postId == null) return;

    setState(() => _likesInProgress.add(postId));
    try {
      await getIt<HomeViewModel>().handleLikes(postId);
    } finally {
      if (mounted) {
        setState(() => _likesInProgress.remove(postId));
      }
    }
  }

  static FeedBadgeType _resolveBadgeType(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('especial')) return FeedBadgeType.especial;
    if (lower.contains('valor') || lower.contains('embajada')) {
      return FeedBadgeType.valor;
    }
    return FeedBadgeType.competencia;
  }

  static String _resolveBadgeCategory(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('especial')) return StringsHome.badgeEspeciales;
    if (lower.contains('valor') || lower.contains('embajada')) {
      return StringsHome.badgeValores;
    }
    return StringsHome.badgeCompetencias;
  }

  static String _formatDate(DateTime date) {
    final moment = Moment(date.toLocal());
    return moment.format('DD MMM YYYY');
  }
}
