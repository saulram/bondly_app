import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_user_with_permissions.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_permissions_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminPermissionsScreen extends StatefulWidget {
  static const String route = '/admin/settings/permissions';

  const AdminPermissionsScreen({super.key});

  @override
  State<AdminPermissionsScreen> createState() =>
      _AdminPermissionsScreenState();
}

class _AdminPermissionsScreenState extends State<AdminPermissionsScreen> {
  late AdminPermissionsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminPermissionsViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageSettings,
      child: ModelProvider<AdminPermissionsViewModel>(
        model: _vm,
        child: ModelBuilder<AdminPermissionsViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsAdmin.permissionsTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  StringsAdmin.permissionsSubtitle,
                  style: GoogleFonts.montserrat(
                      fontSize: 13, color: colors.textMuted),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.error != null
                          ? AdminEmptyState(
                              icon: LucideIcons.alertCircle,
                              message: vm.error!,
                              ctaLabel: StringsAdmin.retry,
                              onCta: vm.load)
                          : vm.adminUsers.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.shieldCheck,
                                  message: StringsAdmin.permissionsSubtitle,
                                )
                              : _AdminUsersList(vm: vm, colors: colors),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminUsersList extends StatelessWidget {
  final AdminPermissionsViewModel vm;
  final BondlyColorScheme colors;

  const _AdminUsersList({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: vm.adminUsers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) => _AdminUserCard(
        entry: vm.adminUsers[i],
        vm: vm,
        colors: colors,
      ),
    );
  }
}

class _AdminUserCard extends StatefulWidget {
  final AdminUserWithPermissions entry;
  final AdminPermissionsViewModel vm;
  final BondlyColorScheme colors;

  const _AdminUserCard(
      {required this.entry, required this.vm, required this.colors});

  @override
  State<_AdminUserCard> createState() => _AdminUserCardState();
}

class _AdminUserCardState extends State<_AdminUserCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.entry.user;
    final isSuperAdmin = user.role == 'superAdmin';
    final colors = widget.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colors.accentSoft,
                    backgroundImage: user.avatar != null
                        ? CachedNetworkImageProvider(user.avatar!)
                        : null,
                    child: user.avatar == null
                        ? Text(
                            (user.completeName?.isNotEmpty == true
                                ? user.completeName![0]
                                : user.email[0]),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: colors.accent),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.completeName ?? user.email,
                          style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          user.email,
                          style: GoogleFonts.montserrat(
                              fontSize: 11, color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  if (isSuperAdmin)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        StringsAdmin.superAdminBadge,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: 16,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: colors.border),
            Padding(
              padding: const EdgeInsets.all(12),
              child: isSuperAdmin
                  ? Text(
                      StringsAdmin.allPermissions,
                      style: GoogleFonts.montserrat(
                          fontSize: 13, color: colors.textMuted),
                    )
                  : _PermissionsGrid(
                      entry: widget.entry,
                      vm: widget.vm,
                      colors: colors,
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PermissionsGrid extends StatelessWidget {
  final AdminUserWithPermissions entry;
  final AdminPermissionsViewModel vm;
  final BondlyColorScheme colors;

  const _PermissionsGrid(
      {required this.entry, required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AdminModule.values.map((module) {
        final hasPermission = entry.permissions.contains(module);
        return InkWell(
          onTap: () => vm.togglePermission(entry.user.id, module),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: hasPermission
                  ? colors.accentSoft
                  : colors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasPermission ? colors.accent : colors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasPermission
                      ? LucideIcons.checkCircle2
                      : LucideIcons.circle,
                  size: 14,
                  color:
                      hasPermission ? colors.accent : colors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  _moduleLabel(module),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: hasPermission
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: hasPermission
                        ? colors.accent
                        : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _moduleLabel(AdminModule module) => switch (module) {
        AdminModule.manageUsers => StringsAdmin.navUsers,
        AdminModule.manageBadges => StringsAdmin.navBadges,
        AdminModule.manageRewards => StringsAdmin.navRewards,
        AdminModule.manageBanners => 'Banners & Noticias',
        AdminModule.manageAmbassadors => StringsAdmin.navAmbassadors,
        AdminModule.viewReports => StringsAdmin.navReports,
        AdminModule.manageZones => StringsAdmin.navZones,
        AdminModule.manageSettings => StringsAdmin.navSettings,
        AdminModule.manageFeeds => StringsAdmin.navFeeds,
        AdminModule.manageSuggestions => StringsAdmin.navSuggestions,
      };
}
