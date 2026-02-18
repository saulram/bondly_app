import 'dart:async';

import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/features/home/domain/models/badge_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/ui/shared/badge_icon_button.dart' show BadgeType;
import 'package:bondly_app/ui/shared/info_card.dart';
import 'package:bondly_app/ui/shared/slider_banner_card.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum RecognizeStep { selectBadge, selectPerson, writeMessage }

class RecognizeTab extends StatefulWidget {
  final HomeViewModel model;
  const RecognizeTab({super.key, required this.model});

  @override
  State<RecognizeTab> createState() => _RecognizeTabState();
}

class _RecognizeTabState extends State<RecognizeTab> {
  RecognizeStep _currentStep = RecognizeStep.selectBadge;
  int _activeCategoryIndex = -1;
  Map<String, dynamic>? _selectedPerson;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';

  final TextEditingController _messageController = TextEditingController();

  HomeViewModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _goToStep(RecognizeStep step) {
    setState(() => _currentStep = step);
  }

  void _resetToStep1() {
    setState(() {
      _currentStep = RecognizeStep.selectBadge;
      _activeCategoryIndex = -1;
      _selectedPerson = null;
      _searchController.clear();
      _searchQuery = '';
      _messageController.clear();
      model.selectedBadge = null;
      model.collaboratorsIds = [];
    });
  }

  void _resetToStep2() {
    setState(() {
      _currentStep = RecognizeStep.selectPerson;
      _selectedPerson = null;
      _messageController.clear();
      _searchController.clear();
      _searchQuery = '';
      model.collaboratorsIds = [];
    });
  }

  BadgeType _badgeTypeForIndex(int index) {
    switch (index) {
      case 0:
        return BadgeType.competencias;
      case 1:
        return BadgeType.especiales;
      case 2:
        return BadgeType.valores;
      default:
        return BadgeType.competencias;
    }
  }

  String _categoryLabelForIndex(int index) {
    switch (index) {
      case 0:
        return StringsHome.badgeCompetencias;
      case 1:
        return StringsHome.badgeEspeciales;
      case 2:
        return StringsHome.badgeValores;
      default:
        return '';
    }
  }

  IconData _defaultIconForBadgeType(BadgeType type) {
    switch (type) {
      case BadgeType.competencias:
        return LucideIcons.award;
      case BadgeType.especiales:
        return LucideIcons.star;
      case BadgeType.valores:
        return LucideIcons.heart;
    }
  }

  LinearGradient _gradientForCategoryIndex(int index) {
    switch (index) {
      case 0:
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            BondlyColors.badgeCompetenciasStart,
            BondlyColors.badgeCompetenciasEnd,
          ],
        );
      case 1:
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            BondlyColors.badgeEspecialesStart,
            BondlyColors.badgeEspecialesEnd,
          ],
        );
      case 2:
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            BondlyColors.badgeValoresStart,
            BondlyColors.badgeValoresEnd,
          ],
        );
      default:
        return const LinearGradient(
          colors: [
            BondlyColors.badgeCompetenciasStart,
            BondlyColors.badgeCompetenciasEnd,
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSliderSection(),
          _buildAvisosSection(colors),
          _buildPointsSection(colors),
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
    final bodies = model.announcements.isNotEmpty
        ? model.announcements
            .map((a) => a.content ?? '')
            .where((c) => c.isNotEmpty)
            .toList()
        : [StringsHome.announcementDefaultBody];

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
        bodies: bodies,
      ),
    );
  }

  // ─── Points Section (dispatches per step) ─────────────────────────────

  Widget _buildPointsSection(BondlyColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingScreen,
        16,
        AppDimensions.paddingScreen,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(colors),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(BondlyColorScheme colors) {
    switch (_currentStep) {
      case RecognizeStep.selectBadge:
        return _buildStep1Content(colors);
      case RecognizeStep.selectPerson:
        return _buildStep2Content(colors);
      case RecognizeStep.writeMessage:
        return _buildStep3Content(colors);
    }
  }

  // ─── Step 1: Select Badge ─────────────────────────────────────────────

  Widget _buildStep1Content(BondlyColorScheme colors) {
    final categories = model.categories.categories ?? [];
    final hasActiveCategory =
        _activeCategoryIndex >= 0 && _activeCategoryIndex < categories.length;
    final activeCategoryName = hasActiveCategory
        ? categories[_activeCategoryIndex].name ?? ''
        : StringsHome.badgePickSubtitle;

    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Points header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              model.user?.giftedPoints.toString() ?? '0',
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: colors.accent,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              StringsHome.pointsLabel,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          StringsHome.pointsDescription,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 20),
        Divider(color: colors.border, height: 1),
        const SizedBox(height: 14),

        // Active category name
        Text(
          activeCategoryName,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),

        // 3 badge categories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            categories.length > 3 ? 3 : categories.length,
            (index) {
              final isActive = index == _activeCategoryIndex;
              final badgeType = _badgeTypeForIndex(index);
              return GestureDetector(
                onTap: () {
                  setState(() => _activeCategoryIndex = index);
                  model.selectedCategory = categories[index].id;
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isActive || !hasActiveCategory ? 1.0 : 0.35,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: isActive
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.accent,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        colors.accent.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              )
                            : null,
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient:
                                  _gradientForCategoryIndex(index),
                            ),
                            child: Icon(
                              _defaultIconForBadgeType(badgeType),
                              size: 26,
                              color: BondlyColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _categoryLabelForIndex(index),
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (hasActiveCategory) ...[
          const SizedBox(height: 14),
          Divider(color: colors.border, height: 1),
          const SizedBox(height: 14),

          // "Elige una insignia" label
          Text(
            StringsHome.step1ChooseBadge,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          // Sub-badge grid
          if (model.loadingBadges)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: model.badges.badges.map((badge) {
                return _buildBadgeItem(badge, colors);
              }).toList(),
            ),
        ],

        const SizedBox(height: 16),

        // Cost info row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.info, size: 14, color: colors.textMuted),
            const SizedBox(width: 6),
            Text(
              StringsHome.step1BadgeCostInfo,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgeItem(Badge badge, BondlyColorScheme colors) {
    return GestureDetector(
      onTap: () {
        model.selectedBadge = badge;
        _goToStep(RecognizeStep.selectPerson);
      },
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.accentGradientStart.withValues(alpha: 0.09),
              ),
              child: badge.image != null && badge.image!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        badge.image!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          LucideIcons.award,
                          size: 24,
                          color: colors.accent,
                        ),
                      ),
                    )
                  : Icon(
                      LucideIcons.award,
                      size: 24,
                      color: colors.accent,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              badge.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 2: Select Person ────────────────────────────────────────────

  Widget _buildStep2Content(BondlyColorScheme colors) {
    final currentUserId = model.user?.id;
    final collaboratorsWithoutSelf = model.collaboratorsList.where((c) {
      final userId = c['user_id'] as String? ?? '';
      return userId != currentUserId;
    }).toList();
    final filteredCollaborators = _searchQuery.isEmpty
        ? collaboratorsWithoutSelf
        : collaboratorsWithoutSelf.where((c) {
            final name = (c['display'] as String? ?? '').toLowerCase();
            return name.contains(_searchQuery.toLowerCase());
          }).toList();

    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with points + cancel
        _buildStepHeader(colors, onCancel: _resetToStep1),
        const SizedBox(height: 12),

        // Badge chip
        _buildBadgeChip(colors, onTap: _resetToStep1),
        const SizedBox(height: 14),
        Divider(color: colors.border, height: 1),
        const SizedBox(height: 14),

        // "A quién quieres reconocer?" label
        Text(
          StringsHome.step2SearchLabel,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),

        // Search field
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            border: Border.all(color: colors.border, width: 1),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _debounceTimer?.cancel();
              _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                setState(() => _searchQuery = value);
              });
            },
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: StringsHome.step2SearchHint,
              hintStyle: GoogleFonts.montserrat(
                fontSize: 13,
                color: colors.textMuted,
              ),
              prefixIcon: Icon(
                LucideIcons.search,
                size: 18,
                color: colors.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Results list
        if (filteredCollaborators.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                StringsHome.step2NoResults,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredCollaborators.length,
              itemBuilder: (context, index) {
                final collaborator = filteredCollaborators[index];
                return _buildCollaboratorItem(collaborator, colors);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCollaboratorItem(
    Map<String, dynamic> collaborator,
    BondlyColorScheme colors,
  ) {
    final name = collaborator['display'] as String? ?? '';
    final avatar = collaborator['avatar'] as String? ?? '';
    final userId = collaborator['user_id'] as String? ?? '';

    return InkWell(
      onTap: () {
        setState(() => _selectedPerson = collaborator);
        model.collaboratorsIds = [userId];
        _goToStep(RecognizeStep.writeMessage);
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
              backgroundColor: colors.surfaceElevated,
              child: avatar.isEmpty
                  ? Icon(LucideIcons.user, size: 16, color: colors.textMuted)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (model.user?.companyName != null)
                    Text(
                      model.user!.companyName!,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 3: Write Message & Send ─────────────────────────────────────

  Widget _buildStep3Content(BondlyColorScheme colors) {
    final canSend = _messageController.text.trim().isNotEmpty &&
        !model.creatingAcknowledgment;

    return Column(
      key: const ValueKey('step3'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with points + cancel
        _buildStepHeader(colors, onCancel: _resetToStep1),
        const SizedBox(height: 12),

        // Badge chip
        _buildBadgeChip(colors, onTap: _resetToStep1),
        const SizedBox(height: 8),

        // Person chip
        _buildPersonChip(colors, onTap: _resetToStep2),
        const SizedBox(height: 14),
        Divider(color: colors.border, height: 1),
        const SizedBox(height: 14),

        // "Escribe tu reconocimiento" label
        Text(
          StringsHome.step3WriteLabel,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),

        // Text area
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            border: Border.all(color: colors.border, width: 1),
          ),
          child: TextField(
            controller: _messageController,
            maxLength: 150,
            maxLines: 3,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: StringsHome.step3WriteLabel,
              hintStyle: GoogleFonts.montserrat(
                fontSize: 13,
                color: colors.textMuted,
              ),
              border: InputBorder.none,
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Char counter
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_messageController.text.length}/150',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: colors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Send button
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: canSend ? 1.0 : 0.5,
          child: GestureDetector(
            onTap: canSend ? _handleSend : null,
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppDimensions.accentGradient(colors),
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                boxShadow: [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (model.creatingAcknowledgment)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: BondlyColors.white,
                      ),
                    )
                  else ...[
                    const Icon(
                      LucideIcons.send,
                      size: 18,
                      color: BondlyColors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      StringsHome.step3SendButton,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BondlyColors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSend() async {
    final success =
        await model.submitAcknowledgmentDirect(_messageController.text);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(StringsHome.acknowledgmentSuccess)),
      );
      _resetToStep1();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(StringsHome.acknowledgmentError)),
      );
    }
  }

  // ─── Shared Widgets ───────────────────────────────────────────────────

  Widget _buildStepHeader(BondlyColorScheme colors,
      {required VoidCallback onCancel}) {
    return Row(
      children: [
        Expanded(child: _buildCompactPointsHeader(colors)),
        GestureDetector(
          onTap: onCancel,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.x, size: 14, color: colors.textMuted),
              const SizedBox(width: 4),
              Text(
                'Cancelar',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactPointsHeader(BondlyColorScheme colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          model.user?.giftedPoints.toString() ?? '0',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: colors.accent,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          StringsHome.pointsLabel,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeChip(BondlyColorScheme colors, {VoidCallback? onTap}) {
    final badge = model.selectedBadge;
    if (badge == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _gradientForCategoryIndex(_activeCategoryIndex),
              ),
              child: badge.image != null && badge.image!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        badge.image!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          LucideIcons.award,
                          size: 18,
                          color: BondlyColors.white,
                        ),
                      ),
                    )
                  : const Icon(
                      LucideIcons.award,
                      size: 18,
                      color: BondlyColors.white,
                    ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    badge.name ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    _categoryLabelForIndex(_activeCategoryIndex),
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(LucideIcons.check, size: 16, color: colors.accent),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonChip(BondlyColorScheme colors, {VoidCallback? onTap}) {
    if (_selectedPerson == null) return const SizedBox.shrink();

    final name = _selectedPerson!['display'] as String? ?? '';
    final avatar = _selectedPerson!['avatar'] as String? ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  avatar.isNotEmpty ? NetworkImage(avatar) : null,
              backgroundColor: colors.surfaceElevated,
              child: avatar.isEmpty
                  ? Icon(LucideIcons.user, size: 18, color: colors.textMuted)
                  : null,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (model.user?.companyName != null)
                    Text(
                      model.user!.companyName!,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(LucideIcons.check, size: 16, color: colors.accent),
          ],
        ),
      ),
    );
  }
}
