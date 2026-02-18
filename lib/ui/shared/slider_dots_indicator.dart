import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';

class SliderDotsIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  final Color? activeColor;
  final Color? inactiveColor;

  const SliderDotsIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final active = activeColor ?? colors.sliderDotActive;
    final inactive = inactiveColor ?? colors.sliderDotInactive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? active : inactive,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
