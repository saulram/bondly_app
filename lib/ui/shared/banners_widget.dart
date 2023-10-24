import 'package:bondly_app/config/colors.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

class BannersCarousel extends StatefulWidget {
  final List<String>? imageUris;
  const BannersCarousel({super.key, this.imageUris = const []});

  @override
  State<BannersCarousel> createState() => _BannersCarouselState();
}

class _BannersCarouselState extends State<BannersCarousel> {
  final controller = InfiniteScrollController();
  final Color bodyColor = AppColors.primaryButtonColor;

  Widget _buildIconButton(IconData iconData, VoidCallback onPressed,
      {left, right, top, bottom}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(color: bodyColor, shape: BoxShape.circle),
          child: Center(child: Icon(iconData, color: Colors.white)),
        ),
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
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : InfiniteCarousel.builder(
                  itemCount: widget.imageUris!.length,
                  itemExtent: MediaQuery.of(context).size.width * 0.95,
                  anchor: 0.0,
                  velocityFactor: .1,
                  controller: controller,
                  axisDirection: Axis.horizontal,
                  loop: true,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                        margin: const EdgeInsets.all(5),
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
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            "https://api.bondly.mx/${widget.imageUris![index]}",
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft,
                          ),
                        ));
                  },
                ),
          _buildIconButton(IconsaxOutline.arrow_circle_left, () {
            controller.previousItem();
          }, left: 0.0, right: null, top: 50.0, bottom: 50.0),
          _buildIconButton(IconsaxOutline.arrow_circle_right, () {
            controller.nextItem();
          }, left: null, right: 0.0, top: 50.0, bottom: 50.0),
        ],
      ),
    );
  }
}
