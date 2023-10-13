import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionTokenUseCase {
  static const String _tokenKey = "UserSessionToken";

  final SharedPreferences _sharedPreferences;

  SessionTokenUseCase(this._sharedPreferences);

  Result<String, dynamic> invoke() {
    try {
      var token = _sharedPreferences.getString(_tokenKey);
      if (token != null) {
        return Result.success(token);
      }

      return Result.error(TokenNotFoundException());
    } catch (exception) {
      return Result.error(TokenNotFoundException());
    }
  }
  void update(String? token) {
    if (token != null) {
      _sharedPreferences.setString(_tokenKey, token);
    }
  }
}