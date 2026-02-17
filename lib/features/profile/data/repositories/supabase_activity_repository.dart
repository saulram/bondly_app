import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseActivityRepository extends ActivityRepository {
  final SupabaseClientProvider _provider;

  SupabaseActivityRepository(this._provider);

  @override
  Future<Result<UserActivityHolder, Exception>> getActivityList(
    String userId,
    int limit,
    int page,
  ) async {
    try {
      final from = page * limit;
      final to = (page + 1) * limit - 1;

      final response = await _provider.client
          .from('activities')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(from, to);

      final activities = (response as List)
          .map((row) =>
              UserActivityItem.fromSupabase(row as Map<String, dynamic>))
          .toList();

      final countResponse = await _provider.client
          .from('activities')
          .select()
          .eq('user_id', userId)
          .count();

      final totalCount = countResponse.count;

      return Result.success(UserActivityHolder(
        count: totalCount,
        nextPage: (to + 1 < totalCount) ? page + 1 : page,
        prevPage: page > 0 ? page - 1 : 0,
        activity: activities,
      ));
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Future<Result<bool, Exception>> updateActivityStatus(
    String activityId,
  ) async {
    try {
      await _provider.client
          .from('activities')
          .update({'read': true})
          .eq('id', activityId);

      return Result.success(true);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
