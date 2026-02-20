import 'package:bondly_app/features/ranking/domain/models/ranked_user.dart';
import 'package:bondly_app/features/ranking/domain/repositories/ranking_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseRankingRepository extends RankingRepository {
  final SupabaseClientProvider _provider;

  SupabaseRankingRepository(this._provider);

  @override
  Future<Result<List<RankedUser>, Exception>> getRanking({
    String period = 'month',
    int limit = 10,
  }) async {
    try {
      final response = await _provider.client.rpc('get_ranking', params: {
        'period_filter': period,
        'result_limit': limit,
      });

      final users = (response as List)
          .map((row) => RankedUser.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(users);
    } catch (exception) {
      return Result.error(RankingFetchException(exception.toString()));
    }
  }
}
