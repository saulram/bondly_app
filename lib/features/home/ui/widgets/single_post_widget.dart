import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/ai/ui/widgets/sentiment_badge.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/full_screen_image.dart';
import 'package:bondly_app/features/home/ui/widgets/post_coments_widget.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:moment_dart/moment_dart.dart';

class SinglePostWidget extends StatefulWidget {
  final FeedData post;
  final int index;
  const SinglePostWidget({super.key, required this.post, required this.index});

  @override
  State<SinglePostWidget> createState() => _SinglePostWidgetState();
}

class _SinglePostWidgetState extends State<SinglePostWidget> {
  bool toggleComents = false;
  bool likesBusy = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _buildBadgePost(size, context);
  }

  Container _buildBadgePost(Size size, BuildContext context) {
    var theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.extension<BondlyColorScheme>()!;
    return Container(
        width: size.width,
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
        decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppDimensions.cardShadow(colorScheme.onSurface)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              child: Column(
                children: [
                  _buildPostHeader(context),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _buildPostBody(theme),
                  const SizedBox(height: AppDimensions.spacingMd),
                  widget.post.image != null
                      ? _buildPostImage(context)
                      : _buildBadgePostImage(context),
                  const SizedBox(height: AppDimensions.spacingMd),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                color: colorScheme.surfaceContainerHighest,
              ),
              child: Column(
                children: [
                  _buildActions(context),
                  toggleComents ? _commentsSection(context) : const SizedBox(),
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildPostHeader(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    Moment postDate = Moment(widget.post.createdAt.toLocal());
    String type =
        widget.post.type[0].toUpperCase() + widget.post.type.substring(1);

    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
              safeImageUrl(widget.post.sender.avatar, isAvatar: true)),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.post.sender.completeName.trim(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            postDate.format('DD/MM/YYYY hh:mm'),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ]),
        const Expanded(
          child: SizedBox(),
        ),
        Chip(
          label: Text(
            type,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.tagText,
                  fontSize: 12,
                ),
          ),
          backgroundColor: colors.tagBg,
        ),
      ],
    );
  }

  Widget _buildPostBody(ThemeData theme) {
    return PostMentionsWidget(
      text: widget.post.body,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildBadgePostImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: CachedNetworkImage(
              imageUrl: safeImageUrl(widget.post.badge?.image),
              width: 50,
              height: 50,
              progressIndicatorBuilder: (context, _, loadingProgress) {
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: BondlyShimmerCircle(size: 50)),
                );
              },
              errorWidget: (context, error, stackTrace) {
                Logger().e('Error loading badge image', error: error);
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: Text('Error loading badge image')),
                );
              },
              fit: BoxFit.contain),
        ),
        const SizedBox(height: 5),
        Text(
          widget.post.badge?.name ?? 'Badge Name',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: colorScheme.tertiary),
        ),
      ],
    );
  }

  Widget _buildPostImage(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Hero(
          tag: widget.post.id!,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    image: widget.post.image!,
                    tag: widget.post.id!,
                  ),
                ),
              );
            },
            child: CachedNetworkImage(
                imageUrl: safeImageUrl(widget.post.image),
                errorWidget: (context, error, stackTrace) {
                  Logger().e('Error loading post image', error: error);
                  return const SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(child: Text('Error loading badge image')),
                  );
                },
                fit: BoxFit.cover),
          ),
        ));
  }

  Widget _buildActions(BuildContext context) {
    final homeModel = getIt<HomeViewModel>();
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final sentiment = homeModel.getSentiment(widget.post.id ?? '');
    final isAnalyzing = homeModel.isAnalyzingSentiment(widget.post.id ?? '');

    return Row(
      children: [
        // AI Sentiment: tap-to-analyze button → spinner → badge
        if (sentiment != null)
          SentimentBadge(sentiment: sentiment)
        else if (isAnalyzing)
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          )
        else
          GestureDetector(
            onTap: () {
              if (widget.post.id != null) {
                homeModel.analyzeFeedSentiment(
                  widget.post.id!,
                  widget.post.body,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accentSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: colors.accent),
                  const SizedBox(width: 4),
                  Text(
                    'IA',
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Expanded(child: SizedBox()),
        _buildLike(),
        const SizedBox(width: AppDimensions.spacingMd),
        _buildComents(context),
      ],
    );
  }

  Widget _buildLike() {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return AnimatedOpacity(
      opacity: likesBusy ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: likesBusy
            ? null
            : () {
                _handleLikes();
              },
        child: Row(
          children: [
            Icon(
              widget.post.isLiked == true
                  ? IconsaxBold.heart
                  : IconsaxOutline.heart,
              color: widget.post.isLiked == true
                  ? colors.likeColor
                  : colors.textMuted,
            ),
            const SizedBox(width: 5),
            Text(
              widget.post.likes.length.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: colors.likeColor),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLikes() {
    setState(() {
      likesBusy = true;
    });
    getIt<HomeViewModel>().handleLikes(widget.post.id!).then((value) {
      setState(() {
        likesBusy = false;
      });
    });
  }

  Widget _buildComents(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return GestureDetector(
      onTap: () {
        setState(() {
          toggleComents = !toggleComents;
        });
      },
      child: Row(
        children: [
          Icon(IconsaxOutline.message, color: colors.accent),
          const SizedBox(width: 5),
          Text(
            widget.post.comments.length.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.accent),
          ),
        ],
      ),
    );
  }

  Widget _commentsSection(BuildContext context) {
    return PostCommentsWidget(
      comments: widget.post.comments,
      feedId: widget.post.id!,
      feedIndex: widget.index,
    );
  }
}
