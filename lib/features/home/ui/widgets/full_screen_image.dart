import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FullScreenImage extends StatefulWidget {
  final String image;
  final String tag;
  const FullScreenImage({super.key, required this.image, required this.tag});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkBackgroundColor,
        body: Hero(
          tag: widget.tag,
          child: Stack(
            children: [
              Positioned(
                top: kToolbarHeight,
                left: 10,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Iconsax.arrow_left,
                        color: AppColors.bodyColorDark),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 1.8,
                  child: Image.network(
                    "https://api.bondly.mx/${widget.image}",
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
