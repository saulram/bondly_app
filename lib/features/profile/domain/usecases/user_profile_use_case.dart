import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:multiple_result/multiple_result.dart';

class UserProfileUseCase {
  final UsersRepository repository;

  UserProfileUseCase(this.repository);

  Future<Result<UserProfile, Exception>> invoke(String userId) async {
    if (userId.isEmpty) {
      return Result.error(UserUnavailableException());
    }

    return repository.getFullProfile(userId);
  }

  Future<Result<bool, Exception>> update(String userId, UpdateProfileParams params) async {
    if (userId.isEmpty) {
      return Result.error(UserUnavailableException());
    }

    await repository.updateProfile(
      {
        "id": userId,
        "email": params.email,
        "location": params.location,
        "bDay": params.dob,
        "jobPosition": params.jobTitle,
      }
    );

    return Result.success(userId.isNotEmpty);
  }
}

class UpdateProfileParams {
  final String email;
  final String location;
  final String jobTitle;
  final String dob;

  UpdateProfileParams({
    required this.email,
    required this.location,
    required this.jobTitle,
    required this.dob
  });
}