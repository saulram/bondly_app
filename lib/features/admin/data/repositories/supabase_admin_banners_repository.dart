import 'package:bondly_app/features/admin/domain/models/admin_banner.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminBannersRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminBannersRepository(this._supabase);

  Future<Result<List<AdminBanner>, Exception>> getBanners() async {
    try {
      final response = await _supabase.client
          .from('banners')
          .select()
          .order('created_at', ascending: false);
      final items = (response as List)
          .map((e) => AdminBanner.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleActive(
      String bannerId, bool isActive) async {
    try {
      await _supabase.client
          .from('banners')
          .update({'is_active': isActive}).eq('id', bannerId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> createBanner({
    required String name,
    String? slug,
    String? description,
    String? image,
  }) async {
    try {
      await _supabase.client.from('banners').insert({
        'name': name,
        'slug': slug,
        'description': description,
        'image': image,
        'is_active': true,
        'visible': true,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateBanner({
    required String bannerId,
    required String name,
    String? slug,
    String? description,
  }) async {
    try {
      await _supabase.client.from('banners').update({
        'name': name,
        'slug': slug,
        'description': description,
      }).eq('id', bannerId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteBanner(String bannerId) async {
    try {
      await _supabase.client.from('banners').delete().eq('id', bannerId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
