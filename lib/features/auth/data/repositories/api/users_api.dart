import 'dart:convert';
import 'dart:io';

import 'package:bondly_app/features/auth/data/repositories/api/mappers/user_activity_response_mapper.dart';
import 'package:bondly_app/features/auth/data/repositories/api/models/user_activity_response.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class UsersAPI {
  final ApiCallsHandler _callsHandler;
  final UserActivityResponseMapper _activityMapper;

  UsersAPI(
    this._callsHandler,
    this._activityMapper
  );

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

  Future<UserActivityHolder> loadActivity(
      String id,
      int limit,
      int page
  ) async {
    try {
      var response = await _callsHandler.get(
          path: "activity",
          params: {
              "user_id": id,
              "limit": limit.toString(),
              "page": page.toString(),
          }
      );
      var activityResponse = PaginatedUserActivityResponse.fromJson(
          json.decode(response.body)
      );

      if (!activityResponse.success) {
        throw NoConnectionException();
      }

      return _activityMapper.map(activityResponse);
    } catch (exception) {
      Logger().e(exception.toString());
      throw NoConnectionException();
    }
  }

  Future<bool> updateActivity(String activityId) async {
    try {
      await _callsHandler.put(
        path: "activity/$activityId",
        data: {"read": true}
      );
      return true;
    } catch (exception) {
      Logger().e(exception.toString());
      throw NoConnectionException();
    }
  }

  Future<UserProfile> getFullProfile(String userId) async {
    try {
      var response = await _callsHandler.get(path: "userProfile/user/$userId");
      Map<String, dynamic> data = json.decode(response.body)["data"];
      Map<String, dynamic> userMap = {"data": data["user_id"]};
      return UserProfile(
          User.fromJson(userMap),
          data["companyName"] ?? "",
          data["jobPosition"] ?? "",
          data["location"] ?? "",
          DateTime.parse(data["bDay"]),
          data["_id"] ?? ""
      );
    } catch (exception) {
      Logger().e(exception.toString());
      rethrow;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, String> data) async {
    try {
      await _callsHandler.put(path: "userProfile/$userId", data: data);
    } catch (exception) {
      Logger().e(exception.toString());
      throw NoConnectionException();
    }
  }
}