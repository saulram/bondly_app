import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/category_badges.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class BadgesAPI {
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

  BadgesAPI(this._callsHandler);

  Future<Badges> getCategoryBadges(String categoryId) async {
    try {
      var response = await _callsHandler.get(
        path: "badge/category/$categoryId",
      );
      log.i("Company Categories Response: ${response.body}");
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return Badges.fromJson(jsonMap);
    } catch (exception) {
      log.e("Company Feeds Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
