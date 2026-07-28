import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/src/supabase_client_provider.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, AuthSessionMissingException, OtpType, UserAttributes;

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
      final email =
          await _provider.client.rpc('get_email_by_employee', params: {
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
      await _provider.client.auth.resetPasswordForEmail(email.trim());
      return Result.success(true);
    } on AuthException catch (exception) {
      return Result.error(_mapPasswordResetException(exception));
    } catch (_) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<bool, Exception>> verifyResetToken(
    String token, {
    String? email,
  }) async {
    final normalizedEmail = email?.trim() ?? '';
    if (normalizedEmail.isEmpty) {
      return Result.error(InvalidTokenException());
    }

    try {
      await _provider.client.auth.verifyOTP(
        email: normalizedEmail,
        token: token.trim(),
        type: OtpType.recovery,
      );
      return Result.success(true);
    } on AuthException catch (exception) {
      return Result.error(_mapVerifyTokenException(exception));
    } catch (_) {
      return Result.error(NoConnectionException());
    }
  }

  @override
  Future<Result<bool, Exception>> confirmResetPassword(
      String token, String newPassword) async {
    try {
      await _provider.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return Result.success(true);
    } on AuthException catch (exception) {
      return Result.error(_mapConfirmPasswordException(exception));
    } catch (_) {
      return Result.error(NoConnectionException());
    }
  }

  Exception _mapPasswordResetException(AuthException exception) {
    if (_isRateLimit(exception)) {
      return TooManyLoginAttemptsException();
    }

    return PasswordResetException();
  }

  Exception _mapVerifyTokenException(AuthException exception) {
    if (exception.code == 'otp_expired') {
      return ExpiredTokenException();
    }

    if (_isRateLimit(exception)) {
      return TooManyLoginAttemptsException();
    }

    return InvalidTokenException();
  }

  Exception _mapConfirmPasswordException(AuthException exception) {
    if (exception is AuthSessionMissingException ||
        exception.code == 'session_not_found') {
      return TokenNotFoundException();
    }

    if (exception.code == 'same_password') {
      return SamePasswordException();
    }

    if (exception.code == 'weak_password') {
      return WeakPasswordException();
    }

    return PasswordResetException();
  }

  bool _isRateLimit(AuthException exception) {
    return exception.statusCode == '429' ||
        exception.code == 'over_request_rate_limit' ||
        exception.code == 'over_email_send_rate_limit';
  }
}
