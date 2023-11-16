import 'dart:io';

import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';

class UpdateUserAvatarUseCase {
  final UsersRepository remoteRepository;

  UpdateUserAvatarUseCase(this.remoteRepository);

  Future<void> invoke(String userId, File file) async {
    if (userId.isEmpty) {
      throw UserUpdateException();
    }

    await remoteRepository.updateAvatar(
      [userId, file]
    );
  }
}