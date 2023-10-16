import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/ui/shared/banners_widget.dart';
import 'package:flutter/material.dart';

class BodyLayout extends StatelessWidget {
  final bool enableBanners;
  final Widget child;

  const BodyLayout({
    Key? key,
    required this.enableBanners,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (enableBanners)
          _buildBannersCarousel(getIt<HomeViewModel>().banners),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildBannersCarousel(List<String> imageUris) {
    return BannersCarousel(
      imageUris: imageUris,
    );
  }
}
