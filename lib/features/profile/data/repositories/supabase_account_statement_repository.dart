import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/account_statement_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAccountStatementRepository extends AccountStatementRepository {
  final SupabaseClientProvider _provider;

  SupabaseAccountStatementRepository(this._provider);

  String? get _currentUserId => _provider.client.auth.currentUser?.id;

  @override
  Future<Result<AccountStatement, Exception>> getAccountStatement() async {
    try {
      final response = await _provider.client
          .from('account_statements')
          .select('*, statement_transactions(*)')
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      return Result.success(AccountStatement.fromSupabase(response));
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
