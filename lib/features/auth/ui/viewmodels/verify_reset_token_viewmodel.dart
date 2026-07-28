import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/verify_reset_token_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/reset_password_screen.dart';
import 'package:bondly_app/features/auth/ui/states/verify_reset_token_ui_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class VerifyResetTokenViewModel extends NavigationModel {
  final VerifyResetTokenUseCase _verifyUseCase;
  final ForgotPasswordUseCase _resendUseCase;

  VerifyResetTokenUIState state = VerifyResetTokenInitial();

  VerifyResetTokenViewModel(this._verifyUseCase, this._resendUseCase);

  Future<void> onVerifyToken(String token, {String? email}) async {
    state = VerifyResetTokenLoading();
    notifyListeners();

    final result = await _verifyUseCase.invoke(token, email: email);
    result.when(
      (success) {
        state = VerifyResetTokenSuccess();
        notifyListeners();
        navigation.push(ResetPasswordScreen.route, extra: {"token": token});
      },
      (error) {
        final errorType = switch (error) {
          EmptyLoginFieldsException() => VerifyResetTokenErrorType.emptyToken,
          InvalidTokenException() => VerifyResetTokenErrorType.invalidToken,
          ExpiredTokenException() => VerifyResetTokenErrorType.expiredToken,
          TooManyLoginAttemptsException() =>
            VerifyResetTokenErrorType.tooManyAttempts,
          NoConnectionException() => VerifyResetTokenErrorType.connectionError,
          _ => VerifyResetTokenErrorType.unknownError,
        };
        state = VerifyResetTokenFailed(errorType);
        notifyListeners();
      },
    );
  }

  Future<void> onResendCode(String email) async {
    state = VerifyResetTokenLoading();
    notifyListeners();

    final result = await _resendUseCase.invoke(email);
    result.when(
      (success) {
        state = VerifyResetTokenInitial();
        notifyListeners();
      },
      (error) {
        state = VerifyResetTokenFailed(VerifyResetTokenErrorType.unknownError);
        notifyListeners();
      },
    );
  }
}
