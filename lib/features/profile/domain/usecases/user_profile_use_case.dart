import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:multiple_result/multiple_result.dart';

class UserProfileUseCase {
  final UsersRepository repository;

  UserProfileUseCase(this.repository);

  Future<Result<UserProfile, Exception>> invoke(String userId) async {
    return repository.getFullProfile(userId);
  }

  Future<void> update(UpdateProfileParams params) async {

  }
}

class UpdateProfileParams {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String jobTitle;
  final String dob;

  UpdateProfileParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.jobTitle,
    required this.dob
  });
}