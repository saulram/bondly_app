import 'package:bondly_app/features/auth/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);
}