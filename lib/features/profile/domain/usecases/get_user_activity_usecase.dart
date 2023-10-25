import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:bondly_app/features/profile/domain/models/user_activity.dart';
import 'package:multiple_result/multiple_result.dart';

class GetUserActivityUseCase {

  final ActivityRepository _repository;

  GetUserActivityUseCase(this._repository);

  Future<Result<UserActivityHolder, Exception>> invoke(
    String userId, {int limit = 10, int page = 0}
  ) async {
    if (page == -1) {
      return Result.error(NoMoreContentException());
    }

    return _repository.getActivity(userId, limit, page);
  }
}
