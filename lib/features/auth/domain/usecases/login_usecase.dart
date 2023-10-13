import 'package:bondly_app/config/strings_login.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<User, Exception>> invoke(
      String user,
      String password,
      String company
  ) async {
    if (company == LoginStrings.selectYourCompany || company.isEmpty) {
      return Result.error(DefaultCompanyException());
    }
    if (user.isNotEmpty && password.isNotEmpty) {
      return await _repository.doLogin(user, password, company);
    } else {
      return Result.error(EmptyLoginFieldsException());
    }
  }
}