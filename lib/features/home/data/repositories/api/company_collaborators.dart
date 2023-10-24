import 'dart:convert';

import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class CompanyCollaboratorsAPI {
  final ApiCallsHandler _callsHandler;
  final Logger log = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 220,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));

  CompanyCollaboratorsAPI(this._callsHandler);

  Future<List<User>> getCompanyCollaborator() async {
    try {
      var response = await _callsHandler.get(path: "users/company_users/");

      Map<String, dynamic> jsonMap = json.decode(response.body);
      List<User> users = [];
      jsonMap['data'].forEach((user) {
        users.add(User.fromSingleJson(user));
      });
      log.i("Company Users Response: ${response.statusCode}");
      return users;
    } catch (exception) {
      log.e("Company Collaborators Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
