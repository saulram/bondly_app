sealed class ForgotPasswordUIState {}

class ForgotPasswordInitial extends ForgotPasswordUIState {}

class ForgotPasswordLoading extends ForgotPasswordUIState {}

class ForgotPasswordSuccess extends ForgotPasswordUIState {}

class ForgotPasswordFailed extends ForgotPasswordUIState {
  final ForgotPasswordErrorType errorType;

  ForgotPasswordFailed(this.errorType);
}

enum ForgotPasswordErrorType {
  emptyEmail,
  invalidEmail,
  tooManyAttempts,
  connectionError,
  unknownError,
}
