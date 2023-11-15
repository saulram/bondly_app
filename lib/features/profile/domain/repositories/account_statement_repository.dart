import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:multiple_result/multiple_result.dart';

class NoMoreContentException implements Exception {}

class NoActivityIdFoundException implements Exception {}

abstract class AccountStatementRepository {
  Future<Result<AccountStatement, Exception>> getAccountStatement();
}
