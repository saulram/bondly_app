import 'package:bondly_app/features/suggestions/domain/models/suggestion.dart';
import 'package:bondly_app/features/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseSuggestionsRepository extends SuggestionsRepository {
  final SupabaseClientProvider _provider;

  SupabaseSuggestionsRepository(this._provider);

  @override
  Future<Result<void, Exception>> submit({
    required String message,
    String? title,
    String? category,
    required bool anonymous,
  }) async {
    try {
      final userId = _provider.client.auth.currentUser?.id;
      await _provider.client.from('suggestions').insert({
        // Anonymous rows must not carry an author id (enforced by RLS too).
        'user_id': anonymous ? null : userId,
        'is_anonymous': anonymous,
        'title': title,
        'category': category,
        'message': message,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(SuggestionException(e.toString()));
    }
  }

  @override
  Future<Result<List<Suggestion>, Exception>> getMine() async {
    try {
      // RPC (SECURITY DEFINER): returns only the caller's own non-anonymous
      // suggestions, without the internal admin_note field.
      final response = await _provider.client.rpc('get_my_suggestions');
      final items = (response as List)
          .map((e) => Suggestion.fromSupabase(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(SuggestionException(e.toString()));
    }
  }
}
