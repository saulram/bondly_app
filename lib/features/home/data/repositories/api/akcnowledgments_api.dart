
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class CreateAcknowledgmentAPI {
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

  CreateAcknowledgmentAPI(this._callsHandler);

  Future<bool> createAcknowledgment(String badgeId, String message,List<String> recipients) async {
    try {
      Map<String, dynamic> data = {"message": message,"badge_id":badgeId,"recipients":recipients};
      var response = await _callsHandler.post(
          path: "acknowledgments/", data: data);
      log.i("Company Feeds Response: ${response.body}");

      return true;
    } catch (exception) {
      log.e("Acknowledgment Creation Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
