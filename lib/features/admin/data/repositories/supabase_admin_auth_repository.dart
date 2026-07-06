import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/dashboard_stats.dart';
import 'package:bondly_app/features/admin/domain/repositories/admin_auth_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminAuthRepository implements AdminAuthRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminAuthRepository(this._supabase);

  @override
  Future<Result<List<AdminModule>, Exception>> getPermissions(
      String userId) async {
    try {
      final response = await _supabase.client
          .rpc('get_user_permissions', params: {'p_user_id': userId});
      final List<dynamic> data = response as List<dynamic>;
      final permissions = data
          .map((e) => AdminModule.fromString(e['permission'] as String))
          .whereType<AdminModule>()
          .toList();
      return Result.success(permissions);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> hasPermission(
      String userId, AdminModule module) async {
    try {
      final response = await _supabase.client.rpc(
        'has_admin_permission',
        params: {'p_permission': module.value},
      );
      return Result.success(response as bool);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<DashboardStats, Exception>> getDashboardStats() async {
    try {
      final response =
          await _supabase.client.rpc('get_admin_dashboard_stats');
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(response as Map);
      return Result.success(DashboardStats.fromJson(data));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<RecognitionTrendPoint>, Exception>> getRecognitionTrends(
      int months) async {
    try {
      final response = await _supabase.client
          .rpc('get_recognition_trends', params: {'p_months': months});
      final List<dynamic> data = response as List<dynamic>;
      final trends = data
          .map((e) =>
              RecognitionTrendPoint.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return Result.success(trends);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<BadgeUsageStat>, Exception>> getBadgeUsageReport() async {
    try {
      final response =
          await _supabase.client.rpc('get_badge_usage_report');
      final List<dynamic> data = response as List<dynamic>;
      final stats = data
          .map((e) =>
              BadgeUsageStat.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return Result.success(stats);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
