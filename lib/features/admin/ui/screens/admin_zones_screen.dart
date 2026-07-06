import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/zone.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_zones_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_status_badge.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminZonesScreen extends StatefulWidget {
  static const String route = '/admin/settings/zones';

  const AdminZonesScreen({super.key});

  @override
  State<AdminZonesScreen> createState() => _AdminZonesScreenState();
}

class _AdminZonesScreenState extends State<AdminZonesScreen> {
  late AdminZonesViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminZonesViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageZones,
      child: ModelProvider<AdminZonesViewModel>(
        model: _vm,
        child: ModelBuilder<AdminZonesViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      StringsAdmin.zonesTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () =>
                          _showZoneDialog(context, vm, colors),
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text(StringsAdmin.newZone),
                    ),
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
                              ctaLabel: StringsAdmin.retry,
                              onCta: vm.load)
                          : vm.zones.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.mapPin,
                                  message: StringsAdmin.noZonesFound,
                                  ctaLabel: StringsAdmin.newZone,
                                  onCta: () =>
                                      _showZoneDialog(context, vm, colors),
                                )
                              : _ZonesList(
                                  vm: vm,
                                  colors: colors,
                                  onEdit: (z) =>
                                      _showZoneDialog(context, vm, colors,
                                          zone: z),
                                  onDelete: (z) =>
                                      _confirmDelete(context, vm, colors, z),
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showZoneDialog(
      BuildContext context, AdminZonesViewModel vm, BondlyColorScheme colors,
      {Zone? zone}) {
    final nameCtrl = TextEditingController(text: zone?.name);
    final descCtrl = TextEditingController(text: zone?.description);
    String? selectedParentId = zone?.parentZoneId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: colors.surface,
          title: Text(
            zone == null ? StringsAdmin.newZone : StringsAdmin.editZone,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: (MediaQuery.of(context).size.width - 32).clamp(0.0, 480.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: StringsAdmin.zoneName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: StringsAdmin.zoneDescription,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  initialValue: selectedParentId,
                  decoration: InputDecoration(
                    labelText: StringsAdmin.parentZone,
                    border: const OutlineInputBorder(),
                  ),
                  dropdownColor: colors.surface,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Sin zona padre',
                          style: GoogleFonts.montserrat(
                              fontSize: 13, color: colors.textMuted)),
                    ),
                    ...vm.zones
                        .where((z) => z.id != zone?.id)
                        .map((z) => DropdownMenuItem<String?>(
                              value: z.id,
                              child: Text(z.name),
                            )),
                  ],
                  onChanged: (v) =>
                      setDialogState(() => selectedParentId = v),
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
                if (nameCtrl.text.isEmpty) return;
                bool ok;
                if (zone == null) {
                  ok = await vm.createZone(
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.isEmpty
                        ? null
                        : descCtrl.text.trim(),
                    parentZoneId: selectedParentId,
                  );
                } else {
                  ok = await vm.updateZone(
                    zoneId: zone.id,
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.isEmpty
                        ? null
                        : descCtrl.text.trim(),
                    parentZoneId: selectedParentId,
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

  void _confirmDelete(BuildContext context, AdminZonesViewModel vm,
      BondlyColorScheme colors, Zone zone) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.confirmDeleteTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Text('¿Eliminar zona "${zone.name}"?',
            style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(StringsAdmin.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              vm.deleteZone(zone.id);
            },
            child: const Text(StringsAdmin.delete),
          ),
        ],
      ),
    );
  }
}

class _ZonesList extends StatelessWidget {
  final AdminZonesViewModel vm;
  final BondlyColorScheme colors;
  final ValueChanged<Zone> onEdit;
  final ValueChanged<Zone> onDelete;

  const _ZonesList({
    required this.vm,
    required this.colors,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: vm.zones.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
      itemBuilder: (ctx, i) {
        final z = vm.zones[i];
        final userCount = vm.userCountForZone(z.id);
        return ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                Icon(LucideIcons.mapPin, color: colors.accent, size: 20),
          ),
          title: Text(
            z.name,
            style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: z.description != null
              ? Text(
                  z.description!,
                  style: GoogleFonts.montserrat(
                      fontSize: 12, color: colors.textMuted),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$userCount ${StringsAdmin.zoneUsers}',
                  style: GoogleFonts.montserrat(
                      fontSize: 11, color: colors.textSecondary),
                ),
              ),
              const SizedBox(width: 4),
              AdminStatusBadge(
                status: z.isActive
                    ? AdminStatusType.active
                    : AdminStatusType.inactive,
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(LucideIcons.pencil,
                    size: 16, color: colors.textMuted),
                onPressed: () => onEdit(z),
              ),
              IconButton(
                icon: Icon(LucideIcons.trash2,
                    size: 16, color: Colors.red.shade400),
                onPressed: () => onDelete(z),
              ),
            ],
          ),
        );
      },
    );
  }
}
