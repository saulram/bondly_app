import 'package:bondly_app/features/admin/domain/models/admin_exchange.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminExchangesRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminExchangesRepository(this._supabase);

  Future<Result<List<AdminExchange>, Exception>> getExchanges({
    String? search,
    String? status,
  }) async {
    try {
      var query = _supabase.client
          .from('exchanges')
          .select('*, users(complete_name, email), rewards(name)');

      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      final response =
          await query.order('created_at', ascending: false).limit(100);

      var items = (response as List)
          .map((e) => AdminExchange.fromJson(e as Map<String, dynamic>))
          .toList();

      if (search != null && search.isNotEmpty) {
        final q = search.toLowerCase();
        items = items
            .where((e) =>
                (e.userName?.toLowerCase().contains(q) ?? false) ||
                (e.userEmail?.toLowerCase().contains(q) ?? false) ||
                (e.rewardName?.toLowerCase().contains(q) ?? false))
            .toList();
      }

      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> updateStatus(
      String exchangeId, String status) async {
    try {
      await _supabase.client
          .from('exchanges')
          .update({'status': status}).eq('id', exchangeId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
