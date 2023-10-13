
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class UserUseCase {
  final UsersRepository _repository;

  UserUseCase(this._repository);

  void update(User user) {
    try {
      _repository.insertUser(user);
    } catch (exception) {
      Logger().e((exception as Exception).toString());
    }
  }

  Future<Result<User, Exception>> invoke() async {
    return await _repository.getUser();
  }
}