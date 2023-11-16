import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:multiple_result/multiple_result.dart';

class GetUserActivityUseCase {

  final ActivityRepository _repository;
  final CompanyFeedsRepository _feedsRepository;

  GetUserActivityUseCase(this._repository, this._feedsRepository);

  Future<Result<UserActivityHolder, Exception>> invoke(
    String userId, {int limit = 10, int page = 0}
  ) async {
    if (page == -1) {
      return Result.error(NoMoreContentException());
    }

    return _repository.getActivityList(userId, limit, page);
  }

  Future<Result<FeedData, Exception>> invokeSingle(
    String activityId
  ) async {
    if (activityId.isEmpty) {
      return Result.error(NoActivityIdFoundException());
    }
    return _feedsRepository.getCompanyFeedById(activityId);
  }
}
