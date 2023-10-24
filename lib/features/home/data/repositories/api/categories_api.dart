import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/company_categories.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class CategoriesAPI {
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

  CategoriesAPI(this._callsHandler);

  Future<Categories> getCompanyCategories() async {
    try {
      var response = await _callsHandler.get(
        path: "badgeCategory/account",
      );
      log.i("Company Categories Response: ${response.body}");
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return Categories.fromJson(jsonMap);
    } catch (exception) {
      log.e("Company Feeds Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
