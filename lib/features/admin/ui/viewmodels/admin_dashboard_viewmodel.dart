import 'package:bondly_app/features/admin/domain/models/dashboard_stats.dart';
import 'package:bondly_app/features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

sealed class AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final DashboardStats stats;
  final List<RecognitionTrendPoint> trends;
  final List<BadgeUsageStat> badgeStats;

  AdminDashboardLoaded({
    required this.stats,
    required this.trends,
    required this.badgeStats,
  });
}

class AdminDashboardError extends AdminDashboardState {
  final String message;
  AdminDashboardError(this.message);
}

class AdminDashboardViewModel extends NavigationModel {
  final GetDashboardStatsUseCase _statsUseCase;
  final GetRecognitionTrendsUseCase _trendsUseCase;
  final GetBadgeUsageReportUseCase _badgeUseCase;

  AdminDashboardState _state = AdminDashboardLoading();

  AdminDashboardViewModel(
    this._statsUseCase,
    this._trendsUseCase,
    this._badgeUseCase,
  );

  AdminDashboardState get state => _state;

  Future<void> load() async {
    _state = AdminDashboardLoading();
    notifyListeners();

    final statsResult = await _statsUseCase.invoke();
    final trendsResult = await _trendsUseCase.invoke(6);
    final badgeResult = await _badgeUseCase.invoke();

    DashboardStats? stats;
    List<RecognitionTrendPoint> trends = [];
    List<BadgeUsageStat> badges = [];
    String? errorMsg;

    statsResult.when(
      (s) => stats = s,
      (e) => errorMsg = e.toString(),
    );
    trendsResult.when(
      (t) => trends = t,
      (e) {},
    );
    badgeResult.when(
      (b) => badges = b,
      (e) {},
    );

    if (errorMsg != null) {
      _state = AdminDashboardError(errorMsg!);
    } else {
      _state = AdminDashboardLoaded(
        stats: stats ?? DashboardStats.empty(),
        trends: trends,
        badgeStats: badges,
      );
    }
    notifyListeners();
  }
}
