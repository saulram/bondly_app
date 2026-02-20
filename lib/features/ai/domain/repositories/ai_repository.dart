import 'package:bondly_app/features/ai/domain/models/feed_insight.dart';
import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:bondly_app/features/ai/domain/models/sentiment_result.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class AIRepository {
  Future<Result<PersonalizedFeedResult, Exception>> personalizeFeed({
    required String userId,
    required List<Map<String, dynamic>> feedItems,
    required Map<String, dynamic> userProfile,
  });

  Future<Result<List<RewardRecommendation>, Exception>> getRewardRecommendations({
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> availableRewards,
  });

  Future<Result<SentimentResult, Exception>> analyzeSentiment({
    required String text,
  });
}
