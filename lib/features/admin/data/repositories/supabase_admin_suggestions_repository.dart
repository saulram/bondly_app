import 'package:bondly_app/features/admin/domain/models/admin_suggestion.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminSuggestionsRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminSuggestionsRepository(this._supabase);

  /// Suggestions with the author joined. Anonymous rows have no author.
  /// [status] optionally filters by lifecycle stage.
  Future<Result<List<AdminSuggestion>, Exception>> getSuggestions({
    String? status,
  }) async {
    try {
      var query = _supabase.client
          .from('suggestions')
          .select('*, author:users(complete_name)')
          .eq('visible', true);
      if (status != null) query = query.eq('status', status);
      final response = await query
          .order('created_at', ascending: false)
          // ponytail: newest-100 cap like exchanges; add range() paging if it fills
          .limit(100);
      final items = (response as List)
          .map((e) => AdminSuggestion.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateStatus(String id, String status) async {
    try {
      await _supabase.client
          .from('suggestions')
          .update({'status': status}).eq('id', id);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateNote(String id, String? note) async {
    try {
      await _supabase.client
          .from('suggestions')
          .update({'admin_note': note}).eq('id', id);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> delete(String id) async {
    try {
      await _supabase.client.from('suggestions').delete().eq('id', id);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
