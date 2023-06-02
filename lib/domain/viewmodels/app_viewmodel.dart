// ignore: non_constant_identifier_names
import 'dart:async';

import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/domain/viewmodels/base_model.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

String LOGIN_KEY = "5FD6G46SDF4GD64F1VG9SD68";
// ignore: non_constant_identifier_names
String ONBOARD_KEY = "GD2G82CG9G82VDFGVD22DVG";

class AppModel extends NavigationModel {
  late final SharedPreferences sharedPreferences;
  final StreamController<bool> _loginStateChange = StreamController<bool>.broadcast();
  bool _loginState = true;
  bool _initialized = false;
  bool _onboarding = false;

  AppModel(this.sharedPreferences){
   print("AppModel nav: _loginState: ${navigation.location}");
  }

  bool get loginState => _loginState;
  bool get initialized => _initialized;
  bool get onboarding => _onboarding;
  Stream<bool> get loginStateChange => _loginStateChange.stream;

  set loginState(bool state) {
    sharedPreferences.setBool(LOGIN_KEY, state);
    _loginState = state;
    _loginStateChange.add(state);
    notifyListeners();
  }

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  set onboarding(bool value) {
    sharedPreferences.setBool(ONBOARD_KEY, value);
    _onboarding = value;
    notifyListeners();
  }

  Future<void> onAppStart() async {
    print("AppModel onAppStart");
    _onboarding = sharedPreferences.getBool(ONBOARD_KEY) ?? false;
    _loginState = sharedPreferences.getBool(LOGIN_KEY) ?? false;

    // This is just to demonstrate the splash screen is working.
    // In real-life applications, it is not recommended to interrupt the user experience by doing such things.
    _initialized = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 0), () {
      print("AppModel onAppStart: shouldRedirectToLogin");
      shouldRedirectToLogin();
    });

  }
  void shouldRedirectToLogin()  {
      if(!_loginState) {
        print("AppModel shouldRedirectToLogin: redirecting to login");
        navigation.pushReplacement("/login");
      }else{
        navigation.pushReplacement("/home");
      }
  }
}
