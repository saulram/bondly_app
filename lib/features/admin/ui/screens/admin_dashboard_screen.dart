import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/domain/models/dashboard_stats.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_dashboard_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_quick_action_card.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_stat_card.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminDashboardScreen extends StatefulWidget {
  static const String route = '/admin';

  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late AdminDashboardViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = getIt<AdminDashboardViewModel>();
    _vm.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return ModelProvider<AdminDashboardViewModel>(
      model: _vm,
      child: ModelBuilder<AdminDashboardViewModel>(
        builder: (context, vm, _) {
          return switch (vm.state) {
            AdminDashboardLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            AdminDashboardError(message: final msg) => AdminEmptyState(
                icon: LucideIcons.alertCircle,
                message: msg,
                ctaLabel: 'Reintentar',
                onCta: vm.load,
              ),
            AdminDashboardLoaded(
              stats: final stats,
              trends: final trends,
              badgeStats: final badges,
            ) =>
              _DashboardContent(
                stats: stats,
                trends: trends,
                badgeStats: badges,
                colors: colors,
                vm: vm,
              ),
          };
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardStats stats;
  final List<RecognitionTrendPoint> trends;
  final List<BadgeUsageStat> badgeStats;
  final BondlyColorScheme colors;
  final AdminDashboardViewModel vm;

  const _DashboardContent({
    required this.stats,
    required this.trends,
    required this.badgeStats,
    required this.colors,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingScreen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringsAdmin.dashboardTitle,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          // Stats grid
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth > 800
                ? 4
                : constraints.maxWidth > 500
                    ? 2
                    : 1;
            return _StatsGrid(stats: stats, columns: columns);
          }),
          const SizedBox(height: 28),
          // Quick Actions
          Text(
            StringsAdmin.quickActions,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _QuickActionsRow(context: context),
          const SizedBox(height: 28),
          // Charts row
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _TrendsCard(
                        trends: trends, colors: colors),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child:
                        _BadgeUsageCard(badges: badgeStats, colors: colors),
                  ),
                ],
              );
            }
            return Column(
              children: [
                _TrendsCard(trends: trends, colors: colors),
                const SizedBox(height: 16),
                _BadgeUsageCard(badges: badgeStats, colors: colors),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DashboardStats stats;
  final int columns;

  const _StatsGrid({required this.stats, required this.columns});

  @override
  Widget build(BuildContext context) {
    final cards = [
      AdminStatCard(
        icon: LucideIcons.users,
        label: StringsAdmin.statTotalUsers,
        value: stats.totalUsers.toString(),
        iconColor: Colors.blue,
      ),
      AdminStatCard(
        icon: LucideIcons.userCheck,
        label: StringsAdmin.statActiveUsers,
        value: stats.activeUsers.toString(),
        iconColor: Colors.green,
      ),
      AdminStatCard(
        icon: LucideIcons.heart,
        label: StringsAdmin.statMonthRecognitions,
        value: stats.monthRecognitions.toString(),
        iconColor: Colors.pink,
      ),
      AdminStatCard(
        icon: LucideIcons.shoppingBag,
        label: StringsAdmin.statMonthExchanges,
        value: stats.monthExchanges.toString(),
        iconColor: Colors.orange,
      ),
      AdminStatCard(
        icon: LucideIcons.coins,
        label: StringsAdmin.statPointsCirculating,
        value: _formatNumber(stats.pointsCirculating),
        iconColor: Colors.amber,
      ),
      AdminStatCard(
        icon: LucideIcons.award,
        label: StringsAdmin.statActiveBadges,
        value: stats.activeBadges.toString(),
        iconColor: Colors.purple,
      ),
      AdminStatCard(
        icon: LucideIcons.gift,
        label: StringsAdmin.statActiveRewards,
        value: stats.activeRewards.toString(),
        iconColor: Colors.teal,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) => cards[i],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _QuickActionsRow extends StatelessWidget {
  final BuildContext context;

  const _QuickActionsRow({required this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminQuickActionCard(
            icon: LucideIcons.userPlus,
            label: StringsAdmin.quickAddUser,
            color: Colors.blue,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AdminQuickActionCard(
            icon: LucideIcons.award,
            label: StringsAdmin.quickCreateBadge,
            color: Colors.purple,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AdminQuickActionCard(
            icon: LucideIcons.gift,
            label: StringsAdmin.quickNewReward,
            color: Colors.teal,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AdminQuickActionCard(
            icon: LucideIcons.barChart2,
            label: StringsAdmin.quickViewReports,
            color: Colors.orange,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _TrendsCard extends StatelessWidget {
  final List<RecognitionTrendPoint> trends;
  final BondlyColorScheme colors;

  const _TrendsCard({required this.trends, required this.colors});

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
            StringsAdmin.chartRecognitionTrends,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (trends.isEmpty)
            SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  StringsAdmin.noReportData,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: colors.textMuted,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 160,
              child: _SimpleBarChart(data: trends, colors: colors),
            ),
        ],
      ),
    );
  }
}

class _BadgeUsageCard extends StatelessWidget {
  final List<BadgeUsageStat> badges;
  final BondlyColorScheme colors;

  const _BadgeUsageCard({required this.badges, required this.colors});

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
            StringsAdmin.chartBadgeUsage,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (badges.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  StringsAdmin.noReportData,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: colors.textMuted,
                  ),
                ),
              ),
            )
          else
            ...badges.take(5).map((b) => _BadgeRow(badge: b, colors: colors)),
        ],
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  final BadgeUsageStat badge;
  final BondlyColorScheme colors;

  const _BadgeRow({required this.badge, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              badge.badgeName,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: colors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            badge.usageCount.toString(),
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple custom bar chart (no dependency needed for Phase 1)
class _SimpleBarChart extends StatelessWidget {
  final List<RecognitionTrendPoint> data;
  final BondlyColorScheme colors;

  const _SimpleBarChart({required this.data, required this.colors});

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
                          fontSize: 10,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 120 * (point.count / maxVal),
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
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        point.month.length >= 7
                            ? point.month.substring(5)
                            : point.month,
                        style: GoogleFonts.montserrat(
                          fontSize: 9,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
