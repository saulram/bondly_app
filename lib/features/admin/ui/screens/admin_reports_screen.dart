import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/dashboard_stats.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_reports_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminReportsScreen extends StatefulWidget {
  static const String route = '/admin/reports';

  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  late AdminReportsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminReportsViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return AdminPermissionGuard(
      module: AdminModule.viewReports,
      child: ModelProvider<AdminReportsViewModel>(
        model: _vm,
        child: ModelBuilder<AdminReportsViewModel>(
          builder: (context, vm, _) => DefaultTabController(
            length: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        StringsAdmin.reportsTitle,
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      _MonthsDropdown(
                        value: vm.months,
                        colors: colors,
                        onChanged: vm.setMonths,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    labelStyle: GoogleFonts.montserrat(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        GoogleFonts.montserrat(fontSize: 13),
                    tabs: const [
                      Tab(text: StringsAdmin.reportsTabTrends),
                      Tab(text: StringsAdmin.reportsTabBadgeUsage),
                      Tab(text: StringsAdmin.reportsTabExchanges),
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
                            : TabBarView(
                                children: [
                                  _TrendsTab(vm: vm, colors: colors),
                                  _BadgeUsageTab(vm: vm, colors: colors),
                                  _ExchangesTab(vm: vm, colors: colors),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthsDropdown extends StatelessWidget {
  final int value;
  final BondlyColorScheme colors;
  final ValueChanged<int> onChanged;

  const _MonthsDropdown(
      {required this.value,
      required this.colors,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          dropdownColor: colors.surface,
          style: GoogleFonts.montserrat(
              fontSize: 13, color: colors.textPrimary),
          items: [3, 6, 12]
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text('$m ${StringsAdmin.monthsLabel}'),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ─── Tab 1: Trends ────────────────────────────────────────────────────────────

class _TrendsTab extends StatelessWidget {
  final AdminReportsViewModel vm;
  final BondlyColorScheme colors;

  const _TrendsTab({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Stat cards
          _StatRow(
            cards: [
              _StatCard(
                label: StringsAdmin.totalRecognitions,
                value: vm.totalRecognitions.toString(),
                icon: LucideIcons.heart,
                color: Colors.pink,
                colors: colors,
              ),
              _StatCard(
                label: StringsAdmin.avgPerMonth,
                value: vm.avgPerMonth.toStringAsFixed(1),
                icon: LucideIcons.trendingUp,
                color: Colors.blue,
                colors: colors,
              ),
              _StatCard(
                label: StringsAdmin.peakMonth,
                value: vm.peakMonth,
                icon: LucideIcons.star,
                color: Colors.amber,
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (vm.trends.isEmpty)
            AdminEmptyState(
                icon: LucideIcons.barChart2,
                message: StringsAdmin.noReportData)
          else
            _ChartCard(
              title: StringsAdmin.chartRecognitionTrends,
              colors: colors,
              child: SizedBox(
                height: 180,
                child: _TrendsBarChart(data: vm.trends, colors: colors),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Tab 2: Badge Usage ───────────────────────────────────────────────────────

class _BadgeUsageTab extends StatelessWidget {
  final AdminReportsViewModel vm;
  final BondlyColorScheme colors;

  const _BadgeUsageTab({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (vm.badgeStats.isEmpty) {
      return AdminEmptyState(
          icon: LucideIcons.award, message: StringsAdmin.noReportData);
    }
    final maxCount = vm.badgeStats
        .map((b) => b.usageCount)
        .reduce((a, b) => a > b ? a : b);

    return _ChartCard(
      title: StringsAdmin.chartBadgeUsage,
      colors: colors,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vm.badgeStats.take(10).length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final b = vm.badgeStats[i];
          final fraction = maxCount > 0 ? b.usageCount / maxCount : 0.0;
          return _HorizontalBar(
            label: b.badgeName,
            count: b.usageCount,
            fraction: fraction,
            color: _barColor(i),
            colors: colors,
          );
        },
      ),
    );
  }

  Color _barColor(int i) {
    const palette = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.green,
      Colors.amber,
      Colors.red,
      Colors.indigo,
      Colors.cyan,
    ];
    return palette[i % palette.length];
  }
}

class _HorizontalBar extends StatelessWidget {
  final String label;
  final int count;
  final double fraction;
  final Color color;
  final BondlyColorScheme colors;

  const _HorizontalBar({
    required this.label,
    required this.count,
    required this.fraction,
    required this.color,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
                fontSize: 12, color: colors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: fraction.clamp(0.0, 1.0),
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count.toString(),
          style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary),
        ),
      ],
    );
  }
}

// ─── Tab 3: Exchanges ─────────────────────────────────────────────────────────

class _ExchangesTab extends StatelessWidget {
  final AdminReportsViewModel vm;
  final BondlyColorScheme colors;

  const _ExchangesTab({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (vm.exchangeStats.isEmpty) {
      return AdminEmptyState(
          icon: LucideIcons.shoppingBag, message: StringsAdmin.noReportData);
    }
    final total = vm.exchangeStats.values.fold(0, (s, v) => s + v);

    return SingleChildScrollView(
      child: Column(
        children: [
          _StatRow(
            cards: [
              _StatCard(
                label: 'Total Canjes',
                value: total.toString(),
                icon: LucideIcons.shoppingBag,
                color: Colors.teal,
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ChartCard(
            title: 'Canjes por estado',
            colors: colors,
            child: Column(
              children: vm.exchangeStats.entries.map((entry) {
                final fraction = total > 0 ? entry.value / total : 0.0;
                final color = _statusColor(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _HorizontalBar(
                    label: entry.key,
                    count: entry.value,
                    fraction: fraction,
                    color: color,
                    colors: colors,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) => switch (status) {
        'Entregado' => Colors.blue,
        'Recibido' => Colors.green,
        'Devolución' => Colors.red,
        _ => Colors.orange,
      };
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final String title;
  final BondlyColorScheme colors;
  final Widget child;

  const _ChartCard(
      {required this.title, required this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingCard),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: colors.border),
        boxShadow: AppDimensions.cardShadow(colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final List<Widget> cards;

  const _StatRow({required this.cards});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: cards,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final BondlyColorScheme colors;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: colors.border),
        boxShadow: AppDimensions.cardShadow(colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.montserrat(
                fontSize: 11, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _TrendsBarChart extends StatelessWidget {
  final List<RecognitionTrendPoint> data;
  final BondlyColorScheme colors;

  const _TrendsBarChart({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();
    final maxVal = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return const SizedBox();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data
          .map((point) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        point.count.toString(),
                        style: GoogleFonts.montserrat(
                            fontSize: 10, color: colors.textMuted),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 140 * (point.count / maxVal),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colors.accentGradientStart,
                              colors.accentGradientEnd,
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        point.month.length >= 7
                            ? point.month.substring(5)
                            : point.month,
                        style: GoogleFonts.montserrat(
                            fontSize: 9, color: colors.textMuted),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
