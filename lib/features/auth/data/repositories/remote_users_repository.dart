import 'package:bondly_app/features/auth/data/repositories/api/users_api.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:multiple_result/multiple_result.dart';

class RemoteUsersRepository extends UsersRepository {
  static const String name = "RemoteUsersRepository";
  final UsersAPI _usersApi;

  RemoteUsersRepository(this._usersApi);

  @override
  Future<void> clear() {
    throw UnimplementedError();
  }

  @override
  Future<Result<User, Exception>> getUser() async {
    try {
      User userDetails = await _usersApi.getUser();
      return Result.success(userDetails);
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }

  @override
  Future<void> insertUser(User user) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateAvatar(List<dynamic> params) async {
    try {
      if (params.isEmpty) {
        throw UserUpdateException();
      }
      await _usersApi.updateAvatar(params.first, params.last);
    } catch(exception) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(Map<String, String> data) async {
    await _usersApi.updateUserProfile(data);
  }

  @override
  Future<Result<UserProfile, Exception>> getFullProfile(String userId) async {
    try {
      final userDetails = await _usersApi.getFullProfile(userId);
      return Result.success(userDetails);
    } catch (exception) {
      return Result.error(InvalidLoginException());
    }
  }
}