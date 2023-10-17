import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class SinglePostWidget extends StatelessWidget {
  //TBD IMPLEMENT COMMENT AND LIKE FUNCTIONALITY

  final FeedPost post;
  const SinglePostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //if post.image is not null so that means we have an image and is not a badge post
    //we must build the ui based on that.
    //otherwise we should get badge_id with badge.image

    return _buildBadgePost(size);
  }

  Container _buildBadgePost(Size size) {
    return Container(
        width: size.width * .9,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.tertiaryColorLight),
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ]),
        child: Column(
          children: [
            _buildPostHeader(),
            SizedBox(height: 10),
            _buildPostBody(),
            SizedBox(height: 10),
            post.image != null ? _buildPostImage() : _buildBadgePostImage(),
            SizedBox(height: 10),
            _buildActions()
          ],
        ));
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

  Widget _buildPostImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        post.image ?? 'https://api.bondly.mx/public/upload/1693518208339.jpg',
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      ),
    );
  }

  Widget _buildBadgePostImage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            post.badgeId?['image'] ??
                'https://th.bing.com/th/id/OIP.6MALULga-w8M2ybAW3KtyAHaHa?pid=ImgDet&rs=1',
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ),
        ),
        SizedBox(height: 5),
        Text(
          post.badgeId?['name'] ?? 'Badge Name',
          style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.tertiaryColor),
        ),
      ],
    );
  }

  Widget _buildPostBody() {
    return PostMentionsWidget(
      text: post.body ??
          "Soy el mas fan de ustedes, siempre los mas puntuales! @[Mariana Islas](64f7a764801bef3c2b7a0c76) @[Mabel Bello](64f7a8fd801bef3c2b7a0d05)",
      style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyColor),
    );
  }

  Row _buildPostHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(post.senderId?['avatar'] ??
              'https://th.bing.com/th/id/OIP.6MALULga-w8M2ybAW3KtyAHaHa?pid=ImgDet&rs=1'),
        ),
        SizedBox(width: 10),
        Column(children: [
          Text(
            post.senderId?['name'] ?? 'John Doe',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text(
            '12/12/2024',
            style: TextStyle(fontSize: 10),
          ),
        ]),
        Expanded(
          child: SizedBox(),
        ),
        Text(
          post.type ?? 'Reconocimiento',
          style: GoogleFonts.montserrat(
            color: AppColors.tertiaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
