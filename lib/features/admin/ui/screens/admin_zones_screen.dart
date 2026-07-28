import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_permission_guard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminZonesScreen extends StatelessWidget {
  static const String route = '/admin/settings/zones';

  const AdminZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    return AdminPermissionGuard(
      module: AdminModule.manageZones,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  StringsAdmin.zonesTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text(StringsAdmin.addZone),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AdminEmptyState(
                icon: LucideIcons.mapPin,
                message: StringsAdmin.noZonesFound,
                ctaLabel: StringsAdmin.addZone,
                onCta: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
