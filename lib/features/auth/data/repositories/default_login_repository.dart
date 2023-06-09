import 'package:bondly_app/features/auth/data/repositories/api/auth_api.dart';
import 'package:bondly_app/features/auth/domain/repositories/login_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultLoginRepository extends LoginRepository {
  final AuthAPI _authAPI;

  DefaultLoginRepository(this._authAPI);

  @override
  Future<Result<bool, Exception>> doLogin(String user, String password) async {
    try {
      await _authAPI.attemptLogin(user, password);
      return Result.success(true);
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }

}