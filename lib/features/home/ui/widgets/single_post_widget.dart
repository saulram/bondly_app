import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/logger.dart';
import 'package:moment_dart/moment_dart.dart';

class SinglePostWidget extends StatelessWidget {
  //TBD IMPLEMENT COMMENT AND LIKE FUNCTIONALITY

  final FeedData post;
  SinglePostWidget({super.key, required this.post});
  ImageHelper imageHelper = ImageHelper();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //if post.image is not null so that means we have an image and is not a badge post
    //we must build the ui based on that.
    //otherwise we should get badge_id with badge.image

    return _buildBadgePost(size, context);
  }

  Container _buildBadgePost(Size size, BuildContext context) {
    return Container(
        width: size.width * .9,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.tertiaryColorLight),
            color: AppColors.backgroundColor,
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
            _buildPostHeader(context),
            const SizedBox(height: 10),
            _buildPostBody(),
            const SizedBox(height: 10),
            post.image != null
                ? _buildPostImage()
                : _buildBadgePostImage(context),
            const SizedBox(height: 10),
            _buildActions()
          ],
        ));
  }

  Widget _buildPostHeader(BuildContext context) {
    Moment postDate = Moment(post.createdAt.toLocal());
    //format postType to be always first letter uppercase
    String type = post.type[0].toUpperCase() + post.type.substring(1);

    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(post.sender.avatar ??
              'https://th.bing.com/th/id/OIP.6MALULga-w8M2ybAW3KtyAHaHa?pid=ImgDet&rs=1'),
        ),
        SizedBox(width: 10),
        Column(children: [
          Text(
            post.sender?.completeName ?? 'John Doe',
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
            color: AppColors.tertiaryColor,
            fontSize: 12,
          ),
        )),
      ],
    );
  }

  Widget _buildPostBody() {
    return PostMentionsWidget(
      text: post.body,
      style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyColor),
    );
  }

  Widget _buildBadgePostImage(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network("https://api.bondly.mx/${post.badge?.image}",
              width: 50,
              height: 50, errorBuilder: (context, error, stackTrace) {
            Logger().e(error, stackTrace.toString());
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(child: Text('Error loading badge image')),
            );
          }, fit: BoxFit.contain),
        ),
        const SizedBox(height: 5),
        Text(
          post.badge?.name ?? 'Badge Name',
          style: context.themeData.textTheme.titleSmall
              ?.copyWith(color: AppColors.tertiaryColor),
        ),
      ],
    );
  }

  Widget _buildPostImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network("https://api.bondly.mx/${post.image}",
            errorBuilder: (context, error, stackTrace) {
          Logger().e(error, stackTrace.toString());
          return const SizedBox(
            height: 50,
            width: 50,
            child: Center(child: Text('Error loading badge image')),
          );
        }, fit: BoxFit.cover));
  }

  Widget _buildActions() {
    return const Row(
      children: [
        Expanded(child: SizedBox()),
        Icon(Iconsax.heart, color: AppColors.secondaryColor),
        SizedBox(width: 10),
        Icon(Iconsax.message, color: AppColors.tertiaryColor),
      ],
    );
  }
}
