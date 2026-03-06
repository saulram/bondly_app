import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/dashboard_stats.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class AdminAuthRepository {
  Future<Result<List<AdminModule>, Exception>> getPermissions(String userId);
  Future<Result<bool, Exception>> hasPermission(
      String userId, AdminModule module);
  Future<Result<DashboardStats, Exception>> getDashboardStats();
  Future<Result<List<RecognitionTrendPoint>, Exception>> getRecognitionTrends(
      int months);
  Future<Result<List<BadgeUsageStat>, Exception>> getBadgeUsageReport();
}
