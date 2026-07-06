import 'package:bondly_app/features/admin/domain/models/zone.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminZonesRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminZonesRepository(this._supabase);

  Future<Result<List<Zone>, Exception>> getZones() async {
    try {
      final response = await _supabase.client
          .from('zones')
          .select()
          .order('name', ascending: true);
      final items = (response as List)
          .map((e) => Zone.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<Map<String, int>, Exception>> getZoneUserCounts() async {
    try {
      // ponytail: downloads all user_zones rows to count client-side; fine
      // for single-tenant scale, switch to a group-by RPC if it grows large
      final response =
          await _supabase.client.from('user_zones').select('zone_id');
      final counts = <String, int>{};
      for (final row in response as List) {
        final zoneId = row['zone_id'] as String?;
        if (zoneId != null) counts[zoneId] = (counts[zoneId] ?? 0) + 1;
      }
      return Result.success(counts);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> createZone({
    required String name,
    String? description,
    String? parentZoneId,
  }) async {
    try {
      await _supabase.client.from('zones').insert({
        'name': name,
        'description': description,
        'parent_zone_id': parentZoneId,
        'is_active': true,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateZone({
    required String zoneId,
    required String name,
    String? description,
    String? parentZoneId,
  }) async {
    try {
      await _supabase.client.from('zones').update({
        'name': name,
        'description': description,
        'parent_zone_id': parentZoneId,
      }).eq('id', zoneId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> deleteZone(String zoneId) async {
    try {
      await _supabase.client.from('zones').delete().eq('id', zoneId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
