import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_user_activity_usecase.dart';
import 'package:bondly_app/features/profile/ui/state/my_activity_ui_state.dart';

class MyActivityViewModel extends NavigationModel {
  final GetUserActivityUseCase _useCase;
  final UserUseCase _userUseCase;

  MyActivityUIState state = Idle();

  String userId = "";
  int nextPage = 0;
  int limit = 10;

  MyActivityViewModel(this._useCase, this._userUseCase);

  Future<void> load() async {
    var result = await _userUseCase.invoke();
    result.when(
      (user) {
        if (user.id == null) {
          state = FailedLoad(ActivityErrorType.authError);
          notifyListeners();
        }
        userId = user.id!;
        notifyListeners();
      }, (error) {
        state = FailedLoad(ActivityErrorType.authError);
        notifyListeners();
      }
    );
  }

  Future<void> loadActivity() async {
    busy = true;
    state = LoadingActivity();
    notifyListeners();

    try {
      var result = await _useCase.invoke(userId, limit: limit, page: nextPage);
      result.when(
        (activity) {
          limit = activity.count;
          nextPage = activity.nextPage;
          state = SuccessLoad(activity.activity);
          notifyListeners();
        },
        (error) {
          state = FailedLoad(ActivityErrorType.loadError);
          if (error is NoMoreContentException) {
            state = FailedLoad(ActivityErrorType.contentError);
          }
          notifyListeners();
        }
      );
    } catch (exception) {
      state = FailedLoad(ActivityErrorType.loadError);
      if (exception is NoMoreContentException) {
        state = FailedLoad(ActivityErrorType.contentError);
      }
      notifyListeners();
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}