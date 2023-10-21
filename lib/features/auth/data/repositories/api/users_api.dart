import 'dart:convert';
import 'dart:io';

import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class UsersAPI {
  final ApiCallsHandler _callsHandler;

  UsersAPI(this._callsHandler);

  Future<User> getUser() async {
    try {
      var response = await _callsHandler.get(path: "users/profile");
      return User.fromJson(json.decode(response.body));
    } catch (exception) {
      Logger().e(exception.toString());
      throw NoConnectionException();
    }
  }

  Future<void> updateAvatar(String id, File avatar) async {
    try {
      await _callsHandler.sendMultipart(
          method: Methods.PUT.name,
          path: "users/uploadAvatar/$id",
          file: avatar
      );
    } catch (exception) {
      Logger().e(exception.toString());
      throw NoConnectionException();
    }
  }
}