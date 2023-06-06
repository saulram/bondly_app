import 'package:multiple_result/multiple_result.dart';

abstract class LoginRepository {
  Future<Result<bool, Exception>> doLogin(String user, String password);
}