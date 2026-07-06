import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_shell_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AdminShellViewModel viewModel;
  final List<String> breadcrumbs;
  final VoidCallback? onMenuTap;

  const AdminAppBar({
    super.key,
    required this.viewModel,
    this.breadcrumbs = const [],
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final isSuperAdmin = viewModel.isSuperAdmin;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (onMenuTap != null)
            IconButton(
              icon: Icon(LucideIcons.menu, color: colors.textSecondary),
              onPressed: onMenuTap,
            ),
          // Breadcrumbs
          if (breadcrumbs.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/admin'),
                    child: Text(
                      StringsAdmin.adminPanelTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  for (int i = 0; i < breadcrumbs.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(LucideIcons.chevronRight,
                          size: 14, color: colors.textMuted),
                    ),
                    Text(
                      breadcrumbs[i],
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: i == breadcrumbs.length - 1
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: i == breadcrumbs.length - 1
                            ? colors.textPrimary
                            : colors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            Expanded(
              child: Text(
                StringsAdmin.adminPanelTitle,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
          // Back to app (text link on desktop)
          TextButton.icon(
            onPressed: () => context.go('/homeScreen'),
            icon: Icon(LucideIcons.arrowLeft,
                size: 14, color: colors.textMuted),
            label: Text(
              StringsAdmin.backToApp,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: colors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSuperAdmin
                  ? Colors.purple.withValues(alpha: 0.12)
                  : colors.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isSuperAdmin
                  ? StringsAdmin.superAdminBadge
                  : StringsAdmin.adminBadge,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSuperAdmin ? Colors.purple : colors.accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.accentSoft,
            backgroundImage: viewModel.userAvatar != null
                ? NetworkImage(viewModel.userAvatar!)
                : null,
            child: viewModel.userAvatar == null
                ? Icon(LucideIcons.user, size: 16, color: colors.accent)
                : null,
          ),
        ],
      ),
    );
  }
}
