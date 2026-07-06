import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_ranking.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/ranking/domain/models/ranked_user.dart';
import 'package:bondly_app/features/ranking/ui/viewmodels/ranking_viewmodel.dart';
import 'package:bondly_app/ui/shared/podium_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RankingScreen extends StatefulWidget {
  static const String route = '/rankingScreen';

  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late final RankingViewModel _viewModel;

  final List<String> _periods = [
    StringsRanking.periodMonth,
    StringsRanking.periodQuarter,
    StringsRanking.periodYear,
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<RankingViewModel>();
    _viewModel.setUp();
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider<RankingViewModel>(
      model: _viewModel,
      child: ModelBuilder<RankingViewModel>(
        builder: (context, model, child) {
          final colors = Theme.of(context).extension<BondlyColorScheme>()!;
          return _buildScreen(colors, model);
        },
      ),
    );
  }

  Widget _buildScreen(BondlyColorScheme colors, RankingViewModel model) {
    final topThree = model.topThree;
    final rest = model.rest;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colors),
            _buildPeriodTabs(colors, model),
            Expanded(
              child: model.loading
                  ? const Center(child: CircularProgressIndicator())
                  : topThree.length < 3 ||
                          topThree.any((u) => u.name.trim().isEmpty)
                      ? _buildEmptyState(colors)
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              PodiumWidget(
                                first: _toPodiumEntry(topThree[0]),
                                second: _toPodiumEntry(topThree[1]),
                                third: _toPodiumEntry(topThree[2]),
                              ),
                              const SizedBox(height: 16),
                              _buildRankingList(colors, rest),
                              _buildFooter(colors, model.users.length),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  PodiumEntry _toPodiumEntry(RankedUser user) {
    return PodiumEntry(
      name: user.name,
      avatarUrl: user.avatarUrl,
      count: user.recognitionCount,
      countLabel: StringsRanking.countLabel,
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────

  Widget _buildHeader(BondlyColorScheme colors) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingScreen,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.arrowLeft,
                  size: 18,
                  color: colors.textPrimary,
                ),
              ),
            ),
            Text(
              StringsRanking.ranking,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(width: 36),
          ],
        ),
      ),
    );
  }

  // ─── Period Tabs ─────────────────────────────────────────────────────

  Widget _buildPeriodTabs(BondlyColorScheme colors, RankingViewModel model) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingScreen,
        ),
        child: Row(
          children: List.generate(_periods.length, (index) {
            final isActive = model.selectedPeriod == index;
            return Padding(
              padding: EdgeInsets.only(
                right: index < _periods.length - 1
                    ? AppDimensions.spacingSm
                    : 0,
              ),
              child: GestureDetector(
                onTap: () => model.selectedPeriod = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    gradient: isActive
                        ? AppDimensions.accentGradient(colors)
                        : null,
                    color: isActive ? null : colors.surface,
                    border: isActive
                        ? null
                        : Border.all(color: colors.border, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      _periods[index],
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? BondlyColors.white
                            : colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Empty State ─────────────────────────────────────────────────────

  Widget _buildEmptyState(BondlyColorScheme colors) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.trophy, size: 48, color: colors.textMuted),
          const SizedBox(height: 16),
          Text(
            StringsRanking.emptyTitle,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            StringsRanking.emptyBody,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Ranking List ────────────────────────────────────────────────────

  Widget _buildRankingList(BondlyColorScheme colors, List<RankedUser> users) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
      ),
      child: Column(
        children: List.generate(users.length, (index) {
          final user = users[index];
          final isLast = index == users.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: isLast
                ? null
                : BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: colors.border, width: 1),
                    ),
                  ),
            child: Row(
              children: [
                // Position number
                SizedBox(
                  width: 24,
                  child: Text(
                    '${user.position}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Avatar
                _buildListAvatar(colors, user),
                const SizedBox(width: 12),
                // Name & department
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (user.department != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          user.department!,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Recognition count
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user.recognitionCount}',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      StringsRanking.countLabel,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildListAvatar(BondlyColorScheme colors, RankedUser user) {
    final hasAvatar = user.avatarUrl != null && user.avatarUrl!.isNotEmpty;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceElevated,
        border: Border.all(color: colors.border, width: 1),
      ),
      child: hasAvatar
          ? ClipOval(
              child: Image.network(
                user.avatarUrl!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  LucideIcons.user,
                  size: 20,
                  color: colors.textMuted,
                ),
              ),
            )
          : Icon(
              LucideIcons.user,
              size: 20,
              color: colors.textMuted,
            ),
    );
  }

  // ─── Footer ──────────────────────────────────────────────────────────

  Widget _buildFooter(BondlyColorScheme colors, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingLg,
        horizontal: AppDimensions.paddingScreen,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.info, size: 14, color: colors.textMuted),
          const SizedBox(width: 6),
          Text(
            StringsRanking.footerText(count),
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
