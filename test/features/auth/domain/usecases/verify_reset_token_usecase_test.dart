import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/verify_reset_token_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late VerifyResetTokenUseCase useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = VerifyResetTokenUseCase(repository);
  });

  test('passes the email and six digit recovery code to the repository',
      () async {
    when(() => repository.verifyResetToken('user@example.com', '123456'))
        .thenAnswer((_) async => Result.success(true));

    final result = await useCase.invoke(' user@example.com ', ' 123456 ');

    expect(result.tryGetSuccess(), isTrue);
    verify(() => repository.verifyResetToken('user@example.com', '123456'))
        .called(1);
  });

  test('rejects a missing email before calling the repository', () async {
    final result = await useCase.invoke('', '123456');

    expect(result.tryGetError(), isA<EmptyLoginFieldsException>());
    verifyNever(() => repository.verifyResetToken(any(), any()));
  });

  test('rejects a short recovery code before calling the repository', () async {
    final result = await useCase.invoke('user@example.com', '123');

    expect(result.tryGetError(), isA<EmptyLoginFieldsException>());
    verifyNever(() => repository.verifyResetToken(any(), any()));
  });
}
