import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/ui/screens/activity_detail_screen.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_activity_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/widgets/user_activity_item.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MyActivityScreen extends StatefulWidget {
  static const String route = "/myActivityScreen";

  const MyActivityScreen({super.key});

  @override
  State<MyActivityScreen> createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen>
    with AutomaticKeepAliveClientMixin<MyActivityScreen> {
  late MyActivityViewModel _viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<MyActivityViewModel>();
    _viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return ModelProvider<MyActivityViewModel>(
      model: _viewModel,
      child: ModelBuilder<MyActivityViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: colors.bg,
            body: Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(colors),
                    Expanded(
                      child: _buildContent(model, colors),
                    ),
                  ],
                ),
                if (!model.errorShown &&
                    model.notificationMessage.isNotEmpty)
                  _buildNotificationToast(model, colors),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BondlyColorScheme colors) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingScreen,
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
                    size: 24,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  StringsProfile.myActivity,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(MyActivityViewModel model, BondlyColorScheme colors) {
    if (model.activities.isEmpty && model.busy) {
      return _buildSkeletonList(colors);
    }

    final itemCount =
        model.activities.length + (model.nextPage > -1 ? 1 : 0);

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics.atEdge && metrics.pixels > 0) {
          model.loadActivity();
        }
        return true;
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingSm,
          horizontal: AppDimensions.paddingScreen,
        ),
        itemCount: itemCount + 1, // +1 for the info banner at index 0
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildInfoBanner(colors);
          }

          final activityIndex = index - 1;

          if (activityIndex < model.activities.length) {
            final item = model.activities[activityIndex];
            return UserActivityItemWidget(
              key: Key(item.id),
              id: item.feedId,
              type: item.type,
              title: item.title,
              description: item.content,
              date: item.createdAt,
              read: item.read,
              onTap: () {
                context.push(ActivityDetailScreen.route, extra: {
                  ActivityDetailScreen.idParam: item.id,
                  ActivityDetailScreen.feedIdParam: item.feedId,
                  ActivityDetailScreen.readParam: item.read,
                });
                if (!item.read) {
                  item.read = true;
                  setState(() {});
                }
              },
            );
          }

          // Pagination loading indicator
          if (model.notificationMessage.isEmpty && model.busy) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: BondlyShimmerBlock(
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoBanner(BondlyColorScheme colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppDimensions.accentGradient(colors),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPost),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringsProfile.myActivityHeader,
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: BondlyColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            StringsProfile.myActivitySubHeader,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xCCFFFFFF),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList(BondlyColorScheme colors) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingSm,
        horizontal: AppDimensions.paddingScreen,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: const BondlyShimmerBlock(
              width: double.infinity,
              height: 140,
              borderRadius: 20,
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: const BondlyShimmerBlock(
            width: double.infinity,
            height: 120,
            borderRadius: 16,
          ),
        );
      },
    );
  }

  Widget _buildNotificationToast(
    MyActivityViewModel model,
    BondlyColorScheme colors,
  ) {
    return Positioned(
      bottom: 24,
      left: AppDimensions.paddingScreen,
      right: AppDimensions.paddingScreen,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: AppDimensions.cardShadow(colors.textPrimary),
        ),
        child: Text(
          model.notificationMessage,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
