import 'package:bondly_app/features/ai/domain/models/reward_recommendation.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetRewardRecommendationsUseCase {
  final AIRepository repository;

  GetRewardRecommendationsUseCase(this.repository);

  Future<Result<List<RewardRecommendation>, Exception>> invoke({
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> availableRewards,
  }) async {
    return await repository.getRewardRecommendations(
      userProfile: userProfile,
      availableRewards: availableRewards,
    );
  }
}
