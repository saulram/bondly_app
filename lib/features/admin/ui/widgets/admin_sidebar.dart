import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_shell_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  final AdminModule? module;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
    this.module,
  });
}

const _navItems = [
  _NavItem(
    label: StringsAdmin.navDashboard,
    icon: LucideIcons.layoutDashboard,
    route: '/admin',
  ),
  _NavItem(
    label: StringsAdmin.navUsers,
    icon: LucideIcons.users,
    route: '/admin/users',
    module: AdminModule.manageUsers,
  ),
  _NavItem(
    label: StringsAdmin.navBadges,
    icon: LucideIcons.award,
    route: '/admin/badges',
    module: AdminModule.manageBadges,
  ),
  _NavItem(
    label: StringsAdmin.navRewards,
    icon: LucideIcons.gift,
    route: '/admin/rewards',
    module: AdminModule.manageRewards,
  ),
  _NavItem(
    label: StringsAdmin.navExchanges,
    icon: LucideIcons.shoppingBag,
    route: '/admin/exchanges',
    module: AdminModule.manageRewards,
  ),
  _NavItem(
    label: StringsAdmin.navBanners,
    icon: LucideIcons.image,
    route: '/admin/banners',
    module: AdminModule.manageBanners,
  ),
  _NavItem(
    label: StringsAdmin.navNews,
    icon: LucideIcons.newspaper,
    route: '/admin/news',
    module: AdminModule.manageBanners,
  ),
  _NavItem(
    label: StringsAdmin.navAmbassadors,
    icon: LucideIcons.star,
    route: '/admin/ambassadors',
    module: AdminModule.manageAmbassadors,
  ),
  _NavItem(
    label: StringsAdmin.navReports,
    icon: LucideIcons.barChart2,
    route: '/admin/reports',
    module: AdminModule.viewReports,
  ),
  _NavItem(
    label: StringsAdmin.navSettings,
    icon: LucideIcons.settings,
    route: '/admin/settings',
    module: AdminModule.manageSettings,
  ),
];

class AdminSidebar extends StatelessWidget {
  final AdminShellViewModel viewModel;
  final String currentRoute;

  const AdminSidebar({
    super.key,
    required this.viewModel,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return Container(
      width: Constants.adminSidebarWidth,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppDimensions.accentGradient(colors),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.shieldCheck,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'Admin',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _navItems
                  .where((item) =>
                      item.module == null ||
                      viewModel.hasPermission(item.module!))
                  .map((item) => _NavTile(
                        item: item,
                        isSelected: currentRoute == item.route ||
                            (item.route != '/admin' &&
                                currentRoute.startsWith(item.route)),
                        colors: colors,
                        onTap: () => context.go(item.route),
                      ))
                  .toList(),
            ),
          ),
          // Back to app
          Padding(
            padding: const EdgeInsets.all(12),
            child: _NavTile(
              item: const _NavItem(
                label: StringsAdmin.backToApp,
                icon: LucideIcons.arrowLeft,
                route: '/homeScreen',
              ),
              isSelected: false,
              colors: colors,
              onTap: () => context.go('/homeScreen'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final BondlyColorScheme colors;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 18,
              color: isSelected ? colors.accent : colors.textMuted,
            ),
            const SizedBox(width: 10),
            Text(
              item.label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? colors.accent : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
