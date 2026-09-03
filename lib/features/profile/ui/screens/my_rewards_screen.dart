import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_cart.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/ai/ui/widgets/ai_recommendation_card.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/widgets/full_screen_image.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/ui/screens/shopping_cart_screen.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_rewards_viewmodel.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MyRewardsScreen extends StatefulWidget {
  static const String route = "/myRewardsScreen";

  const MyRewardsScreen({super.key});

  @override
  State<MyRewardsScreen> createState() => _MyRewardsScreenState();
}

class _MyRewardsScreenState extends State<MyRewardsScreen> {
  late MyRewardsViewModel model;
  int _selectedCategoryIndex = 0;
  bool _isSendingCart = false;

  @override
  void initState() {
    model = getIt<MyRewardsViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return ModelProvider<MyRewardsViewModel>(
      model: model,
      child: ModelBuilder<MyRewardsViewModel>(
        builder: (context, rewardsModel, child) {
          return Scaffold(
            backgroundColor: colors.bg,
            body: Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(rewardsModel, colors),
                    _buildCategoryTabs(rewardsModel, colors),
                    Expanded(
                      child: rewardsModel.busy
                          ? _buildSkeletonState(colors)
                          : _buildRewardsList(rewardsModel, colors),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: _buildCartFAB(rewardsModel, colors),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
  ) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingScreen,
          vertical: AppDimensions.spacingSm,
        ),
        child: Row(
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
                  size: 20,
                  color: colors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                StringsProfile.rewards,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (rewardsModel.userBalance != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppDimensions.accentGradient(colors),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Text(
                  '${rewardsModel.userBalance} ${StringsCart.pointsSuffix}',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
  ) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rewardsModel.rewardCategories.length,
        itemBuilder: (context, index) {
          final isActive = _selectedCategoryIndex == index;
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0
                  ? AppDimensions.paddingScreen
                  : AppDimensions.spacingSm,
              right: index == rewardsModel.rewardCategories.length - 1
                  ? AppDimensions.paddingScreen
                  : 0,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
                rewardsModel.filterByCategory(
                  rewardsModel.rewardCategories[index],
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient:
                      isActive ? AppDimensions.accentGradient(colors) : null,
                  color: isActive ? null : colors.surfaceElevated,
                  border: isActive
                      ? null
                      : Border.all(color: colors.border, width: 1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                alignment: Alignment.center,
                child: Text(
                  rewardsModel.rewardCategories[index],
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : colors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRewardsList(
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
  ) {
    final rewards = rewardsModel.rewardList.rewards!;

    if (rewards.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.gift, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              StringsCart.noRewardsAvailable,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.maxWidth - (AppDimensions.paddingScreen * 2);
        final crossAxisCount =
            availableWidth >= Constants.rewardsGridThreeColumns
                ? 3
                : availableWidth >= Constants.rewardsGridTwoColumns
                    ? 2
                    : 1;

        if (crossAxisCount == 1) {
          return _buildRewardsListView(rewards, rewardsModel, colors);
        }
        return _buildRewardsGridView(
          rewards,
          rewardsModel,
          colors,
          crossAxisCount,
          availableWidth,
        );
      },
    );
  }

  Widget _buildRewardsListView(
    List<Reward> rewards,
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        12,
        AppDimensions.paddingScreen,
        100,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: rewards.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildRecommendationsSection(rewardsModel, colors);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRewardCard(rewards[index - 1], rewardsModel, colors),
        );
      },
    );
  }

  Widget _buildRewardsGridView(
    List<Reward> rewards,
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
    int crossAxisCount,
    double availableWidth,
  ) {
    final totalSpacing = 16.0 * (crossAxisCount - 1);
    final cardWidth = (availableWidth - totalSpacing) / crossAxisCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        12,
        AppDimensions.paddingScreen,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecommendationsSection(rewardsModel, colors),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: rewards.map((reward) {
              return SizedBox(
                width: cardWidth,
                child: _buildRewardCard(reward, rewardsModel, colors),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
  ) {
    if (rewardsModel.loadingRecommendations) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Generando recomendaciones...',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: colors.accent,
              ),
            ),
          ],
        ),
      );
    }

    if (rewardsModel.recommendations.isEmpty) {
      return GestureDetector(
        onTap: () => rewardsModel.handleGetRecommendations(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: colors.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recomendaciones IA',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rewardsModel.recommendationsError ??
                          'Toca para generar sugerencias personalizadas',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: rewardsModel.recommendationsError == null
                            ? colors.textMuted
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 20, color: colors.accent),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 20,
                color: colors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'Recomendado para ti',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Basado en tu perfil y actividad',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: rewardsModel.recommendations.length,
            itemBuilder: (context, index) {
              final rec = rewardsModel.recommendations[index];
              final reward = rewardsModel.getRewardById(rec.rewardId);
              return AIRecommendationCard(
                recommendation: rec,
                reward: reward,
                onAddToCart: reward != null
                    ? () => _handleAddToCart(rewardsModel, reward.id)
                    : null,
              );
            },
          ),
        ),
        Divider(height: 24, color: colors.border),
      ],
    );
  }

  void _handleAddToCart(MyRewardsViewModel rewardsModel, String rewardId) {
    final added = rewardsModel.addToCart(rewardId);
    if (added) {
      rewardsModel.cartEdited = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringsCart.notEnoughPoints),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildRewardCard(
    Reward reward,
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
  ) {
    final itemCount = rewardsModel.getItemCount(reward.id);
    final canAfford = rewardsModel.canAffordItem(reward.id);
    final isAvailable = reward.enable && reward.visible;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: 1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppDimensions.cardShadow(colors.textPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  reward.enable == false
                      ? LucideIcons.lock
                      : LucideIcons.unlock,
                  size: 18,
                  color:
                      reward.enable == false ? colors.textMuted : colors.accent,
                ),
                itemCount == 0
                    ? GestureDetector(
                        onTap: isAvailable
                            ? () => _handleAddToCart(rewardsModel, reward.id)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? colors.accentSoft
                                : colors.surfaceElevated,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusPill,
                            ),
                          ),
                          child: Text(
                            isAvailable
                                ? StringsCart.selectItem
                                : StringsCart.unavailableItem,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isAvailable
                                  ? colors.accent
                                  : colors.textMuted,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              rewardsModel.cartEdited = true;
                              rewardsModel.removeFromCart(reward.id);
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: colors.surfaceElevated,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.minus,
                                size: 16,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Text(
                              '$itemCount',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: isAvailable
                                ? () =>
                                    _handleAddToCart(rewardsModel, reward.id)
                                : null,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: colors.surfaceElevated,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.plus,
                                size: 16,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),

          // Image section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      image: reward.image,
                      tag: reward.id,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: reward.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusCard - 4,
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: CachedNetworkImage(
                      imageUrl: safeImageUrl(reward.image),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const BondlyShimmerBlock(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 12,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: colors.surfaceElevated,
                        child: Icon(
                          LucideIcons.image,
                          size: 40,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Title + Points badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    reward.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: canAfford ? colors.accentSoft : Colors.red.shade50,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                  child: Text(
                    '${reward.points} ${StringsCart.pointsSuffix}',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: canAfford ? colors.accent : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: colors.border,
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              reward.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
            ),
          ),

          // Validity row
          if (reward.deadline != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: 14,
                    color: colors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${StringsCart.validityPrefix} ${reward.deadline!.day.toString().padLeft(2, '0')}/${reward.deadline!.month.toString().padLeft(2, '0')}/${reward.deadline!.year}',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSkeletonState(BondlyColorScheme colors) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        12,
        AppDimensions.paddingScreen,
        100,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BondlyShimmerBlock(
                width: double.infinity,
                height: 40,
                borderRadius: 8,
              ),
              SizedBox(height: 12),
              BondlyShimmerBlock(
                width: double.infinity,
                height: 160,
                borderRadius: 12,
              ),
              SizedBox(height: 12),
              BondlyShimmerBlock(
                width: 200,
                height: 16,
                borderRadius: 8,
              ),
              SizedBox(height: 8),
              BondlyShimmerBlock(
                width: double.infinity,
                height: 40,
                borderRadius: 8,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartFAB(
    MyRewardsViewModel rewardsModel,
    BondlyColorScheme colors,
  ) {
    return GestureDetector(
      onTap: () async {
        final navigator = GoRouter.of(context);
        if (!rewardsModel.cartEdited) {
          navigator.push(MyCartScreen.route);
          return;
        }
        setState(() {
          _isSendingCart = true;
        });
        await rewardsModel.sendItemsToCart();
        if (!mounted) return;
        setState(() {
          _isSendingCart = false;
        });
        navigator.push(MyCartScreen.route);
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppDimensions.accentGradient(colors),
          shape: BoxShape.circle,
          boxShadow: AppDimensions.cardShadow(colors.textPrimary),
        ),
        child: Center(
          child: _isSendingCart
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      LucideIcons.shoppingCart,
                      size: 24,
                      color: Colors.white,
                    ),
                    if (rewardsModel.cartItems.isNotEmpty)
                      Positioned(
                        top: -6,
                        right: -8,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: colors.accentGradientEnd,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${rewardsModel.cartItems.length}',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
