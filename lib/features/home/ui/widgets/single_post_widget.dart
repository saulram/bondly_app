import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/full_screen_image.dart';
import 'package:bondly_app/features/home/ui/widgets/post_coments_widget.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _buildBadgePost(size, context);
  }

  Container _buildBadgePost(Size size, BuildContext context) {
    var theme = Theme.of(context);
    return Container(
        width: size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: theme.cardColor),
            color: theme.dividerColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildPostHeader(context),
                  const SizedBox(height: 10),
                  _buildPostBody(theme),
                  const SizedBox(height: 10),
                  widget.post.image != null
                      ? _buildPostImage(context)
                      : _buildBadgePostImage(context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: context.isDarkMode
                    ? AppColors.greyBackGroundColorDark
                    : AppColors.greyBackGroundColor,
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
    Moment postDate = Moment(widget.post.createdAt.toLocal());
    //format postType to be always first letter uppercase
    String type =
        widget.post.type[0].toUpperCase() + widget.post.type.substring(1);

    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(widget.post.sender.avatar != null
              ? widget.post.sender.avatar!
              : "https://api.minimalavatars.com/avatar/avatar/png"),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.post.sender.completeName.trim(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            postDate.format('DD/MM/YYYY hh:mm'),
            style: context.themeData.textTheme.labelSmall,
          ),
        ]),
        const Expanded(
          child: SizedBox(),
        ),
        Chip(
          label: Text(
            type,
            style: GoogleFonts.montserrat(
              color: context.isDarkMode
                  ? AppColors.tertiaryColorLight
                  : AppColors.tertiaryColor,
              fontSize: 12,
            ),
          ),
          backgroundColor: context.isDarkMode
              ? AppColors.tertiaryColor
              : AppColors.tertiaryColorLight,
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
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
              imageUrl: "https://api.bondly.mx/${widget.post.badge?.image}",
              width: 50,
              height: 50,
              progressIndicatorBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return Container();
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorWidget: (context, error, stackTrace) {
                Logger().e(error, stackTrace.toString());
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
          style: context.themeData.textTheme.titleSmall?.copyWith(
              color: context.isDarkMode
                  ? AppColors.tertiaryColorLight
                  : AppColors.tertiaryColor),
        ),
      ],
    );
  }

  Widget _buildPostImage(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
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
                imageUrl: "https://api.bondly.mx/${widget.post.image}",
                errorWidget: (context, error, stackTrace) {
                  Logger().e(error, stackTrace.toString());
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
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        likesBusy ? const CircularProgressIndicator.adaptive() : _buildLike(),
        const SizedBox(width: 10),
        _buildComents(context),
      ],
    );
  }

  Widget _buildLike() {
    return InkWell(
      onTap: () {
        _handleLikes();
      },
      child: Row(
        children: [
          Icon(
            widget.post.isLiked == true
                ? IconsaxBold.heart
                : IconsaxOutline.heart,
            color: widget.post.isLiked == true
                ? (context.isDarkMode
                    ? AppColors.secondaryColorLight
                    : AppColors.secondaryColor)
                : (context.isDarkMode
                    ? AppColors.greyBackGroundColor
                    : AppColors.primaryColor),
          ),
          const SizedBox(width: 5),
          Text(
            widget.post.likes.length.toString(),
            style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: context.isDarkMode
                    ? AppColors.secondaryColorLight
                    : AppColors.secondaryColor),
          ),
        ],
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
    return GestureDetector(
      onTap: () {
        setState(() {
          toggleComents = !toggleComents;
        });
      },
      child: Row(
        children: [
          Icon(IconsaxOutline.message,
              color: context.isDarkMode
                  ? AppColors.tertiaryColorLight
                  : AppColors.tertiaryColor),
          const SizedBox(width: 5),
          Text(
            widget.post.comments.length.toString(),
            style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: context.isDarkMode
                    ? AppColors.tertiaryColorLight
                    : AppColors.tertiaryColor),
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
