import 'dart:convert';

import 'package:bondly_app/features/auth/domain/usecases/session_token_usecase.dart';
import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class BannersAPI {
  final ApiCallsHandler _callsHandler;
  final SessionTokenUseCase _sessionTokenUseCase;
  String token = "";

  BannersAPI(this._callsHandler, this._sessionTokenUseCase) {
    getUserToken();
  }

  Future<void> getUserToken() async {
    try {
      Result<String, dynamic> result = _sessionTokenUseCase.invoke();
      result.when((token) {
        this.token = token;
      }, (error) {
        Logger().e(error.toString());
      });
    } catch (exception) {
      Logger().e(exception.toString());
    }
  }

  Future<CompanyBanners> getCompanyBanners() async {
    try {
      var response = await _callsHandler.get(path: "banner/", extraHeaders: {
        "Content-Type": "application/json",
        "Authorization": token
      });
      Logger().i(response.body);
      return CompanyBanners.fromJson(json.decode(response.body));
    } catch (exception) {
      Logger().e(exception.toString());
      throw NoConnectionException();
    }
  }
}
