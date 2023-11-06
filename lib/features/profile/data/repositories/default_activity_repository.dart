import 'package:bondly_app/features/auth/data/repositories/api/users_api.dart';
import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultActivityRepository extends ActivityRepository {

  final UsersAPI _api;

  DefaultActivityRepository(this._api);

  @override
  Future<Result<UserActivityHolder, Exception>> getActivityList(
      String userId,
      int limit,
      int page
  ) async {
    try {
      var result = await _api.loadActivity(userId, limit, page);
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
