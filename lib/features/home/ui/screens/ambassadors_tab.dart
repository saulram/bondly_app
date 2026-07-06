import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/config/strings_ranking.dart';
import 'package:bondly_app/features/home/domain/models/badge_model.dart';
import 'package:bondly_app/features/home/domain/models/company_categories.dart';
import 'package:bondly_app/features/home/domain/models/embassys_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/ranking/ui/screens/ranking_screen.dart';
import 'package:bondly_app/ui/shared/badge_card.dart';
import 'package:bondly_app/ui/shared/badge_icon_button.dart' show BadgeType;
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:bondly_app/ui/shared/podium_widget.dart';
import 'package:bondly_app/ui/shared/slider_banner_card.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AmbassadorsTab extends StatefulWidget {
  final HomeViewModel model;
  const AmbassadorsTab({super.key, required this.model});

  @override
  State<AmbassadorsTab> createState() => _AmbassadorsTabState();
}

class _AmbassadorsTabState extends State<AmbassadorsTab> {
  HomeViewModel get model => widget.model;

  bool get _isLoading => model.user == null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    if (_isLoading) return _buildSkeletonState(colors);

    final showRanking = model.isRankingEnabled;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSliderSection(),
          const SizedBox(height: 16),
          if (showRanking) ...[
            _buildRankingSection(colors),
            const SizedBox(height: 16),
          ],
          _buildBadgesSection(colors),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ─── Skeleton Loading State ───────────────────────────────────────────

  Widget _buildSkeletonState(BondlyColorScheme colors) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingScreen,
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Slider placeholder
            const BondlyShimmerBlock(
              width: double.infinity,
              height: 180,
              borderRadius: 20,
            ),
            const SizedBox(height: 16),
            // Ranking section skeleton (only when ranking is enabled)
            if (model.isRankingEnabled) ...[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BondlyShimmerBlock(width: 100, height: 20),
                  BondlyShimmerBlock(width: 60, height: 14),
                ],
              ),
              const SizedBox(height: 12),
              const BondlyShimmerBlock(
                width: double.infinity,
                height: 220,
                borderRadius: 8,
              ),
              const SizedBox(height: 16),
            ],
            // Section header placeholder
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BondlyShimmerBlock(width: 120, height: 20),
                BondlyShimmerBlock(
                  width: 80,
                  height: 24,
                  borderRadius: 10,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Grid placeholder (2x3)
            for (var i = 0; i < 3; i++) ...[
              Row(
                children: [
                  Expanded(child: _buildBadgeCardSkeleton(colors)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildBadgeCardSkeleton(colors)),
                ],
              ),
              if (i < 2) const SizedBox(height: 12),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCardSkeleton(BondlyColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: const Column(
        children: [
          SizedBox(height: 80, child: Center(child: BondlyShimmerCircle(size: 52))),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                BondlyShimmerBlock(width: 80, height: 13),
                SizedBox(height: 6),
                BondlyShimmerBlock(width: 60, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Slider Section ───────────────────────────────────────────────────

  Widget _buildSliderSection() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        8,
        AppDimensions.paddingScreen,
        0,
      ),
      child: SliderBannerCard(
        items: [
          BannerItem(
            tag: StringsHome.bannerTag1,
            title: StringsHome.bannerTitle1,
            subtitle: StringsHome.bannerSubtitle1,
          ),
          BannerItem(
            tag: StringsHome.bannerTag2,
            title: StringsHome.bannerTitle2,
            subtitle: StringsHome.bannerSubtitle2,
          ),
          BannerItem(
            title: StringsHome.bannerTitle3,
            subtitle: StringsHome.bannerSubtitle3,
          ),
        ],
      ),
    );
  }

  // ─── Ranking Section ─────────────────────────────────────────────────

  PodiumEntry _toPodiumEntry(dynamic user) {
    return PodiumEntry(
      name: user.name,
      avatarUrl: user.avatarUrl,
      count: user.recognitionCount,
      countLabel: StringsRanking.countLabel,
    );
  }

  Widget _buildRankingSection(BondlyColorScheme colors) {
    final ranking = model.rankingUsers;

    final hasValidPodium = ranking.length >= 3 &&
        ranking.take(3).every((u) => u.name.trim().isNotEmpty);
    if (!hasValidPodium) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingScreen,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringsRanking.title,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.push(RankingScreen.route),
                child: Text(
                  StringsRanking.seeAll,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Podium widget
        PodiumWidget(
          first: _toPodiumEntry(ranking[0]),
          second: _toPodiumEntry(ranking[1]),
          third: _toPodiumEntry(ranking[2]),
        ),
      ],
    );
  }

  // ─── Badges Section ───────────────────────────────────────────────────

  Widget _buildBadgesSection(BondlyColorScheme colors) {
    final embassies = model.embassys;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
      ),
      child: Column(
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringsHome.embassySectionTitle,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  StringsHome.badgeCount(embassies.length),
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Grid or empty state
          embassies.isEmpty
              ? _buildEmptyState(colors)
              : _buildBadgeGrid(embassies),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BondlyColorScheme colors) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.trophy, size: 48, color: colors.textMuted),
            const SizedBox(height: 16),
            Text(
              StringsHome.embassyEmptyTitle,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              StringsHome.embassyEmptyBody,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Badge Grid (2 columns) ───────────────────────────────────────────

  Widget _buildBadgeGrid(List<Embassy> embassies) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: embassies.length,
      itemBuilder: (context, index) {
        return _buildBadgeCardFromEmbassy(embassies[index]);
      },
    );
  }

  Widget _buildBadgeCardFromEmbassy(Embassy embassy) {
    final badge = embassy.badgeId;
    final badgeType = _resolveBadgeType(badge);
    final gradientColors = _gradientColorsForType(badgeType);
    final icon = _iconForType(badgeType);
    final categoryLabel = _categoryLabelForType(badgeType);

    return BadgeCard(
      name: badge?.name ?? '',
      categoryLabel: categoryLabel,
      gradientColors: gradientColors,
      icon: icon,
      imageUrl: badge?.image,
      onTap: () {
        // TODO(BONDLY): Navigate to badge detail screen
      },
    );
  }

  // ─── Category Helpers ─────────────────────────────────────────────────

  Map<String, Category>? _categoryLookup;

  Map<String, Category> _getCategoryLookup() {
    if (_categoryLookup != null) return _categoryLookup!;
    final categories = model.categories.categories ?? [];
    _categoryLookup = {
      for (final cat in categories)
        if (cat.id != null) cat.id!: cat,
    };
    return _categoryLookup!;
  }

  BadgeType _resolveBadgeType(Badge? badge) {
    if (badge?.categoryId == null) return BadgeType.competencias;

    final lookup = _getCategoryLookup();
    final matchedCategory = lookup[badge!.categoryId];

    if (matchedCategory != null) {
      final name =
          (matchedCategory.name ?? matchedCategory.type ?? '').toLowerCase();
      if (name.contains('especial')) return BadgeType.especiales;
      if (name.contains('valor') || name.contains('embajada')) {
        return BadgeType.valores;
      }
    }

    return BadgeType.competencias;
  }

  static List<Color> _gradientColorsForType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return const [
          BondlyColors.badgeCompetenciasStart,
          BondlyColors.badgeCompetenciasEnd,
        ];
      case BadgeType.especiales:
        return const [
          BondlyColors.badgeEspecialesStart,
          BondlyColors.badgeEspecialesEnd,
        ];
      case BadgeType.valores:
        return const [
          BondlyColors.badgeValoresStart,
          BondlyColors.badgeValoresEnd,
        ];
    }
  }

  static IconData _iconForType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return LucideIcons.award;
      case BadgeType.especiales:
        return LucideIcons.star;
      case BadgeType.valores:
        return LucideIcons.heart;
    }
  }

  static String _categoryLabelForType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return StringsHome.badgeCompetencias;
      case BadgeType.especiales:
        return StringsHome.badgeEspeciales;
      case BadgeType.valores:
        return StringsHome.badgeValores;
    }
  }
}
