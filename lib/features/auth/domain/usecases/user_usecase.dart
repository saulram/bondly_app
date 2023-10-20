
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class UserUseCase {
  final UsersRepository _repository;
  final UsersRepository _remoteRepository;

  UserUseCase(this._repository, this._remoteRepository);

  void update(User user) {
    try {
      _repository.insertUser(user);
    } catch (exception) {
      Logger().e((exception as Exception).toString());
    }
  }

  Future<Result<User, Exception>> invoke({bool remote = false}) async {
    if (remote) {
      var userResult = await _remoteRepository.getUser();
      userResult.when((user) => update(user), (error) => error);
      return userResult;
    }
    return await _repository.getUser();
  }
}