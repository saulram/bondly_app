import 'dart:convert';

import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class AuthAPI {
  final ApiCallsHandler _callsHandler;

  AuthAPI(this._callsHandler);

  Future<List<String>> getCompanies() async {
    try {
      var response = await _callsHandler.get(path: "users/companies/");
      return (json.decode(response.body)["data"] as List)
          .map((e) => e.toString())
          .toList();
    } catch (exception) {
      Logger().e(exception.toString());
      throw NoConnectionException();
    }
  }

  Future<User> attemptLogin(
      String userName, String password, String company) async {
    try {
      final params = {
        "employeeNumber": userName,
        "password": password,
        "companyName": company
      };
      var response =
          await _callsHandler.post(path: "users/login/", data: params);

      User user = User.fromJson(json.decode(response.body));
      return user;
    } catch (exception) {
      Logger().e(exception.toString());
      throw InvalidLoginException();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _callsHandler.post(
        path: "users/reset-password/",
        data: {"email": email},
      );
    } catch (exception) {
      Logger().e(exception.toString());
      throw PasswordResetException();
    }
  }

  Future<void> verifyResetToken(String token) async {
    try {
      await _callsHandler.post(
        path: "users/verify-reset-token/",
        data: {"token": token},
      );
    } catch (exception) {
      Logger().e(exception.toString());
      throw InvalidTokenException();
    }
  }

  Future<void> confirmResetPassword(String token, String newPassword) async {
    try {
      await _callsHandler.post(
        path: "users/confirm-reset-password/",
        data: {"token": token, "password": newPassword},
      );
    } catch (exception) {
      Logger().e(exception.toString());
      throw PasswordResetException();
    }
  }
}
