import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/ui/shared/badge_icon_button.dart';
import 'package:bondly_app/ui/shared/info_card.dart';
import 'package:bondly_app/ui/shared/points_card.dart';
import 'package:bondly_app/ui/shared/slider_banner_card.dart';
import 'package:bondly_app/ui/shared/slider_dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RecognizeTab extends StatelessWidget {
  final HomeViewModel model;
  const RecognizeTab({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSliderSection(),
          _buildAvisosSection(colors),
          _buildPointsSection(),
          const SizedBox(height: 20),
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

  // ─── Avisos Section ───────────────────────────────────────────────────

  Widget _buildAvisosSection(BondlyColorScheme colors) {
    final hasAnnouncements = model.announcements.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        12,
        AppDimensions.paddingScreen,
        0,
      ),
      child: InfoCard(
        icon: LucideIcons.megaphone,
        title: StringsHome.announcementTitle,
        body: hasAnnouncements
            ? model.announcements[model.currentAnnouncementIndex].content ?? ''
            : StringsHome.announcementDefaultBody,
        footer: hasAnnouncements && model.announcements.length > 1
            ? Center(
                child: SliderDotsIndicator(
                  count: model.announcements.length,
                  activeIndex: model.currentAnnouncementIndex,
                  activeColor: colors.accent,
                  inactiveColor: colors.border,
                ),
              )
            : null,
      ),
    );
  }

  // ─── Points Section ───────────────────────────────────────────────────

  Widget _buildPointsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        16,
        AppDimensions.paddingScreen,
        0,
      ),
      child: PointsCard(
        value: model.user?.giftedPoints.toString() ?? '0',
        valueLabel: StringsHome.pointsLabel,
        description: StringsHome.pointsDescription,
        subtitle: StringsHome.badgePickSubtitle,
        badges: [
          BadgeIconButton(
            type: BadgeType.competencias,
            label: StringsHome.badgeCompetencias,
            onTap: () => _onBadgeTap(0),
          ),
          BadgeIconButton(
            type: BadgeType.especiales,
            label: StringsHome.badgeEspeciales,
            onTap: () => _onBadgeTap(1),
          ),
          BadgeIconButton(
            type: BadgeType.valores,
            label: StringsHome.badgeValores,
            onTap: () => _onBadgeTap(2),
          ),
        ],
      ),
    );
  }

  void _onBadgeTap(int categoryIndex) {
    final categories = model.categories.categories;
    if (categories != null && categoryIndex < categories.length) {
      model.selectedCategory = categories[categoryIndex].id;
    }
  }
}
