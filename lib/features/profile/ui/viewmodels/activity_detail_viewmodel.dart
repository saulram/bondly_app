import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_user_activity_usecase.dart';
import 'package:bondly_app/features/profile/domain/usecases/update_user_activity_usecase.dart';

class ActivityDetailViewModel extends NavigationModel {

  final GetUserActivityUseCase _useCase;
  final UpdateUserActivityUseCase _updateActivityUseCase;

  ActivityDetailViewModel(this._useCase, this._updateActivityUseCase);

  FeedData? post;

  Future<void> load(String id, bool isRead) async {
    busy = true;
    notifyListeners();
    try {
      var response = await _useCase.invokeSingle(id);
      response.when(
          (success) {
            post = success;
            notifyListeners();

            setPostAsRead(post!.id!, isRead);
          },
          (error) => {

          }
      );
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void setPostAsRead(String postId, bool isRead) {
    _updateActivityUseCase.invoke(postId, isRead);
  }
}