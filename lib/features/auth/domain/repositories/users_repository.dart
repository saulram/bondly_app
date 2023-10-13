import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:multiple_result/multiple_result.dart';

class UserUnavailableException implements Exception {}

abstract class UsersRepository {
  Future<Result<User, Exception>> getUser();
  Future<void> insertUser(User user);
}