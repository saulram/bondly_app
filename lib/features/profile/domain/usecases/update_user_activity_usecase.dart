import 'package:bondly_app/features/profile/domain/repositories/activity_repository.dart';
import 'package:logger/logger.dart';

class UpdateUserActivityUseCase {

  final ActivityRepository _repository;

  UpdateUserActivityUseCase(
      this._repository
  );

  void invoke(String activityId, bool isRead) async {
    if (!isRead) {
      try {
        await _repository.updateActivityStatus(activityId);
      } catch (error) {
        Logger().e(error.toString());
      }
    }
  }
}