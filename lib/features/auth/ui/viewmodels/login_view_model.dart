import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/domain/repositories/login_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_ui_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/viewmodels/app_viewmodel.dart';
import 'package:multiple_result/multiple_result.dart';

class LoginViewModel extends NavigationModel {
  final LoginUseCase _useCase = getIt<LoginUseCase>();
  final AppModel _appModel;
  LoginUIState? state;

  LoginViewModel(
    this._appModel
  );

  Future<void> onLoginAction(String user, String password) async {
    state = LoadingLogin();
    notifyListeners();

    final Result result = await _useCase.processLogin(user, password);
    result.when(
      (success) {
        state = SuccessLogin();
        _appModel.loginState = true;
        notifyListeners();

        navigation.pushReplacement("/home");
      },
      (error) {
        var errorType = LoginErrorType.authError;
        switch (error) {
          case EmptyLoginFieldsException _: errorType = LoginErrorType.invalidInputError;
          case InvalidLoginException _: errorType = LoginErrorType.authError;
          case TooManyLoginAttemptsException _: errorType = LoginErrorType.authError;
        }
        state = FailureLogin(errorType);

        notifyListeners();
      }
    );
  }
}