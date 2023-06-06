import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_ui_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';

class LoginViewModel extends NavigationModel {
  final LoginUseCase _useCase;
  final AppModel _appModel;
  LoginUIState? state;

  LoginViewModel(
    this._useCase,
    this._appModel
  );

  Future<void> onLoginAction() async {
    state = LoadingLogin();
    notifyListeners();

    // Simulate a login
    await Future.delayed(const Duration(seconds: 2));
    _appModel.loginState = true;

    state = SuccessLogin();
    notifyListeners();
    navigation.pushReplacement("/home");
  }
}