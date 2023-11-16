import 'dart:convert';

import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class BondlyBadgesAPI {
  final ApiCallsHandler _callsHandler;
  final Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  BondlyBadgesAPI(
    this._callsHandler,
  );

  Future<BondlyBadges> getBondlyBadges() async {
    try {
      Response response = await _callsHandler.get(path: "badge/myBadges");
      log.i("### GetBondlyBadges Response: ${response.statusCode}");
      return BondlyBadges.fromJson(json.decode(response.body)["data"]);
    } catch (exception) {
      log.e("### GetBondlyBadges Exception: $exception");
      throw NoConnectionException();
    }
  }
}
