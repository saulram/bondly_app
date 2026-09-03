import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_account_statement_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/update_user_avatar_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/user_profile_use_case.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class _MockUserUseCase extends Mock implements UserUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

class _MockUpdateUserAvatarUseCase extends Mock
    implements UpdateUserAvatarUseCase {}

class _MockUserProfileUseCase extends Mock implements UserProfileUseCase {}

class _MockGetAccountStatementUseCase extends Mock
    implements GetAccountStatementUseCase {}

void main() {
  test('a load failure stops and exposes an error without retrying forever',
      () async {
    final userUseCase = _MockUserUseCase();
    final expectedError = Exception('network unavailable');
    when(() => userUseCase.invoke(remote: any(named: 'remote')))
        .thenAnswer((_) async => Result.error(expectedError));

    final viewModel = ProfileViewModel(
      userUseCase: userUseCase,
      logoutUseCase: _MockLogoutUseCase(),
      updateUserUseCase: _MockUpdateUserAvatarUseCase(),
      profileUseCase: _MockUserProfileUseCase(),
      getAccountStatementUseCase: _MockGetAccountStatementUseCase(),
    );

    await viewModel.load();

    expect(viewModel.busy, isFalse);
    expect(viewModel.loadError, same(expectedError));
    verify(() => userUseCase.invoke(remote: true)).called(1);
    verifyNoMoreInteractions(userUseCase);
  });
}
