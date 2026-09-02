import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseBannersRepository extends BannersRepository {
  final SupabaseClientProvider _provider;

  SupabaseBannersRepository(this._provider);

  @override
  Future<Result<CompanyBanners, Exception>> getBanners() async {
    try {
      final response = await _provider.client
          .from('banners')
          .select()
          .eq('is_active', true)
          .eq('visible', true)
          .order('created_at', ascending: false);

      final banners = (response as List)
          .map((row) => Banner.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Result.success(CompanyBanners(
        success: true,
        banners: banners,
      ));
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }
}
