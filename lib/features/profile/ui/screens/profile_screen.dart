import 'dart:typed_data';

import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/widgets/full_screen_image.dart';
import 'package:bondly_app/features/profile/ui/screens/monthly_balance_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_activity_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_badges_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_data_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_rewards_screen.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/widgets/selectable_menu_option.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = "/profileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final ProfileViewModel _model = getIt<ProfileViewModel>();
  Uint8List? _imageBytes;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _model.load();
  }

  @override
  void dispose() {
    _imageBytes = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return ModelProvider<ProfileViewModel>(
      model: _model,
      child: ModelBuilder<ProfileViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: colors.bg,
          body: SafeArea(
            child: model.busy
                ? _buildLoadingState(colors)
                : Column(
                    children: [
                      _buildTopBar(colors),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildProfileHero(colors, model),
                              _buildMenuSection(colors),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomSection(colors, model),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ─── Loading State ──────────────────────────────────────────────────

  Widget _buildLoadingState(BondlyColorScheme colors) {
    return Column(
      children: [
        _buildTopBar(colors),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingScreen,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Avatar placeholder
                  const BondlyShimmerCircle(size: 88),
                  const SizedBox(height: 14),
                  // Greeting line
                  const BondlyShimmerBlock(width: 60, height: 14),
                  const SizedBox(height: 6),
                  // Name line
                  const BondlyShimmerBlock(width: 160, height: 22),
                  const SizedBox(height: 20),
                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCardSkeleton(colors),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCardSkeleton(colors),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCardSkeleton(colors),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Menu card placeholder
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusCard),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Column(
                      children: List.generate(5, (i) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: i < 4
                              ? BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: colors.border,
                                      width: 1,
                                    ),
                                  ),
                                )
                              : null,
                          child: const Row(
                            children: [
                              BondlyShimmerBlock(
                                width: 36,
                                height: 36,
                                borderRadius: 10,
                              ),
                              SizedBox(width: 14),
                              BondlyShimmerBlock(width: 120, height: 14),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardSkeleton(BondlyColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: const Column(
        children: [
          BondlyShimmerBlock(width: 50, height: 22, borderRadius: 6),
          SizedBox(height: 8),
          BondlyShimmerBlock(width: 60, height: 11),
          SizedBox(height: 4),
          BondlyShimmerBlock(width: 50, height: 11),
        ],
      ),
    );
  }

  // ─── 1. Top Bar ─────────────────────────────────────────────────────

  Widget _buildTopBar(BondlyColorScheme colors) {
    return SizedBox(
      height: 48,
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
                  size: 18,
                  color: colors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                StringsProfile.profileTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 36, height: 36),
          ],
        ),
      ),
    );
  }

  // ─── 2. Profile Hero ────────────────────────────────────────────────

  Widget _buildProfileHero(BondlyColorScheme colors, ProfileViewModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        8,
        AppDimensions.paddingScreen,
        24,
      ),
      child: Column(
        children: [
          _buildAvatarArea(colors, model),
          const SizedBox(height: 20),
          _buildStatsRow(colors, model),
        ],
      ),
    );
  }

  Widget _buildAvatarArea(BondlyColorScheme colors, ProfileViewModel model) {
    final avatarUrl = model.user?.avatar;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    final userName = model.user?.completeName ?? StringsProfile.defaultUser;

    return Column(
      children: [
        // Avatar wrapper
        SizedBox(
          width: 88,
          height: 88,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Avatar circle
              GestureDetector(
                onTap: () => displayAvatar(
                  image: safeImageUrl(avatarUrl, isAvatar: true),
                ),
                child: _imageBytes != null
                    ? CircleAvatar(
                        radius: 44,
                        backgroundColor: colors.accentSoft,
                        backgroundImage: MemoryImage(_imageBytes!),
                      )
                    : hasAvatar
                        ? Hero(
                            tag: 'AvatarWidget',
                            child: CircleAvatar(
                              radius: 44,
                              backgroundColor: colors.accentSoft,
                              backgroundImage: NetworkImage(
                                safeImageUrl(avatarUrl, isAvatar: true),
                              ),
                            ),
                          )
                        : Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  colors.accentGradientStart,
                                  colors.accentGradientEnd,
                                ],
                              ),
                            ),
                            child: const Icon(
                              LucideIcons.user,
                              size: 36,
                              color: BondlyColors.white,
                            ),
                          ),
              ),
              // Edit badge
              Positioned(
                right: -2,
                bottom: -2,
                child: GestureDetector(
                  onTap: showOptions,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.bg, width: 3),
                    ),
                    child: const Icon(
                      LucideIcons.pencil,
                      size: 13,
                      color: BondlyColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Greeting
        Text(
          StringsProfile.greetingPrefix,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          userName,
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BondlyColorScheme colors, ProfileViewModel model) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: _formatNumber(model.user?.pointsReceived ?? 0),
            label: StringsProfile.receivedPoints,
            colors: colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: _formatNumber(model.spendableBalance ?? 0),
            label: StringsProfile.spendablePoints,
            colors: colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: _formatNumber(model.user?.giftedPoints ?? 0),
            label: StringsProfile.givenPoints,
            colors: colors,
          ),
        ),
      ],
    );
  }

  // ─── 3. Menu Section ────────────────────────────────────────────────

  Widget _buildMenuSection(BondlyColorScheme colors) {
    final menuItems = [
      _MenuItem(
        title: StringsProfile.myData,
        icon: LucideIcons.userCircle2,
        onTap: () => context.push(MyDataScreen.route),
      ),
      _MenuItem(
        title: StringsProfile.myActivity,
        icon: LucideIcons.activity,
        onTap: () => context.push(MyActivityScreen.route),
      ),
      _MenuItem(
        title: StringsProfile.myBadges,
        icon: LucideIcons.award,
        onTap: () => context.push(MyBadgesScreen.route),
      ),
      _MenuItem(
        title: StringsProfile.rewards,
        icon: LucideIcons.gift,
        onTap: () => context.push(MyRewardsScreen.route),
      ),
      _MenuItem(
        title: StringsProfile.monthlyReport,
        icon: LucideIcons.wallet,
        onTap: () => context.push(MonthlyBalanceScreen.route),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingScreen,
        vertical: 8,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Column(
          children: List.generate(menuItems.length, (index) {
            final item = menuItems[index];
            final isLast = index == menuItems.length - 1;
            return SelectableMenuOption(
              title: item.title,
              icon: item.icon,
              showBorder: !isLast,
              onTap: item.onTap,
            );
          }),
        ),
      ),
    );
  }

  // ─── 5. Bottom Section ──────────────────────────────────────────────

  Widget _buildBottomSection(BondlyColorScheme colors, ProfileViewModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        0,
        AppDimensions.paddingScreen,
        32,
      ),
      child: Column(
        children: [
          // Logout button
          GestureDetector(
            onTap: () => _showLogoutDialog(colors, model),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    colors.accentGradientStart,
                    colors.accentGradientEnd,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.logOut, size: 18, color: BondlyColors.white),
                  const SizedBox(width: 8),
                  Text(
                    StringsProfile.closeSession,
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: BondlyColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Version
          Text(
            '${model.appName ?? 'bondly_app'} v${model.version ?? '1.0.0'}b${model.buildNumber ?? '0'}',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Logout Dialog ──────────────────────────────────────────────────

  void _showLogoutDialog(BondlyColorScheme colors, ProfileViewModel model) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        title: Text(
          StringsProfile.logoutDialogTitle,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          StringsProfile.logoutDialogBody,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: colors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              StringsProfile.logoutDialogCancel,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              model.closeSession();
            },
            child: Text(
              StringsProfile.logoutDialogConfirm,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.likeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Image Picker ───────────────────────────────────────────────────

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 1000,
      maxHeight: 1000,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _model.updateAvatar(bytes);
    }
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      maxWidth: 1000,
      maxHeight: 1000,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _model.updateAvatar(bytes);
    }
  }

  Future<void> showOptions() async {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          Container(
            color: colors.accent,
            child: CupertinoActionSheetAction(
              child: Text(
                StringsProfile.fromGallery,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: BondlyColors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                getImageFromGallery();
              },
            ),
          ),
          Container(
            color: colors.accent,
            child: CupertinoActionSheetAction(
              child: Text(
                StringsProfile.fromCamera,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: BondlyColors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                getImageFromCamera();
              },
            ),
          ),
        ],
      ),
    );
  }

  void displayAvatar({required String image}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          image: image,
          tag: 'AvatarWidget',
          isFile: image.isEmpty,
          imageBytes: _imageBytes,
        ),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────

  static String _formatNumber(int value) {
    if (value >= 1000) {
      final str = value.toString();
      final buffer = StringBuffer();
      for (var i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
        buffer.write(str[i]);
      }
      return buffer.toString();
    }
    return value.toString();
  }
}

// ─── StatCard ──────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final BondlyColorScheme colors;

  const _StatCard({
    required this.value,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: colors.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── MenuItem helper ──────────────────────────────────────────────────

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
