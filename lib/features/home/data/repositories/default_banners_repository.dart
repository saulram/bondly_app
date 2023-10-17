import 'package:bondly_app/features/home/data/repositories/api/banners_api.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:multiple_result/multiple_result.dart';

/// A repository implementation for fetching default banners from the server.
/// This class implements the [BannersRepository] abstract class.
/// It uses the [_bannersAPI] instance to fetch the banners from the server.
/// If an exception occurs during the API call, it returns a [Result] object with an [NoConnectionException] error.
class DefaultBannersRepository extends BannersRepository {
  final BannersAPI _bannersAPI;

  DefaultBannersRepository(this._bannersAPI);

  @override
  Future<Result<CompanyBanners, Exception>> getBanners() async {
    try {
      return Result.success(await _bannersAPI.getCompanyBanners());
    } catch (exception) {
      if (exception is TokenNotFoundException) {
        return Result.error(exception);
      }

      return Result.error(NoConnectionException());
    }
  }
}
