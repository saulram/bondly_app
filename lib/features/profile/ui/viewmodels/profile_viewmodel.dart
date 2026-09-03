import 'dart:typed_data';

import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/account_statement_model.dart';
import 'package:bondly_app/features/profile/domain/models/user_profile.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_account_statement_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/update_user_avatar_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/user_profile_use_case.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class ProfileViewModel extends NavigationModel {
  final UserUseCase userUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserAvatarUseCase updateUserUseCase;
  final UserProfileUseCase profileUseCase;
  final GetAccountStatementUseCase getAccountStatementUseCase;
  User? user;
  UserProfile? userProfile;
  bool showUserUpdateError = false;
  Exception? loadError;

  int? _spendableBalance;
  int? get spendableBalance => _spendableBalance;

  ProfileViewModel(
      {required this.userUseCase,
      required this.logoutUseCase,
      required this.updateUserUseCase,
      required this.profileUseCase,
      required this.getAccountStatementUseCase});

  Future<void> load({bool remote = true}) async {
    busy = true;
    loadError = null;
    notifyListeners();

    Result<User, Exception> result = await userUseCase.invoke(remote: remote);
    result.when((user) {
      this.user = user;
      busy = false;
      notifyListeners();
      fetchSpendableBalance();
    }, (error) {
      busy = false;
      notifyListeners();
      handleError(error);
    });
  }

  Future<void> fetchSpendableBalance() async {
    Result<AccountStatement, Exception> result =
        await getAccountStatementUseCase.invoke();
    result.when((statement) {
      _spendableBalance = statement.balance;
      notifyListeners();
    }, (error) {
      Logger().e("Error fetching spendable balance: $error");
    });
  }

  Future<void> closeSession() async {
    await logoutUseCase.invoke();
    navigation.go(LoginScreen.route);
  }

  Future<void> updateAvatar(Uint8List bytes) async {
    busy = true;
    notifyListeners();

    try {
      await updateUserUseCase.invoke(user?.id ?? "", bytes);
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

  Future<void> saveMyData(
      {required String email,
      required String location,
      required String dob,
      required String job}) async {
    try {
      await profileUseCase.update(
          userProfile?.id ?? "",
          UpdateProfileParams(
              email: email, location: location, jobTitle: job, dob: dob));
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
          (profile) => userProfile = profile, (error) => handleError(error));
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void handleError(Exception error) {
    if (error is UserUnavailableException) {
      closeSession();
    } else {
      loadError = error;
      notifyListeners();
    }
    Logger().e(error);
  }
}
