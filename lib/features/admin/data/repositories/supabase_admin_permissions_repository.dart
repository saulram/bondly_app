import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_user.dart';
import 'package:bondly_app/features/admin/domain/models/admin_user_with_permissions.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminPermissionsRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminPermissionsRepository(this._supabase);

  Future<Result<List<AdminUserWithPermissions>, Exception>>
      getAdminUsersWithPermissions() async {
    try {
      // Independent queries — run concurrently
      final usersFuture = _supabase.client
          .from('users')
          .select()
          .inFilter('role', ['admin', 'superAdmin']).order('complete_name');
      final permsFuture = _supabase.client
          .from('admin_permissions')
          .select('user_id, permission');

      final usersResponse = await usersFuture;
      final permsResponse = await permsFuture;

      final permsByUser = <String, Set<AdminModule>>{};
      for (final row in permsResponse as List) {
        final userId = row['user_id'] as String?;
        final module = AdminModule.fromString(row['permission'] as String? ?? '');
        if (userId != null && module != null) {
          permsByUser.putIfAbsent(userId, () => {}).add(module);
        }
      }

      final items = (usersResponse as List).map((e) {
        final user = AdminUser.fromJson(e as Map<String, dynamic>);
        final perms = permsByUser[user.id] ?? <AdminModule>{};
        return AdminUserWithPermissions(user: user, permissions: perms);
      }).toList();

      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> grantPermission(
      String userId, AdminModule module) async {
    try {
      await _supabase.client.from('admin_permissions').upsert({
        'user_id': userId,
        'permission': module.value,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> revokePermission(
      String userId, AdminModule module) async {
    try {
      await _supabase.client
          .from('admin_permissions')
          .delete()
          .eq('user_id', userId)
          .eq('permission', module.value);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
