import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_account_statement_usecase.dart';
import 'package:logger/logger.dart';

class AccountStatementViewModel extends NavigationModel {
  final GetAccountStatementUseCase _getAccountStatementUseCase;
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  AccountStatementViewModel(this._getAccountStatementUseCase) {
    logger.i("AccountStatementViewModel created");
    init();
  }

  void init() {
    getAccountStatement();
  }

  AccountStatement _accountStatement = AccountStatement();

  AccountStatement get accountStatement => _accountStatement;
  set accountStatement(AccountStatement accountStatement) {
    _accountStatement = accountStatement;
    notifyListeners();
  }

  Future<void> getAccountStatement() async {
    busy = true;
    try {
      var response = await _getAccountStatementUseCase.invoke();

      response.when((userAccountStatement) {
        accountStatement = userAccountStatement;
        busy = false;
      }, (error) => {logger.e(error)});
    } catch (e) {
      logger.e(e);
    }
  }

}
