import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/domain/models/company_feed_model.dart';
import 'package:bondly_app/features/profile/domain/usecases/get_user_activity_usecase.dart';

class ActivityDetailViewModel extends NavigationModel {

  final GetUserActivityUseCase _useCase;

  ActivityDetailViewModel(this._useCase);

  FeedData? post;

  Future<void> load(String id) async {
    busy = true;
    notifyListeners();
    try {
      var response = await _useCase.invokeSingle(id);
      response.when(
          (success) {
            post = success;
            notifyListeners();

            setPostAsRead(post!.id!);
          },
          (error) => {

          }
      );
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void setPostAsRead(String postId) {

  }
}