import 'dart:convert';

import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class AccountBalanceAPI {
  final ApiCallsHandler _callsHandler;
  final Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  AccountBalanceAPI(
    this._callsHandler,
  );

  Future<AccountStatement> getAccountStatement() async {
    try {
      Response response = await _callsHandler.get(path: "accountStatement/");
      log.i("### GetAccount Statement Response: ${response.statusCode}");
      return AccountStatement.fromJson(
        json.decode(response.body),
      );
    } catch (exception) {
      log.e("### GetAccount Statement Exception: $exception");
      throw NoConnectionException();
    }
  }
}
