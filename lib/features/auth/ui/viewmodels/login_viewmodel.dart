import 'package:bondly_app/config/strings_login.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/get_login_companies_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_state_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:bondly_app/features/auth/ui/states/login_ui_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:multiple_result/multiple_result.dart';

class LoginViewModel extends NavigationModel {
  final LoginUseCase _useCase;
  final GetCompaniesUseCase _companiesUseCase;
  final GetLoginStateUseCase _loginStateUseCase;

  LoginUIState? state;
  List<String> companies = [];

  LoginViewModel(
    this._useCase,
    this._companiesUseCase,
    this._loginStateUseCase
  );

  Future<void> onLoginAction(
      String user,
      String password,
      String company
  ) async {
    state = LoadingLogin();
    notifyListeners();

    final Result result = await _useCase.invoke(user, password, company);
    result.when(
      (success) {
        state = SuccessLogin();
        notifyListeners();
        _loginStateUseCase.update(true);

        navigation.pushReplacement(AppRouter.homeScreenRoute);
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
        _loginStateUseCase.update(false);
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