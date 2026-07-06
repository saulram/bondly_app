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
      // Single-tenant: look up email by employee number only (no company filter)
      final email = await _provider.client.rpc('get_email_by_employee', params: {
        'p_employee_number': int.tryParse(user) ?? 0,
      });

      if (email == null || (email as String).isEmpty) {
        return Result.error(InvalidLoginException());
      }

      final response = await _provider.client.auth.signInWithPassword(
        email: email,
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
    // Single-tenant deployment: each Supabase instance belongs to one company.
    // Company list is not needed — the login screen hides the dropdown for Supabase.
    return Result.success([]);
  }

  @override
  Future<Result<bool, Exception>> resetPassword(String email) async {
    try {
      await _provider.client.auth.resetPasswordForEmail(email);
      return Result.success(true);
    } catch (exception) {
      return Result.error(PasswordResetException());
    }
  }

  @override
  Future<Result<bool, Exception>> verifyResetToken(String token) async {
    // TODO: Implement Supabase token verification
    return Result.error(InvalidTokenException());
  }

  @override
  Future<Result<bool, Exception>> confirmResetPassword(
      String token, String newPassword) async {
    // TODO: Implement Supabase password reset confirmation
    return Result.error(PasswordResetException());
  }
}
