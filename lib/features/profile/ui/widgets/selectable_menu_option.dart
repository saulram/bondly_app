import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SelectableMenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool showBorder;
  final VoidCallback onTap;

  const SelectableMenuOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: colors.accentSoft,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: showBorder
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colors.border, width: 1),
                  ),
                )
              : null,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: colors.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 18, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
