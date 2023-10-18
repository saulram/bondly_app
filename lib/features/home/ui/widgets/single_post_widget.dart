import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/ui/widgets/post_mentions_widget.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/logger.dart';

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
            const SizedBox(height: 10),
            _buildPostBody(),
            const SizedBox(height: 10),
            post.image != null ? _buildPostImage() : _buildBadgePostImage(),
            const SizedBox(height: 10),
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
      child: FutureBuilder(
          future: imageHelper.displayFromNetwork(imageUri: post.image!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            );
          }),
    );
  }

  Widget _buildBadgePostImage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: FutureBuilder(
            future: imageHelper.displayFromNetwork(
                imageUri: post.badge?.image ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return const SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: Text('Error loading badge image')),
                );
              } else {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                  errorBuilder: ((context, error, stackTrace) {
                    Logger().e(error, stackTrace.toString());
                    return const SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(child: Text('Error loading badge image')),
                    );
                  }),
                );
              }
            },
          ),
        ),
        SizedBox(height: 5),
        Text(
          post.badge?.name ?? 'Badge Name',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.tertiaryColor,
          ),
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
          backgroundImage: NetworkImage(post.sender.avatar ??
              'https://th.bing.com/th/id/OIP.6MALULga-w8M2ybAW3KtyAHaHa?pid=ImgDet&rs=1'),
        ),
        SizedBox(width: 10),
        Column(children: [
          Text(
            post.sender?.completeName ?? 'John Doe',
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
