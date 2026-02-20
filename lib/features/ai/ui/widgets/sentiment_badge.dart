import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SentimentBadge extends StatelessWidget {
  final SentimentResult sentiment;

  const SentimentBadge({super.key, required this.sentiment});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: sentiment.summary,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 14, color: _iconColor),
            const SizedBox(width: 4),
            Text(
              _label,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: _iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _label {
    switch (sentiment.sentiment) {
      case SentimentType.positive:
        return 'Positivo';
      case SentimentType.negative:
        return 'Negativo';
      case SentimentType.neutral:
        return 'Neutral';
    }
  }

  IconData get _icon {
    switch (sentiment.sentiment) {
      case SentimentType.positive:
        return Icons.sentiment_satisfied_alt;
      case SentimentType.negative:
        return Icons.sentiment_dissatisfied;
      case SentimentType.neutral:
        return Icons.sentiment_neutral;
    }
  }

  Color get _iconColor {
    switch (sentiment.sentiment) {
      case SentimentType.positive:
        return const Color(0xFF2E7D32);
      case SentimentType.negative:
        return const Color(0xFFC62828);
      case SentimentType.neutral:
        return const Color(0xFF616161);
    }
  }

  Color get _backgroundColor {
    switch (sentiment.sentiment) {
      case SentimentType.positive:
        return const Color(0xFFE8F5E9);
      case SentimentType.negative:
        return const Color(0xFFFFEBEE);
      case SentimentType.neutral:
        return const Color(0xFFF5F5F5);
    }
  }
}
