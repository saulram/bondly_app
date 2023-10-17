import 'package:shared_preferences/shared_preferences.dart';

class SessionTokenUseCase {
  static const String tokenKey = "UserSessionToken";

  final SharedPreferences _sharedPreferences;

  SessionTokenUseCase(this._sharedPreferences);

  void update(String? token) {
    if (token != null) {
      _sharedPreferences.setString(tokenKey, token);
    }
  }
}
