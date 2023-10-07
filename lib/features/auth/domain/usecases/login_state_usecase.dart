import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLoginStateUseCase {
  final SharedPreferences _sharedPreferences;
  static const String _loginStateKey = "LoginState";

  GetLoginStateUseCase(this._sharedPreferences);

  Result<bool, dynamic> invoke() {
    try {
      var loginState = _sharedPreferences.getBool(_loginStateKey);
      return Result.success(loginState ?? false);
    } catch (exception) {
      return Result.success(false);
    }
  }

  void update(bool value) {
    _sharedPreferences.setBool(_loginStateKey, value);
  }
}