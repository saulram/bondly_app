import 'package:bondly_app/features/auth/domain/repositories/login_repository.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class AuthAPI {
  final ApiCallsHandler _callsHandler;

  AuthAPI(this._callsHandler);

  Future<void> attemptLogin(String user, String password) async {
    try {
      final params = {"employeeNumber" : user, "password" : password };
      await _callsHandler.post(
          "users/login/",
          data: params
      );
    } catch (exception) {
      Logger().e(exception.toString());
      throw InvalidLoginException();
    }
  }
}