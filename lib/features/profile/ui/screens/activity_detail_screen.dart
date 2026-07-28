import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/activity_detail_viewmodel.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:bondly_app/ui/shared/feed_post_card.dart';
import 'package:bondly_app/ui/shared/feed_post_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ActivityDetailScreen extends StatefulWidget {
  static const String route = "/activityDetailScreen";
  static const String idParam = "activityId";
  static const String feedIdParam = "activityFeedId";
  static const String readParam = "activityStatus";

  final ActivityDetailViewModel model = getIt<ActivityDetailViewModel>();
  final String activityId;
  final String feedId;
  final bool isRead;

  ActivityDetailScreen({
    super.key,
    required this.activityId,
    required this.feedId,
    required this.isRead,
  });

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  bool _likeBusy = false;
  bool _commentsExpanded = false;
  bool _commentBusy = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.model.load(widget.feedId, widget.activityId, widget.isRead);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return ModelProvider<ActivityDetailViewModel>(
      model: widget.model,
      child: ModelBuilder<ActivityDetailViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: colors.bg,
            body: Column(
              children: [
                _buildHeader(colors),
                Expanded(
                  child: model.post != null && !model.busy
                      ? _buildPostContent(model.post!, colors)
                      : model.busy
                          ? _buildLoading()
                          : _buildErrorState(colors),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BondlyColorScheme colors) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingScreen,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.arrowLeft,
                    size: 24,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  StringsProfile.myActivity,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostContent(FeedData post, BondlyColorScheme colors) {
    final badgeType = FeedPostHelpers.resolveBadgeType(post.type);
    final homeModel = getIt<HomeViewModel>();
    final currentUserAvatar = homeModel.user?.avatar;

    final previewComments = post.comments
        .take(2)
        .map((c) => FeedCommentData(
              userName: c.user.completeName.trim(),
              userAvatarUrl: safeImageUrl(c.user.avatar, isAvatar: true),
              timeAgo: FeedPostHelpers.formatTimeAgo(c.timeStamp),
              message: c.message ?? '',
            ))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
        vertical: AppDimensions.spacingSm,
      ),
      child: FeedPostCard(
        badgeName: post.badge?.name,
        badgeCategory: FeedPostHelpers.resolveBadgeCategory(post.type),
        badgeType: badgeType,
        userName: post.sender.completeName.trim(),
        userAvatarUrl: safeImageUrl(post.sender.avatar, isAvatar: true),
        date: FeedPostHelpers.formatDate(post.createdAt),
        tag: StringsHome.feedTagRecognition,
        message: post.body,
        mentionWidget: PostMentionsWidget(
          text: post.body,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
        likeCount: post.likes.length,
        commentCount: post.comments.length,
        isLiked: post.isLiked ?? false,
        isLikeBusy: _likeBusy,
        onLikeTap: () => _handleLike(post),
        onCommentTap: post.comments.isNotEmpty
            ? () {
                setState(() {
                  _commentsExpanded = !_commentsExpanded;
                });
              }
            : null,
        showComments: _commentsExpanded,
        commentsPreview: previewComments,
        currentUserAvatarUrl:
            currentUserAvatar != null && currentUserAvatar.isNotEmpty
                ? safeImageUrl(currentUserAvatar, isAvatar: true)
                : null,
        commentController: _commentController,
        isCommentBusy: _commentBusy,
        onSendComment: () => _handleSendComment(post),
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
        vertical: AppDimensions.spacingXl,
      ),
      child: Column(
        children: [
          BondlyShimmerBlock(
            width: double.infinity,
            height: 100,
            borderRadius: 20,
          ),
          SizedBox(height: 12),
          BondlyShimmerBlock(
            width: double.infinity,
            height: 80,
            borderRadius: 16,
          ),
          SizedBox(height: 12),
          BondlyShimmerBlock(
            width: double.infinity,
            height: 48,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BondlyColorScheme colors) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingScreen,
        ),
        padding: const EdgeInsets.all(AppDimensions.spacingXxl),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: AppDimensions.cardShadow(colors.textPrimary),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.alertCircle,
              color: colors.textMuted,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              StringsProfile.myActivityLoadError,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Interaction Handlers ──────────────────────────────────────────

  Future<void> _handleLike(FeedData post) async {
    final postId = post.id;
    if (postId == null) return;

    setState(() => _likeBusy = true);
    try {
      await getIt<HomeViewModel>().handleLikes(postId);
      await widget.model.load(widget.feedId, widget.activityId, widget.isRead);
    } finally {
      if (mounted) setState(() => _likeBusy = false);
    }
  }

  Future<void> _handleSendComment(FeedData post) async {
    if (_commentController.text.trim().isEmpty) return;
    final postId = post.id;
    if (postId == null) return;

    final text = _commentController.text.trim();
    setState(() => _commentBusy = true);
    try {
      await getIt<HomeViewModel>().createComment(postId, text, 0);
      _commentController.clear();
      await widget.model.load(widget.feedId, widget.activityId, widget.isRead);
    } finally {
      if (mounted) setState(() => _commentBusy = false);
    }
  }

}
