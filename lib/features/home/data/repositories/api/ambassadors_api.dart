import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/embassys_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class AmbassadorsAPI {
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

  AmbassadorsAPI(this._callsHandler);

  Future<List<Embassy>> getUserEmbassys(String userId) async {
    try {
      var response = await _callsHandler.get(
        path: "ambassador/user/$userId",
      );
      log.i("Embassys Response: ${response.body}");
      Map<String, dynamic> jsonMap = json.decode(response.body);

      Embassys embassys = Embassys.fromJson(jsonMap);
      return embassys.embassy!;
    } catch (exception) {
      log.e("Embassys Exception: ${exception.toString()}");
      rethrow;
    }
  }
}
