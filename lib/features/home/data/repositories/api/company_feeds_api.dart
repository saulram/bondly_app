import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class CompanyFeedsAPI {
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

  CompanyFeedsAPI(this._callsHandler);

  Future<CompanyFeed> getCompanyFeeds() async {
    try {
      var response = await _callsHandler.get(path: "accountFeeds/feeds/");
      log.i("Company Feeds Response: ${response.body}");
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return CompanyFeed.fromJson(jsonMap);
    } catch (exception) {
      log.e("Company Feeds Exception: ${exception.toString()}");
      rethrow;
    }
  }

  Future<FeedData> getFeedById(String feedId) async {
    try {
      var response = await _callsHandler.get(path: "accountFeeds/feeds/$feedId");
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return FeedData.fromJson(jsonMap["data"]);
    } catch (exception) {
      log.e("Company Feeds Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
