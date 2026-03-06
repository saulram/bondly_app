class DashboardStats {
  final int totalUsers;
  final int activeUsers;
  final int monthRecognitions;
  final int monthExchanges;
  final int pointsCirculating;
  final int activeBadges;
  final int activeRewards;

  const DashboardStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.monthRecognitions,
    required this.monthExchanges,
    required this.pointsCirculating,
    required this.activeBadges,
    required this.activeRewards,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 0,
      activeUsers: (json['active_users'] as num?)?.toInt() ?? 0,
      monthRecognitions: (json['month_recognitions'] as num?)?.toInt() ?? 0,
      monthExchanges: (json['month_exchanges'] as num?)?.toInt() ?? 0,
      pointsCirculating: (json['points_circulating'] as num?)?.toInt() ?? 0,
      activeBadges: (json['active_badges'] as num?)?.toInt() ?? 0,
      activeRewards: (json['active_rewards'] as num?)?.toInt() ?? 0,
    );
  }

  static DashboardStats empty() {
    return const DashboardStats(
      totalUsers: 0,
      activeUsers: 0,
      monthRecognitions: 0,
      monthExchanges: 0,
      pointsCirculating: 0,
      activeBadges: 0,
      activeRewards: 0,
    );
  }
}

class RecognitionTrendPoint {
  final String month;
  final int count;

  const RecognitionTrendPoint({required this.month, required this.count});

  factory RecognitionTrendPoint.fromJson(Map<String, dynamic> json) {
    return RecognitionTrendPoint(
      month: json['month'] as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class BadgeUsageStat {
  final String badgeId;
  final String badgeName;
  final int usageCount;

  const BadgeUsageStat({
    required this.badgeId,
    required this.badgeName,
    required this.usageCount,
  });

  factory BadgeUsageStat.fromJson(Map<String, dynamic> json) {
    return BadgeUsageStat(
      badgeId: json['badge_id'] as String,
      badgeName: json['badge_name'] as String,
      usageCount: (json['usage_count'] as num?)?.toInt() ?? 0,
    );
  }
}
