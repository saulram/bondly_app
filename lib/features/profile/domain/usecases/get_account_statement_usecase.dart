import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/account_statement_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class GetAccountStatementUseCase {
  final AccountStatementRepository _repository;

  GetAccountStatementUseCase(this._repository);

  Future<Result<AccountStatement, Exception>> invoke() async {
    return _repository.getAccountStatement();
  }
}
