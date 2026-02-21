sealed class VerifyResetTokenUIState {}

class VerifyResetTokenInitial extends VerifyResetTokenUIState {}

class VerifyResetTokenLoading extends VerifyResetTokenUIState {}

class VerifyResetTokenSuccess extends VerifyResetTokenUIState {}

class VerifyResetTokenFailed extends VerifyResetTokenUIState {
  final VerifyResetTokenErrorType errorType;

  VerifyResetTokenFailed(this.errorType);
}

enum VerifyResetTokenErrorType {
  emptyToken,
  invalidToken,
  expiredToken,
  connectionError,
  unknownError,
}
