import 'package:bondly_app/features/auth/data/mappers/user_entity_mapper.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultUsersRepository extends UsersRepository {
  final UsersDao _usersDao;
  final UserEntityMapper _userMapper;

  DefaultUsersRepository(
    this._usersDao,
    this._userMapper,
  );

  @override
  Future<Result<User, Exception>> getUser() async {
    try {
      var userEntity = (await _usersDao.getUsers()).firstOrNull;
      if (userEntity == null) {
        return Result.error(UserUnavailableException());
      }

      return Result.success(
        _userMapper.map(
          from: userEntity
        )
      );
    } catch (exception) {
      return Result.error(UserUnavailableException());
    }
  }

  @override
  Future<void> insertUser(User user) async {
    _usersDao.saveUser(_userMapper.mapReverse(user));
  }

  @override
  Future<void> clear() async {
    _usersDao.removeAll();
  }

}