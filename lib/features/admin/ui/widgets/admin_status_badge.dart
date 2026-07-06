import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AdminStatusType { active, inactive, pending }

class AdminStatusBadge extends StatelessWidget {
  final AdminStatusType status;
  final String? customLabel;

  const AdminStatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      AdminStatusType.active => (Colors.green, 'Activo'),
      AdminStatusType.inactive => (Colors.red, 'Inactivo'),
      AdminStatusType.pending => (Colors.orange, 'Pendiente'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        customLabel ?? label,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
