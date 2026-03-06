import 'package:bondly_app/features/admin/domain/models/admin_user.dart';
import 'package:bondly_app/features/admin/domain/models/paginated_result.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminUsersRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminUsersRepository(this._supabase);

  Future<Result<PaginatedResult<AdminUser>, Exception>> getUsers({
    String? search,
    String? role,
    bool? isActive,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final offset = (page - 1) * pageSize;

      // Build data query
      var dataQuery = _supabase.client.from('users').select();
      if (search != null && search.isNotEmpty) {
        dataQuery = dataQuery.or(
            'complete_name.ilike.%$search%,email.ilike.%$search%');
      }
      if (role != null && role.isNotEmpty) {
        dataQuery = dataQuery.eq('role', role);
      }
      if (isActive != null) {
        dataQuery = dataQuery.eq('is_active', isActive);
      }

      final dataResponse = await dataQuery
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1);

      // Build count query (same filters, no range)
      var countQuery = _supabase.client.from('users').select();
      if (search != null && search.isNotEmpty) {
        countQuery = countQuery.or(
            'complete_name.ilike.%$search%,email.ilike.%$search%');
      }
      if (role != null && role.isNotEmpty) {
        countQuery = countQuery.eq('role', role);
      }
      if (isActive != null) {
        countQuery = countQuery.eq('is_active', isActive);
      }
      final countResponse = await countQuery.count();

      final items = (dataResponse as List)
          .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList();
      final total = countResponse.count;

      return Result.success(PaginatedResult(
        items: items,
        total: total,
        page: page,
        pageSize: pageSize,
      ));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleActive(
      String userId, bool isActive) async {
    try {
      await _supabase.client
          .from('users')
          .update({'is_active': isActive}).eq('id', userId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateRole(
      String userId, String role) async {
    try {
      await _supabase.client
          .from('users')
          .update({'role': role}).eq('id', userId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
