import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

class BannersCarousel extends StatefulWidget {
  final List<String>? imageUris;
  const BannersCarousel({super.key, this.imageUris = const []});

  @override
  State<BannersCarousel> createState() => _BannersCarouselState();
}

class _BannersCarouselState extends State<BannersCarousel> {
  final controller = InfiniteScrollController();
  final Color bodyColor = AppColors.bodyColor;

  Widget _buildIconButton(IconData iconData, VoidCallback onPressed,
      {left, right, top, bottom}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: IconButton(
        onPressed: onPressed,
        color: bodyColor,
        icon: Icon(iconData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 12 / 6,
      child: Stack(
        children: [
          widget.imageUris!.isEmpty
              ? CircularProgressIndicator()
              : InfiniteCarousel.builder(
                  itemCount: widget.imageUris!.length,
                  itemExtent: MediaQuery.of(context).size.width * 0.95,
                  anchor: 0.0,
                  velocityFactor: .1,
                  controller: controller,
                  axisDirection: Axis.horizontal,
                  loop: true,
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUris![index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          _buildIconButton(Iconsax.arrow_circle_left, () {
            controller.previousItem();
          }, left: 0.0, right: null, top: 50.0, bottom: 50.0),
          _buildIconButton(Iconsax.arrow_circle_right, () {
            controller.nextItem();
          }, left: null, right: 0.0, top: 50.0, bottom: 50.0),
        ],
      ),
    );
  }
}
