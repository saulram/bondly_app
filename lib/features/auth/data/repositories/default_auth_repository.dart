import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultAuthRepository extends AuthRepository {
  final AuthAPI _authAPI;

  DefaultAuthRepository(this._authAPI);

  @override
  Future<Result<User, Exception>> doLogin(
      String user, String password, String company) async {
    try {
      User userDetails = await _authAPI.attemptLogin(user, password, company);
      return Result.success(userDetails);
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }

  @override
  Future<Result<List<String>, Exception>> getCompanies() async {
    try {
      return Result.success(await _authAPI.getCompanies());
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }

  @override
  Future<Result<bool, Exception>> resetPassword(String email) async {
    try {
      await _authAPI.resetPassword(email);
      return Result.success(true);
    } catch (exception) {
      return Result.error(PasswordResetException());
    }
  }

  @override
  Future<Result<bool, Exception>> verifyResetToken(
      String email, String token) async {
    try {
      await _authAPI.verifyResetToken(token);
      return Result.success(true);
    } catch (exception) {
      return Result.error(InvalidTokenException());
    }
  }

  @override
  Future<Result<bool, Exception>> confirmResetPassword(
      String token, String newPassword) async {
    try {
      await _authAPI.confirmResetPassword(token, newPassword);
      return Result.success(true);
    } catch (exception) {
      return Result.error(PasswordResetException());
    }
  }
}
