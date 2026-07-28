sealed class ResetPasswordUIState {}

class ResetPasswordInitial extends ResetPasswordUIState {}

class ResetPasswordLoading extends ResetPasswordUIState {}

class ResetPasswordSuccess extends ResetPasswordUIState {}

class ResetPasswordFailed extends ResetPasswordUIState {
  final ResetPasswordErrorType errorType;

  ResetPasswordFailed(this.errorType);
}

enum ResetPasswordErrorType {
  emptyPassword,
  weakPassword,
  passwordsDoNotMatch,
  samePassword,
  missingRecoverySession,
  connectionError,
  unknownError,
}
