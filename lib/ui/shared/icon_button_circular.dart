import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';

class IconButtonCircular extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const IconButtonCircular({
    super.key,
    required this.icon,
    this.size = 40,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.surfaceElevated,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size * 0.5,
          color: iconColor ?? colors.textSecondary,
        ),
      ),
    );
  }
}
