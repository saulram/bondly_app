import 'package:bondly_app/features/home/domain/models/embassys_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetUserEmbassysUseCase {
  final CompanyFeedsRepository repository;

  GetUserEmbassysUseCase(this.repository);

  Future<Result<List<Embassy>, Exception>> invoke(String userId) async {
    return await repository.getUserEmbassys(userId);
  }
}
