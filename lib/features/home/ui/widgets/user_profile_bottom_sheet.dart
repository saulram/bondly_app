import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:bondly_app/features/profile/domain/usecases/user_profile_use_case.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

void showUserProfileBottomSheet(
  BuildContext context,
  String userId,
  String userName,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _UserProfileSheet(userId: userId, userName: userName),
  );
}

class _UserProfileSheet extends StatefulWidget {
  final String userId;
  final String userName;

  const _UserProfileSheet({required this.userId, required this.userName});

  @override
  State<_UserProfileSheet> createState() => _UserProfileSheetState();
}

class _UserProfileSheetState extends State<_UserProfileSheet> {
  bool _loading = true;
  UserProfile? _profile;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final useCase = getIt<UserProfileUseCase>();
    final result = await useCase.invoke(widget.userId);
    if (!mounted) return;

    result.when(
      (profile) {
        setState(() {
          _profile = profile;
          _loading = false;
        });
      },
      (error) {
        setState(() {
          _error = error.toString();
          _loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          if (_loading)
            _buildLoading(colors)
          else if (_error != null)
            _buildError(colors)
          else
            _buildProfile(colors, colorScheme),
        ],
      ),
    );
  }

  Widget _buildLoading(BondlyColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          CircularProgressIndicator(color: colors.accent),
          const SizedBox(height: 16),
          Text(
            'Cargando perfil...',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BondlyColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Fallback: show what we know from the mention
          CircleAvatar(
            radius: 36,
            backgroundColor: colors.accentSoft,
            child: Text(
              _initials(widget.userName),
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.userName,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No se pudo cargar el perfil completo',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BondlyColorScheme colors, ColorScheme colorScheme) {
    final user = _profile!.user;
    final hasAvatar = user.avatar != null && user.avatar!.isNotEmpty;

    return Column(
      children: [
        // Avatar
        hasAvatar
            ? CircleAvatar(
                radius: 40,
                backgroundColor: colors.accentSoft,
                backgroundImage: NetworkImage(
                  safeImageUrl(user.avatar, isAvatar: true),
                ),
              )
            : Container(
                width: 80,
                height: 80,
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
                child: Center(
                  child: Text(
                    _initials(user.completeName ?? widget.userName),
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: BondlyColors.white,
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 14),

        // Name
        Text(
          user.completeName ?? widget.userName,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),

        // Job position
        if (_profile!.jobPosition.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            _profile!.jobPosition,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: colors.textSecondary,
            ),
          ),
        ],

        // Role chip
        if (user.role != null && user.role!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colors.tagBg,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
            child: Text(
              user.role!,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.tagText,
              ),
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Stats row
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: LucideIcons.arrowDownCircle,
                value: user.pointsReceived.toString(),
                label: 'Recibidos',
                colors: colors,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: colors.border,
            ),
            Expanded(
              child: _StatTile(
                icon: LucideIcons.arrowUpCircle,
                value: user.giftedPoints.toString(),
                label: 'Otorgados',
                colors: colors,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Info rows
        if (user.email != null && user.email!.isNotEmpty)
          _InfoRow(
            icon: LucideIcons.mail,
            text: user.email!,
            colors: colors,
          ),
        if (_profile!.location.isNotEmpty)
          _InfoRow(
            icon: LucideIcons.mapPin,
            text: _profile!.location,
            colors: colors,
          ),
        if (user.companyName != null && user.companyName!.isNotEmpty)
          _InfoRow(
            icon: LucideIcons.building2,
            text: user.companyName!,
            colors: colors,
          ),

        const SizedBox(height: 8),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final BondlyColorScheme colors;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: colors.accent),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: colors.accent,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final BondlyColorScheme colors;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
