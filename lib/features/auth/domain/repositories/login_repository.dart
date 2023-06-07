import 'package:multiple_result/multiple_result.dart';

class InvalidLoginException implements Exception {}
class EmptyLoginFieldsException implements Exception {}
class TooManyLoginAttemptsException implements Exception {}

abstract class LoginRepository {
  Future<Result<bool, Exception>> doLogin(String user, String password);
}