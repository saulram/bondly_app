import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';

class SupabaseAuthRepository extends AuthRepository {
  final SupabaseClientProvider _provider;

  SupabaseAuthRepository(this._provider);

  @override
  Future<Result<User, Exception>> doLogin(
    String user,
    String password,
    String company,
  ) async {
    try {
      final response = await _provider.client.auth.signInWithPassword(
        email: user,
        password: password,
      );

      final session = response.session;
      if (session == null || response.user == null) {
        return Result.error(InvalidLoginException());
      }

      final userData = await _provider.client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      final userModel = User.fromSupabaseAuth(userData, session.accessToken);
      return Result.success(userModel);
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }

  @override
  Future<Result<List<String>, Exception>> getCompanies() async {
    try {
      final response = await _provider.client
          .from('users')
          .select('company_name');

      final companies = (response as List)
          .map((row) => row['company_name'] as String?)
          .where((name) => name != null && name.isNotEmpty)
          .map((name) => name!)
          .toSet()
          .toList();

      return Result.success(companies);
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }
}
