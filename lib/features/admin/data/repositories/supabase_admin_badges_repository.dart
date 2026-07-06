import 'package:bondly_app/features/admin/domain/models/admin_badge.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminBadgesRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminBadgesRepository(this._supabase);

  Future<Result<List<AdminBadge>, Exception>> getBadges() async {
    try {
      final response = await _supabase.client
          .from('badges')
          .select('*, badge_categories(name)')
          .order('created_at', ascending: false);
      final items = (response as List)
          .map((e) => AdminBadge.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<List<AdminBadgeCategory>, Exception>> getCategories() async {
    try {
      final response = await _supabase.client
          .from('badge_categories')
          .select()
          .order('name');
      final items = (response as List)
          .map((e) => AdminBadgeCategory.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleActive(
      String badgeId, bool isActive) async {
    try {
      await _supabase.client
          .from('badges')
          .update({'is_active': isActive}).eq('id', badgeId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> createBadge({
    required String categoryId,
    required String name,
    required int value,
    String? image,
  }) async {
    try {
      await _supabase.client.from('badges').insert({
        'category_id': categoryId,
        'name': name,
        'value': value,
        'image': image,
        'is_active': true,
        'visible': true,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateBadge({
    required String badgeId,
    required String name,
    required int value,
    required String categoryId,
  }) async {
    try {
      await _supabase.client.from('badges').update({
        'name': name,
        'value': value,
        'category_id': categoryId,
      }).eq('id', badgeId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteBadge(String badgeId) async {
    try {
      await _supabase.client.from('badges').delete().eq('id', badgeId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
