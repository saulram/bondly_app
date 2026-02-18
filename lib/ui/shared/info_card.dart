import 'dart:async';

import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/ui/shared/slider_dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A card that displays a swipeable list of text items with a header icon,
/// title, and dot indicators.
///
/// If only one [body] item is provided, swiping and dots are hidden.
class InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> bodies;
  final Duration autoPlayDuration;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.bodies,
    this.autoPlayDuration = const Duration(seconds: 8),
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
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
    if (widget.bodies.length <= 1) return;
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % widget.bodies.length;
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
    final hasManyItems = widget.bodies.length > 1;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingScreen),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(widget.icon, size: 18, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Swipeable body
          SizedBox(
            height: 48,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.bodies.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return Text(
                  widget.bodies[index],
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                );
              },
            ),
          ),
          // Dots
          if (hasManyItems) ...[
            const SizedBox(height: 12),
            Center(
              child: SliderDotsIndicator(
                count: widget.bodies.length,
                activeIndex: _currentPage,
                activeColor: colors.accent,
                inactiveColor: colors.border,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
