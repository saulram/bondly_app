import 'package:bondly_app/features/ai/domain/models/feed_insight.dart';
import 'package:bondly_app/features/ai/domain/repositories/ai_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class PersonalizeFeedUseCase {
  final AIRepository repository;

  PersonalizeFeedUseCase(this.repository);

  Future<Result<PersonalizedFeedResult, Exception>> invoke({
    required String userId,
    required List<Map<String, dynamic>> feedItems,
    required Map<String, dynamic> userProfile,
  }) async {
    return await repository.personalizeFeed(
      userId: userId,
      feedItems: feedItems,
      userProfile: userProfile,
    );
  }
}
