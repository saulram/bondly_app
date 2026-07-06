import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:flutter/material.dart';

class GoldBorderedContainer extends StatefulWidget {
  final Widget? child;
  const GoldBorderedContainer({super.key, this.child});

  @override
  State<GoldBorderedContainer> createState() => _GoldBorderedContainerState();
}

class _GoldBorderedContainerState extends State<GoldBorderedContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: colors.border),
          color: colorScheme.surfaceContainerHighest,
          boxShadow: AppDimensions.cardShadow(colorScheme.onSurface)),
      padding: const EdgeInsets.all(AppDimensions.radiusLg),
      child: widget.child,
    );
  }
}
