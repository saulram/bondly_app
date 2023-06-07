import 'package:bondly_app/src/api_calls_handler.dart';

class AuthAPI {
  final ApiCallsHandler _callsHandler;

  AuthAPI(this._callsHandler);

  Future<void> attemptLogin(String user, String password) async {
    final params = {"employeeNumber" : user, "password" : password };
    await _callsHandler.post(
      "users/login/",
      data: params
    );
  }
}