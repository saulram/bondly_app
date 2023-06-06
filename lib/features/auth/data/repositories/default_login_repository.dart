import 'package:bondly_app/features/auth/domain/repositories/login_repository.dart';
import 'package:multiple_result/src/result.dart';

class DefaultLoginRepository extends LoginRepository {
  @override
  Future<Result<bool, Exception>> doLogin(String user, String password) {
    // TODO: implement doLogin
    throw UnimplementedError();
  }

}