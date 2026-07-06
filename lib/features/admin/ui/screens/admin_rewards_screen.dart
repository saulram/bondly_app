import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_reward.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_rewards_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_status_badge.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminRewardsScreen extends StatefulWidget {
  static const String route = '/admin/rewards';

  const AdminRewardsScreen({super.key});

  @override
  State<AdminRewardsScreen> createState() => _AdminRewardsScreenState();
}

class _AdminRewardsScreenState extends State<AdminRewardsScreen> {
  late AdminRewardsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminRewardsViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageRewards,
      child: ModelProvider<AdminRewardsViewModel>(
        model: _vm,
        child: ModelBuilder<AdminRewardsViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      StringsAdmin.rewardsTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () =>
                          _showRewardDialog(context, vm, colors),
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text(StringsAdmin.addReward),
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
                          : vm.rewards.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.gift,
                                  message: StringsAdmin.noRewardsFound,
                                  ctaLabel: StringsAdmin.addReward,
                                  onCta: () => _showRewardDialog(
                                      context, vm, colors))
                              : _RewardsList(
                                  vm: vm,
                                  colors: colors,
                                  onEdit: (r) => _showRewardDialog(
                                      context, vm, colors,
                                      reward: r)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRewardDialog(
      BuildContext context, AdminRewardsViewModel vm, BondlyColorScheme colors,
      {AdminReward? reward}) {
    final nameCtrl = TextEditingController(text: reward?.name);
    final descCtrl = TextEditingController(text: reward?.description);
    final catCtrl = TextEditingController(text: reward?.category);
    final ptsCtrl =
        TextEditingController(text: reward?.points.toString() ?? '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          reward == null ? StringsAdmin.addReward : StringsAdmin.editReward,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                    labelText: StringsAdmin.rewardName,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: StringsAdmin.rewardDescription,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: catCtrl,
                decoration: InputDecoration(
                    labelText: StringsAdmin.rewardCategory,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ptsCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: StringsAdmin.rewardPoints,
                    border: const OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              final pts = int.tryParse(ptsCtrl.text) ?? 0;
              bool ok;
              if (reward == null) {
                ok = await vm.createReward(
                  name: nameCtrl.text,
                  description: descCtrl.text.isEmpty ? null : descCtrl.text,
                  category: catCtrl.text.isEmpty ? null : catCtrl.text,
                  points: pts,
                );
              } else {
                ok = await vm.updateReward(
                  rewardId: reward.id,
                  name: nameCtrl.text,
                  description: descCtrl.text.isEmpty ? null : descCtrl.text,
                  category: catCtrl.text.isEmpty ? null : catCtrl.text,
                  points: pts,
                );
              }
              if (ok && ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text(StringsAdmin.save),
          ),
        ],
      ),
    );
  }
}

class _RewardsList extends StatelessWidget {
  final AdminRewardsViewModel vm;
  final BondlyColorScheme colors;
  final ValueChanged<AdminReward> onEdit;

  const _RewardsList(
      {required this.vm, required this.colors, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: vm.rewards.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
      itemBuilder: (ctx, i) {
        final r = vm.rewards[i];
        return ListTile(
          leading: r.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(r.image!,
                      width: 44, height: 44, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(LucideIcons.gift, color: colors.accent)))
              : Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: colors.accentSoft,
                      borderRadius: BorderRadius.circular(8)),
                  child:
                      Icon(LucideIcons.gift, color: colors.accent)),
          title: Text(r.name,
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text(
            '${r.category ?? "—"} · ${r.points} pts',
            style:
                GoogleFonts.montserrat(fontSize: 12, color: colors.textMuted),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminStatusBadge(
                  status: r.enable
                      ? AdminStatusType.active
                      : AdminStatusType.inactive,
                  customLabel:
                      r.enable ? 'Habilitada' : 'Deshabilitada'),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(LucideIcons.pencil,
                    size: 16, color: colors.textMuted),
                onPressed: () => onEdit(r),
              ),
              IconButton(
                icon: Icon(
                    r.enable ? LucideIcons.eyeOff : LucideIcons.eye,
                    size: 16,
                    color: r.enable ? Colors.orange : Colors.green),
                onPressed: () => vm.toggleEnable(r),
              ),
              IconButton(
                icon: Icon(LucideIcons.trash2,
                    size: 16, color: Colors.red.shade400),
                onPressed: () => _confirmDelete(ctx, r),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AdminReward r) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(StringsAdmin.confirmDeleteTitle,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Text('¿Eliminar "${r.name}"?',
            style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(StringsAdmin.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              vm.deleteReward(r.id);
            },
            child: const Text(StringsAdmin.delete),
          ),
        ],
      ),
    );
  }
}
