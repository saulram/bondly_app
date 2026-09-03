import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/ai/ui/widgets/feed_personalization_banner.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:bondly_app/ui/shared/feed_post_card.dart';
import 'package:bondly_app/ui/shared/feed_post_helpers.dart';
import 'package:bondly_app/ui/shared/slider_banner_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FeedTab extends StatefulWidget {
  final HomeViewModel model;
  const FeedTab({super.key, required this.model});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  HomeViewModel get model => widget.model;

  /// Track which posts have a like request in progress.
  final Set<String> _likesInProgress = {};

  /// Track which posts have their comments list expanded.
  final Set<String> _expandedComments = {};

  /// Track which posts have a comment submission in progress.
  final Set<String> _commentBusy = {};

  /// One TextEditingController per post for the inline comment field.
  final Map<String, TextEditingController> _commentControllers = {};

  Future<void> _onRefresh() async {
    await model.getCompanyFeeds();
  }

  @override
  void dispose() {
    for (final c in _commentControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final posts = model.feeds.data;

    // Dispose controllers for posts no longer in the list to avoid leaks.
    _pruneStaleControllers(posts);

    if (posts.isEmpty) {
      return RefreshIndicator(
        color: colors.accent,
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: posts.length + 1, // +1 for the slider header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                _buildSliderSection(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingScreen,
                  ),
                  child: FeedPersonalizationBanner(
                    isPersonalized: model.isPersonalized,
                    isLoading: model.personalizingFeed,
                    onToggle: () {
                      final messenger = ScaffoldMessenger.of(context);
                      model.toggleFeedPersonalization().then((_) {
                        final message = model.feedPersonalizationError;
                        if (!mounted || message == null) return;
                        messenger.showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      });
                    },
                  ),
                ),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        8,
        AppDimensions.paddingScreen,
        0,
      ),
      child: SliderBannerCard(
        items: model.banners
            .map((banner) => BannerItem(
                tag: 'Novedades',
                title: banner.name ?? 'Novedad',
                subtitle: banner.description,
                image: banner.image))
            .toList(),
        isLoading: model.bannersLoading,
        errorMessage: model.bannersError == null
            ? null
            : 'No se pudieron cargar las novedades',
        onRetry: model.getCompanyBanners,
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
    final badgeType = FeedPostHelpers.resolveBadgeType(post.type);
    final postId = post.id ?? index.toString();

    // Ensure a controller exists for this post
    _commentControllers.putIfAbsent(postId, () => TextEditingController());

    // Build comments preview (last 2)
    final previewComments = post.comments
        .take(2)
        .map((c) => FeedCommentData(
              userName: c.user.completeName.trim(),
              userAvatarUrl: safeImageUrl(c.user.avatar, isAvatar: true),
              timeAgo: FeedPostHelpers.formatTimeAgo(c.timeStamp),
              message: c.message ?? '',
            ))
        .toList();

    final currentUserAvatar = model.user?.avatar;

    return FeedPostCard(
      // Badge
      badgeName: post.badge?.name,
      badgeCategory: FeedPostHelpers.resolveBadgeCategory(post.type),
      badgeType: badgeType,
      // Author
      userName: post.sender.completeName.trim(),
      userAvatarUrl: safeImageUrl(post.sender.avatar, isAvatar: true),
      date: FeedPostHelpers.formatDate(post.createdAt),
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
      onCommentTap: post.comments.isNotEmpty
          ? () {
              setState(() {
                if (_expandedComments.contains(postId)) {
                  _expandedComments.remove(postId);
                } else {
                  _expandedComments.add(postId);
                }
              });
            }
          : null,
      // Comments preview
      showComments: _expandedComments.contains(postId),
      commentsPreview: previewComments,
      onViewAllCommentsTap: () => _showAllComments(post),
      // Comment input
      currentUserAvatarUrl:
          currentUserAvatar != null && currentUserAvatar.isNotEmpty
              ? safeImageUrl(currentUserAvatar, isAvatar: true)
              : null,
      commentController: _commentControllers[postId],
      isCommentBusy: _commentBusy.contains(postId),
      onSendComment: () => _handleSendComment(postId, index),
    );
  }

  void _showAllComments(FeedData post) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  StringsHome.feedViewAllComments(post.comments.length),
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Divider(height: 1, color: colors.border),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: post.comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, index) {
                    final comment = post.comments[index];
                    final avatar = safeImageUrl(
                      comment.user.avatar,
                      isAvatar: true,
                    );
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(avatar),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.user.completeName.trim(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                comment.message ?? '',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                FeedPostHelpers.formatTimeAgo(
                                  comment.timeStamp,
                                ),
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  void _pruneStaleControllers(List<FeedData> posts) {
    final activeIds = posts.map((p) => p.id ?? '').toSet();
    final staleKeys = _commentControllers.keys
        .where((key) => !activeIds.contains(key))
        .toList();
    for (final key in staleKeys) {
      _commentControllers[key]?.dispose();
      _commentControllers.remove(key);
    }
  }

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

  Future<void> _handleSendComment(String postId, int feedIndex) async {
    final controller = _commentControllers[postId];
    if (controller == null || controller.text.trim().isEmpty) return;

    final text = controller.text.trim();
    setState(() => _commentBusy.add(postId));
    try {
      await getIt<HomeViewModel>().createComment(postId, text, feedIndex);
      controller.clear();
    } finally {
      if (mounted) {
        setState(() => _commentBusy.remove(postId));
      }
    }
  }
}
