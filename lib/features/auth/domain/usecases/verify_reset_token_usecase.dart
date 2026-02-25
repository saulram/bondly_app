import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class VerifyResetTokenUseCase {
  final AuthRepository _repository;

  VerifyResetTokenUseCase(this._repository);

  Future<Result<bool, Exception>> invoke(String token) async {
    final trimmed = token.trim();
    if (trimmed.isEmpty || trimmed.length < 6) {
      return Result.error(EmptyLoginFieldsException());
    }

    return _repository.verifyResetToken(trimmed);
  }
}
