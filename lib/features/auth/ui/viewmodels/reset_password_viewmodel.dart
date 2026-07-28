import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/reset_password_confirmation_screen.dart';
import 'package:bondly_app/features/auth/ui/states/reset_password_ui_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class ResetPasswordViewModel extends NavigationModel {
  final ResetPasswordUseCase _useCase;

  ResetPasswordUIState state = ResetPasswordInitial();

  ResetPasswordViewModel(this._useCase);

  Future<void> onResetPassword(
    String token,
    String password,
    String confirmPassword,
  ) async {
    state = ResetPasswordLoading();
    notifyListeners();

    final result = await _useCase.invoke(token, password, confirmPassword);
    result.when(
      (success) {
        state = ResetPasswordSuccess();
        notifyListeners();
        navigation.push(ResetPasswordConfirmationScreen.route);
      },
      (error) {
        final errorType = switch (error) {
          EmptyLoginFieldsException() => ResetPasswordErrorType.emptyPassword,
          WeakPasswordException() => ResetPasswordErrorType.weakPassword,
          PasswordMismatchException() =>
            ResetPasswordErrorType.passwordsDoNotMatch,
          SamePasswordException() => ResetPasswordErrorType.samePassword,
          TokenNotFoundException() =>
            ResetPasswordErrorType.missingRecoverySession,
          NoConnectionException() => ResetPasswordErrorType.connectionError,
          _ => ResetPasswordErrorType.unknownError,
        };
        state = ResetPasswordFailed(errorType);
        notifyListeners();
      },
    );
  }
}
