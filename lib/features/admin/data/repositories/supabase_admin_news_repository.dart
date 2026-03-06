import 'package:bondly_app/features/admin/domain/models/admin_news.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminNewsRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminNewsRepository(this._supabase);

  Future<Result<List<AdminNews>, Exception>> getNews() async {
    try {
      // Admins can see all news (visible = true, regardless of hidden)
      final response = await _supabase.client
          .from('news')
          .select()
          .eq('visible', true)
          .order('created_at', ascending: false);
      final items = (response as List)
          .map((e) => AdminNews.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleHidden(
      String newsId, bool hidden) async {
    try {
      await _supabase.client
          .from('news')
          .update({'hidden': hidden}).eq('id', newsId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> createNews({
    required String title,
    String? content,
    String? image,
  }) async {
    try {
      await _supabase.client.from('news').insert({
        'title': title,
        'content': content,
        'image': image,
        'hidden': false,
        'visible': true,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateNews({
    required String newsId,
    required String title,
    String? content,
  }) async {
    try {
      await _supabase.client.from('news').update({
        'title': title,
        'content': content,
      }).eq('id', newsId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteNews(String newsId) async {
    try {
      await _supabase.client.from('news').delete().eq('id', newsId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
