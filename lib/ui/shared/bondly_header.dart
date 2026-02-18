import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_main.dart';
import 'package:bondly_app/ui/shared/icon_button_circular.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BondlyHeader extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationTap;

  const BondlyHeader({
    super.key,
    this.avatarUrl,
    this.onAvatarTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return Container(
      height: 56,
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
      child: Row(
        children: [
          // Gradient avatar
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppDimensions.accentGradient(colors),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: colors.surface,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null
                    ? Icon(LucideIcons.user, size: 18, color: colors.textMuted)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // "bondly" text
          Text(
            StringsMain.appBrand,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.accent,
            ),
          ),
          const Spacer(),
          // Notification button
          IconButtonCircular(
            icon: LucideIcons.bell,
            size: 40,
            onTap: onNotificationTap,
          ),
        ],
      ),
    );
  }
}
