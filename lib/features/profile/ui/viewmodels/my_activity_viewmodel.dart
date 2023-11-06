import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_user_activity_usecase.dart';


class MyActivityViewModel extends NavigationModel {
  final GetUserActivityUseCase _useCase;
  final UserUseCase _userUseCase;
  final LogoutUseCase _logoutUseCase;
  final int limit = 10;

  String userId = "";
  String notificationMessage = "";
  bool errorShown = false;
  int nextPage = 0;
  List<UserActivityItem> activities = [];

  MyActivityViewModel(this._useCase, this._userUseCase, this._logoutUseCase);

  Future<void> load() async {
    var result = await _userUseCase.invoke();
    result.when(
      (user) {
        if (user.id == null) {
        }
        userId = user.id!;
        loadActivity();
      }, (error) {
        _logoutUseCase.invoke();
        navigation.go(LoginScreen.route);
      }
    );
  }

  Future<void> loadActivity() async {
    if (userId.isEmpty) {
      await load();
    }

    if (busy) return;

    busy = true;
    notifyListeners();

    try {
      var result = await _useCase.invoke(userId, limit: limit, page: nextPage);
      result.when(
        (activity) {
          nextPage = activity.nextPage > nextPage ? activity.nextPage : -1;
          activities.addAll(activity.activity);
          notifyListeners();
        },
        (error) {
          notificationMessage = StringsProfile.myActivityLoadError;
          if (error is NoMoreContentException) {
            notificationMessage = StringsProfile.myActivityLoadComplete;
          }
          notifyListeners();
        }
      );
    } catch (exception) {
      notificationMessage = StringsProfile.myActivityLoadError;
      if (exception is NoMoreContentException) {
        notificationMessage = StringsProfile.myActivityLoadComplete;
      }

      notifyListeners();
    } finally {
      busy = false;
      notifyListeners();

      autoDismiss();
    }
  }

  void autoDismiss() async {
    await Future.delayed(const Duration(seconds: 3), () {
      notificationMessage = "";
      errorShown = true;
      notifyListeners();
    });
  }

  Future<void> updateReadStatus(String id) async {

  }
}
