class FeedInsight {
  final String feedId;
  final double relevanceScore;
  final String reason;

  FeedInsight({
    required this.feedId,
    required this.relevanceScore,
    required this.reason,
  });

  factory FeedInsight.fromJson(Map<String, dynamic> json) {
    return FeedInsight(
      feedId: json['feedId'] ?? '',
      relevanceScore: (json['relevanceScore'] ?? 0.0).toDouble(),
      reason: json['reason'] ?? '',
    );
  }
}

class PersonalizedFeedResult {
  final List<String> orderedFeedIds;
  final Map<String, FeedInsight> insights;

  PersonalizedFeedResult({
    required this.orderedFeedIds,
    required this.insights,
  });
}
