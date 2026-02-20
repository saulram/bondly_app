import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/ui/shared/badge_icon_button.dart';
import 'package:moment_dart/moment_dart.dart';

class FeedPostHelpers {
  FeedPostHelpers._();

  static BadgeType resolveBadgeType(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('especial')) return BadgeType.especiales;
    if (lower.contains('valor') || lower.contains('embajada')) {
      return BadgeType.valores;
    }
    return BadgeType.competencias;
  }

  static String resolveBadgeCategory(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('especial')) return StringsHome.badgeEspeciales;
    if (lower.contains('valor') || lower.contains('embajada')) {
      return StringsHome.badgeValores;
    }
    return StringsHome.badgeCompetencias;
  }

  static String formatDate(DateTime date) {
    final moment = Moment(date.toLocal());
    return moment.format('DD MMM YYYY');
  }

  static String formatTimeAgo(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      final moment = Moment(date.toLocal());
      return moment.fromNow(dropPrefixOrSuffix: true);
    } catch (_) {
      return '';
    }
  }
}
