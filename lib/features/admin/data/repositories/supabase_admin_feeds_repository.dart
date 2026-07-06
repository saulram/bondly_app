import 'package:bondly_app/features/admin/domain/models/admin_feed.dart';
import 'package:bondly_app/features/admin/domain/models/paginated_result.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminFeedsRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminFeedsRepository(this._supabase);

  Future<Result<PaginatedResult<AdminFeed>, Exception>> getFeeds({
    String? search,
    String? type,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final offset = (page - 1) * pageSize;

      var query = _supabase.client
          .from('account_feeds')
          .select('*, users(complete_name)');
      if (search != null && search.isNotEmpty) {
        query = query.or('header.ilike.%$search%,body.ilike.%$search%');
      }
      if (type != null && type.isNotEmpty) {
        query = query.eq('type', type);
      }
      // Single request: rows + exact total count
      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1)
          .count();

      final items = response.data
          .map((e) => AdminFeed.fromJson(e))
          .toList();

      return Result.success(PaginatedResult(
        items: items,
        total: response.count,
        page: page,
        pageSize: pageSize,
      ));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleVisible(
      String feedId, bool visible) async {
    try {
      await _supabase.client
          .from('account_feeds')
          .update({'visible': visible}).eq('id', feedId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleHighlighted(
      String feedId, bool highlighted) async {
    try {
      await _supabase.client
          .from('account_feeds')
          .update({'is_highlighted': highlighted}).eq('id', feedId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteFeed(String feedId) async {
    try {
      await _supabase.client.from('account_feeds').delete().eq('id', feedId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<List<AdminFeedComment>, Exception>> getComments(
      String feedId) async {
    try {
      final response = await _supabase.client
          .from('feed_comments')
          .select('*, users(complete_name)')
          .eq('feed_id', feedId)
          .order('created_at', ascending: false);
      final items = (response as List)
          .map((e) => AdminFeedComment.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteComment(String commentId) async {
    try {
      await _supabase.client
          .from('feed_comments')
          .delete()
          .eq('id', commentId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
