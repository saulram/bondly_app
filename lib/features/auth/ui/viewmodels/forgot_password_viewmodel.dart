import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/auth/ui/states/forgot_password_ui_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class ForgotPasswordViewModel extends NavigationModel {
  final ForgotPasswordUseCase _useCase;

  ForgotPasswordUIState state = ForgotPasswordInitial();

  ForgotPasswordViewModel(this._useCase);

  Future<void> onResetPassword(String email) async {
    state = ForgotPasswordLoading();
    notifyListeners();

    final result = await _useCase.invoke(email);
    result.when(
      (success) {
        state = ForgotPasswordSuccess();
        notifyListeners();
      },
      (error) {
        final errorType = switch (error) {
          EmptyLoginFieldsException() => ForgotPasswordErrorType.emptyEmail,
          InvalidEmailException() => ForgotPasswordErrorType.invalidEmail,
          NoConnectionException() => ForgotPasswordErrorType.connectionError,
          _ => ForgotPasswordErrorType.unknownError,
        };
        state = ForgotPasswordFailed(errorType);
        notifyListeners();
      },
    );
  }

  void goBackToLogin() {
    navigation.go(LoginScreen.route);
  }
}
