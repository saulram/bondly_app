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

      var query = _supabase.client.from('users').select();
      if (search != null && search.isNotEmpty) {
        query =
            query.or('complete_name.ilike.%$search%,email.ilike.%$search%');
      }
      if (role != null && role.isNotEmpty) {
        query = query.eq('role', role);
      }
      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      // Single request: rows + exact total count
      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1)
          .count();

      final items =
          response.data.map((e) => AdminUser.fromJson(e)).toList();

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

  Future<Result<String, Exception>> createUser({
    required String email,
    required String completeName,
    required String role,
    required int monthlyPoints,
  }) async {
    try {
      final response = await _supabase.client.functions.invoke(
        'admin-create-user',
        body: {
          'email': email,
          'complete_name': completeName,
          'role': role,
          'monthly_points': monthlyPoints,
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data['success'] != true) {
        return Result.error(Exception(data['message'] ?? 'Error al crear usuario'));
      }
      return Result.success(data['data']['user_id'] as String);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<Map<String, int>, Exception>> getUserPoints(
      String userId) async {
    try {
      final row = await _supabase.client
          .from('user_points')
          .select('to_give, earned')
          .eq('user_id', userId)
          .maybeSingle();
      return Result.success({
        'to_give': (row?['to_give'] as int?) ?? 0,
        'earned': (row?['earned'] as int?) ?? 0,
      });
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateUserPoints({
    required String userId,
    required int toGive,
    required int earned,
  }) async {
    try {
      // Row always exists (created by on_auth_user_created trigger);
      // user_points has no INSERT policy, so upsert would fail RLS.
      await _supabase.client
          .from('user_points')
          .update({'to_give': toGive, 'earned': earned})
          .eq('user_id', userId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<Set<String>, Exception>> getUserZones(String userId) async {
    try {
      final response = await _supabase.client
          .from('user_zones')
          .select('zone_id')
          .eq('user_id', userId);
      return Result.success((response as List)
          .map((e) => e['zone_id'] as String)
          .toSet());
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> setUserZones(
      String userId, Set<String> zoneIds) async {
    try {
      await _supabase.client.from('user_zones').delete().eq('user_id', userId);
      if (zoneIds.isNotEmpty) {
        await _supabase.client.from('user_zones').insert(zoneIds
            .map((z) => {'user_id': userId, 'zone_id': z})
            .toList());
      }
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
