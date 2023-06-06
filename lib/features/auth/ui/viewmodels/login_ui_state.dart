sealed class LoginUIState {}

class LoadingLogin extends LoginUIState {}

class SuccessLogin extends LoginUIState {}

class FailureLogin extends LoginUIState {
  LoginErrorType errorType;

  FailureLogin(this.errorType);
}

enum LoginErrorType {
  authError,
  connectionError,
  unknownError
}