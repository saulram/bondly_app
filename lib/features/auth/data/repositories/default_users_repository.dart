import 'package:bondly_app/features/auth/data/mappers/points_entity_mapper.dart';
import 'package:bondly_app/features/auth/data/mappers/upgrade_entity_mapper.dart';
import 'package:bondly_app/features/auth/data/mappers/user_entity_mapper.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/storage/data/local/dao/points_dao.dart';
import 'package:bondly_app/features/storage/data/local/dao/upgrade_dao.dart';
import 'package:bondly_app/features/storage/data/local/dao/users_dao.dart';
import 'package:multiple_result/multiple_result.dart';

class DefaultUsersRepository extends UsersRepository {
  final UsersDao _usersDao;
  final PointsDao _pointsDao;
  final UpgradeDao _upgradeDao;
  final UserEntityMapper _userMapper;
  final PointsEntityMapper _pointsEntityMapper;
  final UpgradeEntityMapper _upgradeEntityMapper;

  DefaultUsersRepository(
    this._usersDao,
    this._pointsDao,
    this._upgradeDao,
    this._userMapper,
    this._pointsEntityMapper,
    this._upgradeEntityMapper
  );

  @override
  Future<Result<User, Exception>> getUser() async {
    try {
      var userEntity = (await _usersDao.getUsers()).firstOrNull;
      if (userEntity == null) {
        return Result.error(UserUnavailableException());
      }

      var pointsEntity = await _pointsDao.getUserPointsById(
        userEntity.employeeNumber
      );
      var upgradeEntity = await _upgradeDao.getUserUpgradeById(
        userEntity.employeeNumber
      );

      return Result.success(
        _userMapper.map(
          from: userEntity,
          points: _pointsEntityMapper.map(pointsEntity),
          upgrade: _upgradeEntityMapper.map(upgradeEntity)
        )
      );
    } catch (exception) {
      return Result.error(UserUnavailableException());
    }
  }

  @override
  Future<void> insertUser(User user) async {
    _usersDao.saveUser(_userMapper.mapReverse(user));
    if (user.points != null) {
      _pointsDao.saveUserPoints(
        _pointsEntityMapper.mapReverse(
          user.points!,
          user.employeeNumber ?? 1
        )
      );
    }

    if (user.upgrade != null) {
      _upgradeDao.saveUserUpgrade(
          _upgradeEntityMapper.mapReverse(
              user.upgrade!,
              user.employeeNumber ?? 1
          )
      );
    }
  }

}