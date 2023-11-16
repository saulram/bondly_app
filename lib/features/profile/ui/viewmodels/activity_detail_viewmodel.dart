import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_user_activity_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/update_user_activity_usecase.dart';

class ActivityDetailViewModel extends NavigationModel {

  final GetUserActivityUseCase _useCase;
  final UpdateUserActivityUseCase _updateActivityUseCase;

  ActivityDetailViewModel(this._useCase, this._updateActivityUseCase);

  FeedData? post;

  Future<void> load(String feedId, String id, bool isRead) async {
    busy = true;
    notifyListeners();
    try {
      var response = await _useCase.invokeSingle(feedId);
      response.when(
          (success) {
            post = success;
            notifyListeners();

            _setPostAsRead(id, isRead);
          },
          (error) => {

          }
      );
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void _setPostAsRead(String postId, bool isRead) {
    _updateActivityUseCase.invoke(postId, isRead);
  }
}