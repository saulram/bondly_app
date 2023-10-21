import 'dart:io';

import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';

class UpdateUserUseCase {
  final UsersRepository remoteRepository;

  UpdateUserUseCase(this.remoteRepository);

  Future<void> invoke(String userId, File file) async {
    if (userId.isEmpty) {
      throw UserUpdateException();
    }

    await remoteRepository.updateAvatar(
      [userId, file]
    );
  }
}