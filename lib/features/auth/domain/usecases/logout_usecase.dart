import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutUseCase {
  final SharedPreferences sharedPreferences;
  final UsersRepository usersRepository;

  LogoutUseCase({
    required this.sharedPreferences,
    required this.usersRepository
  });

  Future<void> invoke() async {
    try {
      // Call logout
    } finally {
      sharedPreferences.clear();
      usersRepository.clear();
    }
  }
}