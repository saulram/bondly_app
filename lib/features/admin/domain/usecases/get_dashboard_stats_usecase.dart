import 'package:bondly_app/features/admin/domain/models/dashboard_stats.dart';
import 'package:bondly_app/features/admin/domain/repositories/admin_auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetDashboardStatsUseCase {
  final AdminAuthRepository _repository;

  GetDashboardStatsUseCase(this._repository);

  Future<Result<DashboardStats, Exception>> invoke() async {
    return _repository.getDashboardStats();
  }
}

class GetRecognitionTrendsUseCase {
  final AdminAuthRepository _repository;

  GetRecognitionTrendsUseCase(this._repository);

  Future<Result<List<RecognitionTrendPoint>, Exception>> invoke(
      int months) async {
    return _repository.getRecognitionTrends(months);
  }
}

class GetBadgeUsageReportUseCase {
  final AdminAuthRepository _repository;

  GetBadgeUsageReportUseCase(this._repository);

  Future<Result<List<BadgeUsageStat>, Exception>> invoke() async {
    return _repository.getBadgeUsageReport();
  }
}
