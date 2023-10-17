import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionTokenHandler extends SessionTokenHandler {
  static const String _sessionTokenKey = "SESSION_TOKEN_KEY";

  final SharedPreferences _preferences;

  AuthSessionTokenHandler(
    this._preferences
  );

  @override
  void save(String token) {
    _preferences.setString(_sessionTokenKey, token);
  }

  @override
  String? get() {
    return _preferences.getString(_sessionTokenKey);
  }

  @override
  void clear() {
    _preferences.remove(_sessionTokenKey);
  }
}