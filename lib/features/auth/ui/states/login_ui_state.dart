sealed class LoginUIState {}

class SuccessCompaniesLoad extends LoginUIState {}

class LoadingLogin extends LoginUIState {}

class SuccessLogin extends LoginUIState {}

class FailedCompaniesLoad extends LoginUIState {}

class FailedLogin extends LoginUIState {
  LoginErrorType errorType;

  FailedLogin(this.errorType);
}

enum LoginErrorType {
  authError,
  connectionError,
  invalidInputError,
  unknownError,
  defaultCompanyError
}