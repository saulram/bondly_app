import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BondlyTabItem {
  final IconData icon;
  final String label;
  final bool isCenterAction;

  const BondlyTabItem({
    required this.icon,
    required this.label,
    this.isCenterAction = false,
  });
}

class BondlyBottomTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BondlyTabItem> items;

  const BondlyBottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    List<BondlyTabItem>? items,
  }) : items = items ??
            const [
              BondlyTabItem(
                  icon: LucideIcons.layoutGrid,
                  label: StringsHome.tabFeed),
              BondlyTabItem(
                  icon: LucideIcons.crown,
                  label: StringsHome.tabRecognize,
                  isCenterAction: true),
              BondlyTabItem(
                  icon: LucideIcons.trophy,
                  label: StringsHome.tabBadges),
            ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = index == currentIndex;

            if (item.isCenterAction) {
              return _buildCenterTab(colors, item, isActive, index);
            }
            return _buildTab(colors, item, isActive, index);
          }),
        ),
      ),
    );
  }

  Widget _buildTab(
      BondlyColorScheme colors, BondlyTabItem item, bool isActive, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 22,
              color: isActive ? colors.tabActive : colors.tabInactive,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? colors.tabActive : colors.tabInactive,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 20 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: isActive ? colors.tabActive : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterTab(
      BondlyColorScheme colors, BondlyTabItem item, bool isActive, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppDimensions.accentGradient(colors),
              ),
              child: Icon(
                item.icon,
                size: 22,
                color: BondlyColors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? colors.tabActive : colors.tabInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
