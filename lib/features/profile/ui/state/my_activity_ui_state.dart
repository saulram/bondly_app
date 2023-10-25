import 'package:bondly_app/features/profile/domain/models/user_activity.dart';

sealed class MyActivityUIState {}

class Idle extends MyActivityUIState {}

class LoadingActivity extends MyActivityUIState {}

class SuccessLoad extends MyActivityUIState {
  final List<UserActivityItem>  userActivity;

  SuccessLoad(this.userActivity);
}

class FailedLoad extends MyActivityUIState {
  final ActivityErrorType errorType;

  FailedLoad(this.errorType);
}

enum ActivityErrorType {
  authError,
  loadError,
  contentError,
}