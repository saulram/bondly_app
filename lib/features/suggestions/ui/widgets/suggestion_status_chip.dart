import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_suggestions.dart';
import 'package:bondly_app/ui/shared/tag_pill.dart';
import 'package:flutter/material.dart';

Color suggestionStatusColor(String status, BondlyColorScheme colors) =>
    switch (status) {
      'resuelta' => Colors.green,
      'en_revision' => Colors.orange,
      'archivada' => colors.textMuted,
      _ => colors.accent,
    };

class SuggestionStatusChip extends StatelessWidget {
  final String status;

  const SuggestionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BondlyColorScheme>()!;
    final color = suggestionStatusColor(status, colors);
    return TagPill(
      label: StringsSuggestions.statusLabel(status),
      backgroundColor: color.withValues(alpha: 0.12),
      textColor: color,
      radius: 20,
    );
  }
}
