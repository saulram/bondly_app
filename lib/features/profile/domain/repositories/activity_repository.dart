import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:multiple_result/multiple_result.dart';

class NoMoreContentException implements Exception {}
class NoActivityIdFoundException implements Exception {}

abstract class ActivityRepository {
  Future<Result<UserActivityHolder, Exception>> getActivityList(
      String userId, int limit, int page
  );
}