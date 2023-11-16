import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class HandleLikeAPI {
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

  HandleLikeAPI(this._callsHandler);

  Future<bool> handlelike(String feedId) async {
    try {
      var response = await _callsHandler.post(
        path: "accountFeeds/feeds/$feedId/likes",
      );
      log.i("Company Feeds Response: ${response.body}");

      return true;
    } catch (exception) {
      log.e("Company Feeds Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
