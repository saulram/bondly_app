import 'package:bondly_app/features/profile/data/api/account_balance_api.dart';
import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/account_statement_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultAccountStatementRepository extends AccountStatementRepository {
  final AccountBalanceAPI _api;

  DefaultAccountStatementRepository(this._api);

  @override
  Future<Result<AccountStatement, Exception>> getAccountStatement() async {
    try {
      var result = await _api.getAccountStatement();
      return Result.success(result);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
