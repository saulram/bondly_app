import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';

class LoginViewModel extends NavigationModel {
  // Get the app Model from the locator
   final AppModel _appModel = getIt<AppModel>();

  Future<void> login() async {
    // Simulate a login
    await Future.delayed(const Duration(seconds: 2));
    _appModel.loginState = true;
    navigation.pushReplacement("/home");
  }
}