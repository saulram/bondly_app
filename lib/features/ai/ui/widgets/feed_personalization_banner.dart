import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedPersonalizationBanner extends StatelessWidget {
  final bool isPersonalized;
  final bool isLoading;
  final VoidCallback onToggle;

  const FeedPersonalizationBanner({
    super.key,
    required this.isPersonalized,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isPersonalized
            ? const LinearGradient(
                colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)],
              )
            : null,
        color: isPersonalized ? null : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isPersonalized ? Icons.auto_awesome : Icons.sort,
            size: 18,
            color: isPersonalized
                ? AppColors.primaryColor
                : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isPersonalized
                  ? 'Feed personalizado con IA'
                  : 'Feed cronológico',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isPersonalized
                    ? AppColors.primaryColor
                    : Colors.grey[600],
              ),
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            GestureDetector(
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPersonalized
                      ? AppColors.primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPersonalized ? 'IA ON' : 'IA OFF',
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isPersonalized ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
