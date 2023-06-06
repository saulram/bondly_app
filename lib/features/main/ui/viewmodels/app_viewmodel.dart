// ignore: non_constant_identifier_names
import 'dart:async';

import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AppModel extends NavigationModel {
  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  final SharedPreferences sharedPreferences;
  bool _loginState = false;

  AppModel(this.sharedPreferences){
    log.i("AppModel");
  }

  bool get loginState => _loginState;

  set loginState(bool value) {
    _loginState = value;
    notifyListeners();
  }

}
