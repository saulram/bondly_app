import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class CreateCommentAPI {
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

  CreateCommentAPI(this._callsHandler);

  Future<FeedData> createComment(String feedId, String message) async {
    try {
      Map<String, dynamic> data = {"message": message};
      var response = await _callsHandler.post(
          path: "accountFeeds/feeds/$feedId/comments", data: data);
      log.i("Company Feeds Response: ${response.body}");
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return FeedData.fromJson(jsonMap["data"]);
    } catch (exception) {
      log.e("Company Feeds Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
