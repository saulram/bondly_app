import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_badge.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_badges_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_status_badge.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminBadgesScreen extends StatefulWidget {
  static const String route = '/admin/badges';

  const AdminBadgesScreen({super.key});

  @override
  State<AdminBadgesScreen> createState() => _AdminBadgesScreenState();
}

class _AdminBadgesScreenState extends State<AdminBadgesScreen>
    with SingleTickerProviderStateMixin {
  late AdminBadgesViewModel _vm;
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminBadgesViewModel>();
    _tab = TabController(length: 2, vsync: this);
    _vm.load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageBadges,
      child: ModelProvider<AdminBadgesViewModel>(
        model: _vm,
        child: ModelBuilder<AdminBadgesViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      StringsAdmin.badgesTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => _showBadgeDialog(context, vm, colors),
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text(StringsAdmin.addBadge),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tab,
                  labelStyle: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600, fontSize: 13),
                  unselectedLabelStyle:
                      GoogleFonts.montserrat(fontSize: 13),
                  tabs: const [
                    Tab(text: StringsAdmin.badgesTab),
                    Tab(text: StringsAdmin.categoriesTab),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.error != null
                          ? AdminEmptyState(
                              icon: LucideIcons.alertCircle,
                              message: vm.error!,
                              ctaLabel: 'Reintentar',
                              onCta: vm.load)
                          : TabBarView(
                              controller: _tab,
                              children: [
                                _BadgesList(
                                    vm: vm,
                                    colors: colors,
                                    onEdit: (b) => _showBadgeDialog(
                                        context, vm, colors,
                                        badge: b)),
                                _CategoriesList(
                                    categories: vm.categories,
                                    colors: colors),
                              ],
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBadgeDialog(
      BuildContext context, AdminBadgesViewModel vm, BondlyColorScheme colors,
      {AdminBadge? badge}) {
    final nameCtrl = TextEditingController(text: badge?.name);
    final valueCtrl =
        TextEditingController(text: badge?.value.toString() ?? '0');
    String? selectedCategory = badge?.categoryId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: colors.surface,
          title: Text(
            badge == null ? StringsAdmin.addBadge : StringsAdmin.editBadge,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                      labelText: StringsAdmin.badgeName,
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                      labelText: StringsAdmin.badgeCategory,
                      border: const OutlineInputBorder()),
                  dropdownColor: colors.surface,
                  items: vm.categories
                      .map((c) => DropdownMenuItem(
                          value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategory = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: valueCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: StringsAdmin.badgeValue,
                      border: const OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(StringsAdmin.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty || selectedCategory == null) return;
                final value = int.tryParse(valueCtrl.text) ?? 0;
                bool ok;
                if (badge == null) {
                  ok = await vm.createBadge(
                    categoryId: selectedCategory!,
                    name: nameCtrl.text,
                    value: value,
                  );
                } else {
                  ok = await vm.updateBadge(
                    badgeId: badge.id,
                    name: nameCtrl.text,
                    value: value,
                    categoryId: selectedCategory!,
                  );
                }
                if (ok && ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text(StringsAdmin.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgesList extends StatelessWidget {
  final AdminBadgesViewModel vm;
  final BondlyColorScheme colors;
  final ValueChanged<AdminBadge> onEdit;

  const _BadgesList(
      {required this.vm, required this.colors, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    if (vm.badges.isEmpty) {
      return AdminEmptyState(
          icon: LucideIcons.award, message: StringsAdmin.noBadgesFound);
    }
    return ListView.separated(
      itemCount: vm.badges.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
      itemBuilder: (ctx, i) {
        final b = vm.badges[i];
        return ListTile(
          leading: b.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(b.image!,
                      width: 40, height: 40, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(LucideIcons.award, color: colors.accent)),
                )
              : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.accentSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(LucideIcons.award, color: colors.accent)),
          title: Text(b.name,
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text(
              '${b.categoryName ?? "—"} · ${b.value} pts',
              style: GoogleFonts.montserrat(
                  fontSize: 12, color: colors.textMuted)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminStatusBadge(
                status: b.isActive
                    ? AdminStatusType.active
                    : AdminStatusType.inactive,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(LucideIcons.pencil,
                    size: 16, color: colors.textMuted),
                onPressed: () => onEdit(b),
              ),
              IconButton(
                icon: Icon(
                  b.isActive ? LucideIcons.eyeOff : LucideIcons.eye,
                  size: 16,
                  color: b.isActive ? Colors.orange : Colors.green,
                ),
                onPressed: () => vm.toggleActive(b),
              ),
              IconButton(
                icon: Icon(LucideIcons.trash2,
                    size: 16, color: Colors.red.shade400),
                onPressed: () => _confirmDelete(ctx, b, vm, colors),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AdminBadge b,
      AdminBadgesViewModel vm, BondlyColorScheme colors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.confirmDeleteTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Text('¿Eliminar "${b.name}"?',
            style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              vm.deleteBadge(b.id);
            },
            child: const Text(StringsAdmin.delete),
          ),
        ],
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  final List<AdminBadgeCategory> categories;
  final BondlyColorScheme colors;

  const _CategoriesList(
      {required this.categories, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return AdminEmptyState(
          icon: LucideIcons.tag,
          message: 'No hay categorías registradas');
    }
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final c = categories[i];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(LucideIcons.tag, color: colors.accent, size: 20),
          ),
          title: Text(c.name,
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: c.description != null
              ? Text(c.description!,
                  style: GoogleFonts.montserrat(
                      fontSize: 12, color: colors.textMuted))
              : null,
          trailing: AdminStatusBadge(
            status: c.visible
                ? AdminStatusType.active
                : AdminStatusType.inactive,
          ),
        );
      },
    );
  }
}
