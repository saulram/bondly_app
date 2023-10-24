import 'dart:io';

import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FullScreenImage extends StatefulWidget {
  final String image;
  final String tag;
  final bool isFile;
  final File? imageFile;

  const FullScreenImage({
    super.key,
    required this.image,
    required this.tag,
    this.isFile = false,
    this.imageFile
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Hero(
          tag: widget.tag,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 1.8,
                  child: widget.isFile ? Image.file(widget.imageFile!)
                    : Image.network(
                      widget.image.contains("http")
                          ? widget.image
                          : "https://api.bondly.mx/${widget.image}",
                      fit: BoxFit.contain,
                    ),
                ),
              ),
              Positioned(
                top: kToolbarHeight,
                left: 10,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(24.0))
                    ),
                    child: IconButton(
                      icon:  Icon(Iconsax.arrow_left,
                          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
