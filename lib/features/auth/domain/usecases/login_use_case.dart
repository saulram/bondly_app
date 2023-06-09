import 'package:bondly_app/features/auth/domain/repositories/login_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<Result<bool, Exception>> processLogin(String user, String password) async {
    if (user.isNotEmpty && password.isNotEmpty) {
      return await repository.doLogin(user, password);
    } else {
      return Result.error(EmptyLoginFieldsException());
    }
  }
}