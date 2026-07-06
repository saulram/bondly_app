import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_quick_action_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminSettingsScreen extends StatelessWidget {
  static const String route = '/admin/settings';

  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return AdminPermissionGuard(
      module: AdminModule.manageSettings,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringsAdmin.settingsTitle,
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth > 600 ? 3 : 1;
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: columns,
                mainAxisSpacing: AppDimensions.paddingCard,
                crossAxisSpacing: AppDimensions.paddingCard,
                childAspectRatio: 2.5,
                children: [
                  AdminQuickActionCard(
                    icon: LucideIcons.mapPin,
                    label: StringsAdmin.zonesTitle,
                    color: Colors.blue,
                    onTap: () => context.go('/admin/settings/zones'),
                  ),
                  AdminQuickActionCard(
                    icon: LucideIcons.shieldCheck,
                    label: StringsAdmin.permissionsTitle,
                    color: Colors.purple,
                    onTap: () =>
                        context.go('/admin/settings/permissions'),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
