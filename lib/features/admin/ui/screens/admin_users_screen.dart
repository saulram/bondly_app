import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_user.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_users_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_search_bar.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_status_badge.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminUsersScreen extends StatefulWidget {
  static const String route = '/admin/users';

  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late AdminUsersViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminUsersViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageUsers,
      child: ModelProvider<AdminUsersViewModel>(
        model: _vm,
        child: ModelBuilder<AdminUsersViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      StringsAdmin.usersTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (!vm.isLoading)
                      Text(
                        '${vm.result.total} ${StringsAdmin.rows}',
                        style: GoogleFonts.montserrat(
                            fontSize: 13, color: colors.textMuted),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search + filters
                Row(
                  children: [
                    Expanded(
                      child: AdminSearchBar(
                        hint: StringsAdmin.searchUsers,
                        onChanged: vm.onSearch,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterDropdown(
                      value: vm.roleFilter,
                      hint: StringsAdmin.filterByRole,
                      items: const {
                        'client': StringsAdmin.roleClient,
                        'admin': StringsAdmin.roleAdmin,
                        'superAdmin': StringsAdmin.roleSuperAdmin,
                      },
                      onChanged: vm.setRoleFilter,
                      colors: colors,
                    ),
                    const SizedBox(width: 8),
                    _FilterDropdown(
                      value: vm.activeFilter == null
                          ? null
                          : vm.activeFilter!
                              ? 'true'
                              : 'false',
                      hint: StringsAdmin.filterByStatus,
                      items: const {
                        'true': StringsAdmin.filterActive,
                        'false': StringsAdmin.filterInactive,
                      },
                      onChanged: (v) => vm.setActiveFilter(
                          v == null ? null : v == 'true'),
                      colors: colors,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Table
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.error != null
                          ? AdminEmptyState(
                              icon: LucideIcons.alertCircle,
                              message: vm.error!,
                              ctaLabel: 'Reintentar',
                              onCta: vm.load,
                            )
                          : vm.result.items.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.users,
                                  message: StringsAdmin.noUsersFound,
                                )
                              : _UsersTable(vm: vm, colors: colors),
                ),
                // Pagination
                if (!vm.isLoading && vm.result.totalPages > 1)
                  _Pagination(vm: vm, colors: colors),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;
  final BondlyColorScheme colors;

  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: value != null ? colors.accent : colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: colors.textMuted)),
          style: GoogleFonts.montserrat(
              fontSize: 13, color: colors.textPrimary),
          dropdownColor: colors.surface,
          onChanged: onChanged,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text('Todos',
                  style: GoogleFonts.montserrat(
                      fontSize: 13, color: colors.textMuted)),
            ),
            ...items.entries.map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                )),
          ],
        ),
      ),
    );
  }
}

class _UsersTable extends StatelessWidget {
  final AdminUsersViewModel vm;
  final BondlyColorScheme colors;

  const _UsersTable({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Column headers
        _TableHeader(colors: colors),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.separated(
            itemCount: vm.result.items.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: colors.border),
            itemBuilder: (ctx, i) =>
                _UserRow(user: vm.result.items[i], vm: vm, colors: colors),
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  final BondlyColorScheme colors;

  const _TableHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 44),
          Expanded(
            flex: 3,
            child: _HeaderCell(StringsAdmin.colName, colors),
          ),
          Expanded(flex: 2, child: _HeaderCell(StringsAdmin.colRole, colors)),
          Expanded(
              flex: 1, child: _HeaderCell(StringsAdmin.colStatus, colors)),
          Expanded(
              flex: 2, child: _HeaderCell(StringsAdmin.colPoints, colors)),
          const SizedBox(width: 80),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final BondlyColorScheme colors;

  const _HeaderCell(this.text, this.colors);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textMuted));
  }
}

class _UserRow extends StatelessWidget {
  final AdminUser user;
  final AdminUsersViewModel vm;
  final BondlyColorScheme colors;

  const _UserRow(
      {required this.user, required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.accent),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          // Name + email
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.completeName ?? '—',
                  style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email,
                  style: GoogleFonts.montserrat(
                      fontSize: 11, color: colors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Role
          Expanded(
            flex: 2,
            child: _RoleChip(role: user.role, colors: colors),
          ),
          // Status
          Expanded(
            flex: 1,
            child: AdminStatusBadge(
              status: user.isActive
                  ? AdminStatusType.active
                  : AdminStatusType.inactive,
            ),
          ),
          // Points
          Expanded(
            flex: 2,
            child: Text(
              '${user.monthlyPoints} pts',
              style: GoogleFonts.montserrat(
                  fontSize: 12, color: colors.textSecondary),
            ),
          ),
          // Actions
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    user.isActive
                        ? LucideIcons.userX
                        : LucideIcons.userCheck,
                    size: 16,
                    color: user.isActive ? Colors.red : Colors.green,
                  ),
                  tooltip: user.isActive
                      ? StringsAdmin.deactivateUser
                      : StringsAdmin.activateUser,
                  onPressed: () => vm.toggleActive(user),
                ),
                IconButton(
                  icon: Icon(LucideIcons.moreVertical,
                      size: 16, color: colors.textMuted),
                  onPressed: () =>
                      _showUserMenu(context, user, vm, colors),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUserMenu(BuildContext context, AdminUser user,
      AdminUsersViewModel vm, BondlyColorScheme colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.completeName ?? user.email,
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(LucideIcons.shieldCheck,
                  color: colors.accent, size: 20),
              title: Text('Cambiar a Admin',
                  style: GoogleFonts.montserrat(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                vm.updateRole(user.id, 'admin');
              },
            ),
            ListTile(
              leading:
                  Icon(LucideIcons.user, color: colors.textMuted, size: 20),
              title: Text('Cambiar a Cliente',
                  style: GoogleFonts.montserrat(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                vm.updateRole(user.id, 'client');
              },
            ),
            ListTile(
              leading: Icon(
                  user.isActive ? LucideIcons.userX : LucideIcons.userCheck,
                  color: user.isActive ? Colors.red : Colors.green,
                  size: 20),
              title: Text(
                  user.isActive
                      ? StringsAdmin.deactivateUser
                      : StringsAdmin.activateUser,
                  style: GoogleFonts.montserrat(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                vm.toggleActive(user);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  final BondlyColorScheme colors;

  const _RoleChip({required this.role, required this.colors});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (role) {
      'superAdmin' => ('Super Admin', Colors.purple),
      'admin' => ('Admin', colors.accent),
      _ => ('Cliente', colors.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: GoogleFonts.montserrat(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _Pagination extends StatelessWidget {
  final AdminUsersViewModel vm;
  final BondlyColorScheme colors;

  const _Pagination({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(LucideIcons.chevronLeft, color: colors.textSecondary),
            onPressed:
                vm.result.hasPrevPage ? () => vm.setPage(vm.page - 1) : null,
          ),
          Text(
            '${vm.page} ${StringsAdmin.pageOf} ${vm.result.totalPages}',
            style: GoogleFonts.montserrat(
                fontSize: 13, color: colors.textSecondary),
          ),
          IconButton(
            icon: Icon(LucideIcons.chevronRight, color: colors.textSecondary),
            onPressed:
                vm.result.hasNextPage ? () => vm.setPage(vm.page + 1) : null,
          ),
        ],
      ),
    );
  }
}
