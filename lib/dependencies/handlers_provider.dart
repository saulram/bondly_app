import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/data/handlers/auth_session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/src/api_calls_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandlersProvider {
  static provide() {
    getIt.registerSingleton<SessionTokenHandler>(
      AuthSessionTokenHandler(getIt<SharedPreferences>())
    );

    getIt.registerSingleton<ApiCallsHandler>(
      //TO-DO: Fetch these values from right place
        ApiCallsHandler(
            appVersion: "1",
            buildNumber: "1",
            sessionTokenHandler: getIt<SessionTokenHandler>()));
  }
}