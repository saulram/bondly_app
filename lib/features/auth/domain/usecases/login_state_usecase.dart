import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLoginStateUseCase {
  static const String _loginStateKey = "LoginState";
  final SharedPreferences _sharedPreferences;

  GetLoginStateUseCase(this._sharedPreferences);

  Result<bool, dynamic> invoke() {
    try {
      var loginState = _sharedPreferences.getBool(_loginStateKey);
      return Result.success(loginState ?? false);
    } catch (exception) {
      return const Result.success(false);
    }
  }

  void update(String? token) {
    _sharedPreferences.setBool(_loginStateKey, token != null);
  }
}