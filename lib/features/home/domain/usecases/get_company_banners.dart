import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetCompanyBannersUseCase {
  final BannersRepository repository;

  GetCompanyBannersUseCase(this.repository);

  Future<Result<CompanyBanners, Exception>> invoke(String token) async {
    try {
      return await repository.getBanners(token);
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }
}
