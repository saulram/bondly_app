import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class VerifyResetTokenUseCase {
  final AuthRepository _repository;

  VerifyResetTokenUseCase(this._repository);

  Future<Result<bool, Exception>> invoke(String token, {String? email}) async {
    final trimmed = token.trim();
    if (trimmed.isEmpty) {
      return Result.error(EmptyLoginFieldsException());
    }

    if (!RegExp(r'^\d{6}$').hasMatch(trimmed)) {
      return Result.error(InvalidTokenException());
    }

    return _repository.verifyResetToken(trimmed, email: email?.trim());
  }
}
