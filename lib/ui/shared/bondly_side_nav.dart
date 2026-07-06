import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_main.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _SideNavItem {
  final IconData icon;
  final String label;

  const _SideNavItem({required this.icon, required this.label});
}

const _navItems = [
  _SideNavItem(icon: LucideIcons.crown, label: StringsMain.sideNavInicio),
  _SideNavItem(icon: LucideIcons.user, label: StringsMain.sideNavPerfil),
  _SideNavItem(icon: LucideIcons.layoutGrid, label: StringsMain.sideNavFeed),
  _SideNavItem(icon: LucideIcons.trophy, label: StringsMain.sideNavRanking),
  _SideNavItem(icon: LucideIcons.gift, label: StringsMain.sideNavRecompensas),
  _SideNavItem(icon: LucideIcons.award, label: StringsMain.sideNavEmbajadas),
];

class BondlySideNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onLogout;

  const BondlySideNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return SizedBox(
      width: Constants.sidebarWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: colors.border)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              child: SizedBox(
                height: 40,
                child: Image.asset(
                  context.isDarkMode
                      ? Assets.assetsImgLogoDark
                      : Assets.assetsImgLogo,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Expanded(
              child: NavigationDrawer(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                children: [
                  ..._navItems.map(
                    (item) => NavigationDrawerDestination(
                      icon: Icon(item.icon, size: 18),
                      label: Text(item.label),
                    ),
                  ),
                ],
              ),
            ),
            _buildLogoutItem(context, colors),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context, BondlyColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onLogout,
          hoverColor: colors.accentSoft.withValues(alpha: 0.5),
          focusColor: colors.accentSoft.withValues(alpha: 0.6),
          splashColor: colors.accent.withValues(alpha: 0.15),
          mouseCursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(LucideIcons.logOut, size: 18, color: colors.textMuted),
                const SizedBox(width: 12),
                Text(
                  StringsMain.sideNavLogout,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
