import 'dart:io';

import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/update_user_usecase.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class ProfileViewModel extends NavigationModel {
  final UserUseCase userUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;

  User? user;
  bool showUserUpdateError = false;

  ProfileViewModel({
    required this.userUseCase,
    required this.logoutUseCase,
    required this.updateUserUseCase
  });

  void load({bool remote = true}) async {
    busy = true;
    notifyListeners();

    Result<User, Exception> result = await userUseCase.invoke(remote: remote);
    result.when(
      (user) {
        this.user = user;
        busy = false;
        notifyListeners();
      },
      (error) {
        busy = false;
        notifyListeners();
        if (error is UserUnavailableException) {
          closeSession();
        }
        load(remote: false);
        Logger().e(error);
      }
    );
  }

  Future<void> closeSession() async {
    await logoutUseCase.invoke();
    navigation.go(LoginScreen.route);
  }

  Future<void> updateAvatar(File file) async {
    busy = true;
    notifyListeners();

    try {
      await updateUserUseCase.invoke(
        user?.id ?? "",
        file
      );
      load(remote: true);
    } catch (exception) {
      if (exception is UserUpdateException) {
        showUserUpdateError = true;
      }
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}
