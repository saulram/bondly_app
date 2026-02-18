import 'dart:async';

import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/ui/shared/slider_dots_indicator.dart';
import 'package:bondly_app/ui/shared/tag_pill.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerItem {
  final String? tag;
  final String title;
  final String? subtitle;

  const BannerItem({this.tag, required this.title, this.subtitle});
}

class SliderBannerCard extends StatefulWidget {
  final List<BannerItem> items;
  final Duration autoPlayDuration;

  const SliderBannerCard({
    super.key,
    required this.items,
    this.autoPlayDuration = const Duration(seconds: 5),
  });

  @override
  State<SliderBannerCard> createState() => _SliderBannerCardState();
}

class _SliderBannerCardState extends State<SliderBannerCard> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (widget.items.length <= 1) return;
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % widget.items.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: AppDimensions.accentGradient(colors),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPost),
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingScreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.tag != null)
                      TagPill(
                        label: item.tag!,
                        backgroundColor:
                            BondlyColors.white.withValues(alpha: 0.2),
                        textColor: BondlyColors.white,
                      ),
                    if (item.tag != null) const SizedBox(height: 10),
                    Text(
                      item.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: BondlyColors.white,
                        height: 1.15,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.subtitle!,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: BondlyColors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          if (widget.items.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: SliderDotsIndicator(
                  count: widget.items.length,
                  activeIndex: _currentPage,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
