import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Result<bool, Exception>> invoke(
    String token,
    String password,
    String confirmPassword,
  ) async {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return Result.error(EmptyLoginFieldsException());
    }

    if (password.length < 8) {
      return Result.error(WeakPasswordException());
    }

    if (password != confirmPassword) {
      return Result.error(PasswordMismatchException());
    }

    return _repository.confirmResetPassword(token, password);
  }
}

class PasswordMismatchException implements Exception {}
