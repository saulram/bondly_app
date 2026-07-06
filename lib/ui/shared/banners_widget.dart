import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
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

  Widget _buildIconButton(IconData iconData, VoidCallback onPressed,
      {left, right, top, bottom}) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin:
              const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
          padding: const EdgeInsets.all(2),
          decoration:
              BoxDecoration(color: colors.accent, shape: BoxShape.circle),
          child: Center(child: Icon(iconData, color: BondlyColors.white)),
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
                  child: BondlyShimmerBlock(
                      width: 300,
                      height: 120,
                      borderRadius: AppDimensions.radiusLg),
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
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusLg),
                          boxShadow: AppDimensions.cardShadow(
                              Theme.of(context).colorScheme.onSurface),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusLg),
                          child: CachedNetworkImage(
                            imageUrl: safeImageUrl(widget.imageUris![index]),
                            fit: BoxFit.fill,
                            alignment: Alignment.topLeft,
                          ),
                        ));
                  },
                ),
          _buildIconButton(LucideIcons.arrowLeftCircle, () {
            controller.previousItem();
          }, left: 0.0, right: null, top: 50.0, bottom: 50.0),
          _buildIconButton(LucideIcons.arrowRightCircle, () {
            controller.nextItem();
          }, left: null, right: 0.0, top: 50.0, bottom: 50.0),
        ],
      ),
    );
  }
}
