import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:multiple_result/multiple_result.dart';

class UserUnavailableException implements Exception {}
class UserUpdateException implements Exception {}

abstract class UsersRepository {
  Future<Result<User, Exception>> getUser();
  Future<void> insertUser(User user);
  Future<void> updateAvatar(List<dynamic> params);
  Future<void> clear();
}