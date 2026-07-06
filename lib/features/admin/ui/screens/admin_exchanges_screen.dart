import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_exchanges_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_search_bar.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminExchangesScreen extends StatefulWidget {
  static const String route = '/admin/exchanges';

  const AdminExchangesScreen({super.key});

  @override
  State<AdminExchangesScreen> createState() => _AdminExchangesScreenState();
}

class _AdminExchangesScreenState extends State<AdminExchangesScreen> {
  late AdminExchangesViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminExchangesViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.manageRewards,
      child: ModelProvider<AdminExchangesViewModel>(
        model: _vm,
        child: ModelBuilder<AdminExchangesViewModel>(
          builder: (context, vm, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsAdmin.exchangesTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AdminSearchBar(
                        hint: 'Buscar por usuario o recompensa...',
                        onChanged: vm.onSearch,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusFilter(
                        value: vm.statusFilter,
                        colors: colors,
                        onChanged: vm.setStatusFilter),
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
                          : vm.exchanges.isEmpty
                              ? AdminEmptyState(
                                  icon: LucideIcons.shoppingBag,
                                  message: StringsAdmin.noExchangesFound)
                              : _ExchangesList(
                                  vm: vm, colors: colors),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  final String? value;
  final BondlyColorScheme colors;
  final ValueChanged<String?> onChanged;

  const _StatusFilter(
      {required this.value,
      required this.colors,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: value != null ? colors.accent : colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text('Estado',
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: colors.textMuted)),
          style: GoogleFonts.montserrat(
              fontSize: 13, color: colors.textPrimary),
          dropdownColor: colors.surface,
          onChanged: onChanged,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(StringsAdmin.all,
                  style: GoogleFonts.montserrat(
                      fontSize: 13, color: colors.textMuted)),
            ),
            ...const [
              'En espera',
              'Entregado',
              'Recibido',
              'Devolución'
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))),
          ],
        ),
      ),
    );
  }
}

class _ExchangesList extends StatelessWidget {
  final AdminExchangesViewModel vm;
  final BondlyColorScheme colors;

  const _ExchangesList({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: vm.exchanges.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
      itemBuilder: (ctx, i) {
        final e = vm.exchanges[i];
        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.userName ?? e.userEmail ?? '—',
                      style: GoogleFonts.montserrat(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      e.rewardName ?? '—',
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: colors.textMuted),
                    ),
                  ],
                ),
              ),
              if (e.code != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    e.code!,
                    style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: colors.textSecondary),
                  ),
                ),
              const SizedBox(width: 8),
              _StatusChip(status: e.status, colors: colors),
              const SizedBox(width: 8),
              if (e.createdAt != null)
                Text(
                  DateFormat('dd/MM/yy').format(e.createdAt!),
                  style: GoogleFonts.montserrat(
                      fontSize: 11, color: colors.textMuted),
                ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            icon:
                Icon(LucideIcons.moreVertical, size: 16, color: colors.textMuted),
            color: colors.surface,
            onSelected: (status) => vm.updateStatus(e, status),
            itemBuilder: (_) => const [
              'En espera',
              'Entregado',
              'Recibido',
              'Devolución'
            ]
                .map((s) => PopupMenuItem(
                      value: s,
                      child: Text(s),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final BondlyColorScheme colors;

  const _StatusChip({required this.status, required this.colors});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Entregado' => Colors.blue,
      'Recibido' => Colors.green,
      'Devolución' => Colors.red,
      _ => Colors.orange,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.montserrat(
            fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
