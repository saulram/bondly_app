import 'package:bondly_app/features/base/domain/repositories/supabase_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultSupabaseRepository extends SupabaseRepository {
  final SupabaseClientProvider _clientProvider;

  DefaultSupabaseRepository(this._clientProvider);

  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> getAll(
    String table,
  ) async {
    try {
      final response = await _clientProvider.client.from(table).select();
      return Result.success(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return Result.error(SupabaseQueryException(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> getById(
    String table,
    String id,
  ) async {
    try {
      final response =
          await _clientProvider.client.from(table).select().eq('id', id).single();
      return Result.success(Map<String, dynamic>.from(response));
    } catch (e) {
      return Result.error(SupabaseQueryException(e.toString()));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>, Exception>> query(
    String table, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      var query = _clientProvider.client.from(table).select();
      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }
      final response = await query;
      return Result.success(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return Result.error(SupabaseQueryException(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response =
          await _clientProvider.client.from(table).insert(data).select().single();
      return Result.success(Map<String, dynamic>.from(response));
    } catch (e) {
      return Result.error(SupabaseQueryException(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> update(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _clientProvider.client
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return Result.success(Map<String, dynamic>.from(response));
    } catch (e) {
      return Result.error(SupabaseQueryException(e.toString()));
    }
  }

  @override
  Future<Result<void, Exception>> delete(String table, String id) async {
    try {
      await _clientProvider.client.from(table).delete().eq('id', id);
      return Result.success(null);
    } catch (e) {
      return Result.error(SupabaseQueryException(e.toString()));
    }
  }
}
