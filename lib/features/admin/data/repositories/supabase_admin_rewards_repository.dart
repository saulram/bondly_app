import 'package:bondly_app/features/admin/domain/models/admin_reward.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminRewardsRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminRewardsRepository(this._supabase);

  Future<Result<List<AdminReward>, Exception>> getRewards() async {
    try {
      final response = await _supabase.client
          .from('rewards')
          .select()
          .order('created_at', ascending: false);
      final items = (response as List)
          .map((e) => AdminReward.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleEnable(
      String rewardId, bool enable) async {
    try {
      await _supabase.client
          .from('rewards')
          .update({'enable': enable}).eq('id', rewardId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> createReward({
    required String name,
    String? description,
    String? category,
    required int points,
    String? image,
    DateTime? deadline,
  }) async {
    try {
      await _supabase.client.from('rewards').insert({
        'name': name,
        'description': description,
        'category': category,
        'points': points,
        'image': image,
        'deadline': deadline?.toIso8601String(),
        'enable': true,
        'visible': true,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateReward({
    required String rewardId,
    required String name,
    String? description,
    String? category,
    required int points,
  }) async {
    try {
      await _supabase.client.from('rewards').update({
        'name': name,
        'description': description,
        'category': category,
        'points': points,
      }).eq('id', rewardId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteReward(String rewardId) async {
    try {
      await _supabase.client.from('rewards').delete().eq('id', rewardId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
