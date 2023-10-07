
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetCompaniesUseCase {
  final AuthRepository repository;

  GetCompaniesUseCase(this.repository);

  Future<Result<List<String>, Exception>> invoke() async {
    try {
      return await repository.getCompanies();
    } catch (exception) {
      return Result.error(NoConnectionException());
    }
  }

}