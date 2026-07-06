import 'package:bondly_app/features/admin/domain/models/admin_ambassador.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAdminAmbassadorsRepository {
  final SupabaseClientProvider _supabase;

  SupabaseAdminAmbassadorsRepository(this._supabase);

  Future<Result<List<AdminAmbassador>, Exception>> getAmbassadors() async {
    try {
      final response = await _supabase.client
          .from('ambassadors')
          .select('*, users(complete_name, email, avatar), badges(name, image)')
          .order('date', ascending: false);
      final items = (response as List)
          .map((e) => AdminAmbassador.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> toggleVisible(
      String ambassadorId, bool visible) async {
    try {
      await _supabase.client
          .from('ambassadors')
          .update({'visible': visible}).eq('id', ambassadorId);
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> recalculate() async {
    try {
      await _supabase.client.rpc('calculate_monthly_ambassadors');
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
