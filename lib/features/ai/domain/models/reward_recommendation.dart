class RewardRecommendation {
  final String rewardId;
  final String reason;
  final double matchScore;

  RewardRecommendation({
    required this.rewardId,
    required this.reason,
    required this.matchScore,
  });

  factory RewardRecommendation.fromJson(Map<String, dynamic> json) {
    return RewardRecommendation(
      rewardId: json['rewardId'] ?? '',
      reason: json['reason'] ?? '',
      matchScore: (json['matchScore'] ?? 0.0).toDouble(),
    );
  }
}
