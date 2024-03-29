import 'package:bondly_app/config/strings_login.dart';
import 'package:bondly_app/features/auth/domain/handlers/session_token_handler.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/get_login_companies_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/states/login_ui_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/screens/home_screen.dart';
import 'package:multiple_result/multiple_result.dart';

class LoginViewModel extends NavigationModel {
  final LoginUseCase _useCase;
  final GetCompaniesUseCase _companiesUseCase;
  final GetLoginStateUseCase _loginStateUseCase;
  final UserUseCase _userUseCase;
  final SessionTokenHandler _tokenHandler;

  LoginUIState? state;
  List<String> companies = [];

  LoginViewModel(
    this._useCase,
    this._companiesUseCase,
    this._loginStateUseCase,
    this._userUseCase,
    this._tokenHandler
  );

  Future<void> onLoginAction(
      String username,
      String password,
      String company
  ) async {
    state = LoadingLogin();
    notifyListeners();

    final Result<User, Exception> result = await _useCase.invoke(username, password, company);
    result.when(
      (user) {
        if (user.token == null) {
          state = FailedLogin(LoginErrorType.authError);
          notifyListeners();
          return;
        }

        _loginStateUseCase.update(user.token);
        _userUseCase.update(user);
        _tokenHandler.save(user.token!);

        state = SuccessLogin();
        notifyListeners();

        navigation.go(HomeScreen.route);
      },
      (error) {
        var errorType = LoginErrorType.authError;
        switch (error) {
          case EmptyLoginFieldsException _: errorType = LoginErrorType.invalidInputError;
          case InvalidLoginException _: errorType = LoginErrorType.authError;
          case TooManyLoginAttemptsException _: errorType = LoginErrorType.authError;
          case NoConnectionException _: errorType = LoginErrorType.connectionError;
          case DefaultCompanyException _: errorType = LoginErrorType.defaultCompanyError;
        }
        _loginStateUseCase.update(null);
        state = FailedLogin(errorType);
        notifyListeners();
      }
    );
  }

  Future<void > load() async {
    if (companies.isNotEmpty) {
      return;
    }

    state = LoadingLogin();
    notifyListeners();

    final Result<List<String>, Exception> result = await _companiesUseCase.invoke();

    result.when((success) {
      companies.add(LoginStrings.selectYourCompany);
      companies.addAll(success);

      state = SuccessCompaniesLoad();
      notifyListeners();
    }, (error) {
      state = FailedCompaniesLoad();
      notifyListeners();
    });
  }
}