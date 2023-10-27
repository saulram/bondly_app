import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/announcement_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class AnnouncementsAPI {
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

  AnnouncementsAPI(this._callsHandler);

  Future<Announcements> getCompanyAnnouncements() async {
    try {
      var response = await _callsHandler.get(
        path: "news",
      );
      log.i("Announcements Response: ${response.body}");
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return Announcements.fromJson(jsonMap);
    } catch (exception) {
      log.e("Announcements Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
