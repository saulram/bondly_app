import 'dart:io';

import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:bondly_app/features/profile/domain/usecases/update_user_avatar_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/user_profile_use_case.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileViewModel extends NavigationModel {
  final UserUseCase userUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserAvatarUseCase updateUserUseCase;
  final UserProfileUseCase profileUseCase;
  User? user;
  UserProfile? userProfile;
  bool showUserUpdateError = false;

  ProfileViewModel({
    required this.userUseCase,
    required this.logoutUseCase,
    required this.updateUserUseCase,
    required this.profileUseCase
  });

  Future<void> load({bool remote = true}) async {
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
        handleError(error);
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
      await updateUserUseCase.invoke(user?.id ?? "", file);
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

  Future<void> saveMyData({
    required String email,
    required String location,
    required String dob,
    required String job
  }) async {
    try {
      await profileUseCase.update(
        userProfile?.id ?? "",
        UpdateProfileParams(
            email: email,
            location: location,
            jobTitle: job,
            dob: dob
        )
      );
    } finally {
      busy = false;
      notifyListeners();
      navigation.pop();
    }
  }

  Future<void> loadUserData() async {
    await load(remote: false);

    busy = true;
    notifyListeners();

    try {
      final result = await profileUseCase.invoke(user?.id ?? "");
      result.when(
          (profile) => userProfile = profile,
          (error) => handleError(error)
      );
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void handleError(Exception error) {
    if (error is UserUnavailableException) {
      closeSession();
    }
    load(remote: false);
    Logger().e(error);
  }
}
