import 'package:bondly_app/features/storage/data/local/entities/user_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UsersDao {
  @Query('SELECT * FROM UserEntity')
  Future<List<UserEntity>> getUsers();

  @Query('SELECT * FROM UserEntity WHERE employeeNumber = :id')
  Stream<UserEntity?> getUserById(int id);

  @insert
  Future<void> saveUser(UserEntity user);
}