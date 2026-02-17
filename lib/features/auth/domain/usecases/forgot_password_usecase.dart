import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Result<bool, Exception>> invoke(String email) async {
    if (email.trim().isEmpty) {
      return Result.error(EmptyLoginFieldsException());
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email.trim())) {
      return Result.error(InvalidEmailException());
    }

    return _repository.resetPassword(email.trim());
  }
}

class InvalidEmailException implements Exception {}
