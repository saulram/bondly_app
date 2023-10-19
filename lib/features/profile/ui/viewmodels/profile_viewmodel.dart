import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/repositories/users_repository.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:logger/logger.dart';
import 'package:multiple_result/multiple_result.dart';

class ProfileViewModel extends NavigationModel {
  final UserUseCase userUseCase;
  final LogoutUseCase logoutUseCase;

  User? user;

  ProfileViewModel({
    required this.userUseCase,
    required this.logoutUseCase
  });

  void load() async {
    Result<User, Exception> result = await userUseCase.invoke();
    result.when(
      (user) {
        this.user = user;
        notifyListeners();
      },
      (error) {
        if (error is UserUnavailableException) {
          logoutUseCase.invoke();
          navigation.go(LoginScreen.route);
        }
        Logger().e(error);
      }
    );
  }
}