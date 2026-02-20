import 'package:bondly_app/features/ranking/domain/models/ranked_user.dart';
import 'package:bondly_app/features/ranking/domain/repositories/ranking_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetRankingUseCase {
  final RankingRepository repository;

  GetRankingUseCase(this.repository);

  Future<Result<List<RankedUser>, Exception>> invoke({
    String period = 'month',
    int limit = 10,
  }) async {
    return await repository.getRanking(period: period, limit: limit);
  }
}
