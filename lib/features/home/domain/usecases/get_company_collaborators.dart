import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/home/domain/repositories/company_feeds_respository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetCompanyCollaboratorsUseCase {
  final CompanyFeedsRepository repository;

  GetCompanyCollaboratorsUseCase(this.repository);

  Future<Result<List<User>, Exception>> invoke() async {
    return await repository.getCompanyCollaborators();
  }
}
