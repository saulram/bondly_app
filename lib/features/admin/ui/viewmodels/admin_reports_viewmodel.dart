import 'package:bondly_app/features/admin/data/repositories/supabase_admin_exchanges_repository.dart';
import 'package:bondly_app/features/admin/domain/models/dashboard_stats.dart';
import 'package:bondly_app/features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminReportsViewModel extends NavigationModel {
  final GetRecognitionTrendsUseCase _trendsUseCase;
  final GetBadgeUsageReportUseCase _badgeUseCase;
  final SupabaseAdminExchangesRepository _exchangesRepo;

  List<RecognitionTrendPoint> _trends = [];
  List<BadgeUsageStat> _badgeStats = [];
  Map<String, int> _exchangeStats = {};
  bool _isLoading = false;
  String? _error;
  int _months = 6;

  AdminReportsViewModel(
    this._trendsUseCase,
    this._badgeUseCase,
    this._exchangesRepo,
  );

  List<RecognitionTrendPoint> get trends => _trends;
  List<BadgeUsageStat> get badgeStats => _badgeStats;
  Map<String, int> get exchangeStats => _exchangeStats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get months => _months;

  int get totalRecognitions =>
      _trends.fold(0, (sum, t) => sum + t.count);

  double get avgPerMonth =>
      _trends.isEmpty ? 0 : totalRecognitions / _trends.length;

  String get peakMonth {
    if (_trends.isEmpty) return '—';
    final peak = _trends.reduce((a, b) => a.count >= b.count ? a : b);
    return peak.month;
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Start the three independent queries concurrently
    final trendsFuture = _trendsUseCase.invoke(_months);
    final badgeFuture = _badgeUseCase.invoke();
    final exchangeFuture = _exchangesRepo.getExchangeStats();

    (await trendsFuture).when(
      (data) => _trends = data,
      (e) => _error = e.toString(),
    );
    (await badgeFuture).when(
      (data) => _badgeStats = data,
      (e) => _error = e.toString(),
    );
    (await exchangeFuture).when(
      (data) => _exchangeStats = data,
      (e) => _error = e.toString(),
    );

    _isLoading = false;
    notifyListeners();
  }

  void setMonths(int months) {
    if (months == _months) return;
    _months = months;
    load();
  }
}
