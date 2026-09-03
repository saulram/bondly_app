import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:multiple_result/multiple_result.dart';

class InvalidLoginException implements Exception {}

class EmptyLoginFieldsException implements Exception {}

class NoConnectionException implements Exception {}

class TooManyLoginAttemptsException implements Exception {}

class DefaultCompanyException implements Exception {}

class TokenNotFoundException implements Exception {}

class PasswordResetException implements Exception {}

class InvalidTokenException implements Exception {}

class ExpiredTokenException implements Exception {}

class WeakPasswordException implements Exception {}

abstract class AuthRepository {
  Future<Result<User, Exception>> doLogin(
      String user, String password, String company);
  Future<Result<List<String>, Exception>> getCompanies();
  Future<Result<bool, Exception>> resetPassword(String email);
  Future<Result<bool, Exception>> verifyResetToken(String email, String token);
  Future<Result<bool, Exception>> confirmResetPassword(
      String token, String newPassword);
}
