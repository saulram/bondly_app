import 'package:bondly_app/features/ranking/domain/models/ranked_user.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class RankingRepository {
  /// Retrieves the ranking of users filtered by [period].
  /// Valid periods: 'month', 'quarter', 'year'.
  /// [limit] controls how many users are returned (default 10).
  Future<Result<List<RankedUser>, Exception>> getRanking({
    String period = 'month',
    int limit = 10,
  });
}

class RankingFetchException implements Exception {
  final String message;
  RankingFetchException([this.message = 'Error fetching ranking']);

  @override
  String toString() => message;
}
