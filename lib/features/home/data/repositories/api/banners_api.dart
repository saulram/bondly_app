import 'dart:convert';

import 'package:bondly_app/features/home/domain/models/company_banners_model.dart';
import 'package:bondly_app/features/home/domain/repositories/banners_repository.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:logger/logger.dart';

class BannersAPI {
  final ApiCallsHandler _callsHandler;

  BannersAPI(this._callsHandler);

  Future<CompanyBanners> getCompanyBanners(String token) async {
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
