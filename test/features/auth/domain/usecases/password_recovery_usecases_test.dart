import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/verify_reset_token_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_result/multiple_result.dart';

class _FakeAuthRepository extends AuthRepository {
  String? verifiedToken;
  String? verifiedEmail;
  String? confirmedToken;
  String? confirmedPassword;

  @override
  Future<Result<User, Exception>> doLogin(
    String user,
    String password,
    String company,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<String>, Exception>> getCompanies() {
    throw UnimplementedError();
  }

  @override
  Future<Result<bool, Exception>> resetPassword(String email) {
    throw UnimplementedError();
  }

  @override
  Future<Result<bool, Exception>> verifyResetToken(
    String token, {
    String? email,
  }) async {
    verifiedToken = token;
    verifiedEmail = email;
    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> confirmResetPassword(
    String token,
    String newPassword,
  ) async {
    confirmedToken = token;
    confirmedPassword = newPassword;
    return const Result.success(true);
  }
}

void main() {
  group('VerifyResetTokenUseCase', () {
    late _FakeAuthRepository repository;
    late VerifyResetTokenUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = VerifyResetTokenUseCase(repository);
    });

    test('forwards a trimmed 6 digit token and email', () async {
      final result = await useCase.invoke(
        ' 123456 ',
        email: ' user@example.com ',
      );

      expect(result.tryGetSuccess(), isTrue);
      expect(repository.verifiedToken, '123456');
      expect(repository.verifiedEmail, 'user@example.com');
    });

    test('rejects empty tokens', () async {
      final result = await useCase.invoke('');

      expect(result.tryGetError(), isA<EmptyLoginFieldsException>());
      expect(repository.verifiedToken, isNull);
    });

    test('rejects non numeric or incomplete tokens', () async {
      final incompleteResult = await useCase.invoke('12345');
      final nonNumericResult = await useCase.invoke('12A456');

      expect(incompleteResult.tryGetError(), isA<InvalidTokenException>());
      expect(nonNumericResult.tryGetError(), isA<InvalidTokenException>());
      expect(repository.verifiedToken, isNull);
    });
  });

  group('ResetPasswordUseCase', () {
    late _FakeAuthRepository repository;
    late ResetPasswordUseCase useCase;

    setUp(() {
      repository = _FakeAuthRepository();
      useCase = ResetPasswordUseCase(repository);
    });

    test('forwards token and password when confirmation is valid', () async {
      final result = await useCase.invoke(
        '123456',
        'new-password',
        'new-password',
      );

      expect(result.tryGetSuccess(), isTrue);
      expect(repository.confirmedToken, '123456');
      expect(repository.confirmedPassword, 'new-password');
    });

    test('rejects empty passwords', () async {
      final result = await useCase.invoke('123456', '', '');

      expect(result.tryGetError(), isA<EmptyLoginFieldsException>());
      expect(repository.confirmedToken, isNull);
    });

    test('rejects weak passwords', () async {
      final result = await useCase.invoke('123456', 'short', 'short');

      expect(result.tryGetError(), isA<WeakPasswordException>());
      expect(repository.confirmedToken, isNull);
    });

    test('rejects mismatched confirmation', () async {
      final result = await useCase.invoke(
        '123456',
        'new-password',
        'other-password',
      );

      expect(result.tryGetError(), isA<PasswordMismatchException>());
      expect(repository.confirmedToken, isNull);
    });
  });
}
