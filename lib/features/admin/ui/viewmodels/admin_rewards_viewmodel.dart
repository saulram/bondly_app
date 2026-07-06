import 'package:bondly_app/features/admin/data/repositories/supabase_admin_rewards_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_reward.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminRewardsViewModel extends NavigationModel {
  final SupabaseAdminRewardsRepository _repo;

  List<AdminReward> _rewards = [];
  bool _isLoading = false;
  String? _error;

  AdminRewardsViewModel(this._repo);

  List<AdminReward> get rewards => _rewards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getRewards();
    r.when((data) => _rewards = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleEnable(AdminReward reward) async {
    final r = await _repo.toggleEnable(reward.id, !reward.enable);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> createReward({
    required String name,
    String? description,
    String? category,
    required int points,
  }) async {
    final r = await _repo.createReward(
        name: name, description: description, category: category, points: points);
    bool ok = false;
    r.when((_) {
      ok = true;
      load();
    }, (e) {
      _error = e.toString();
      notifyListeners();
    });
    return ok;
  }

  Future<bool> updateReward({
    required String rewardId,
    required String name,
    String? description,
    String? category,
    required int points,
  }) async {
    final r = await _repo.updateReward(
        rewardId: rewardId,
        name: name,
        description: description,
        category: category,
        points: points);
    bool ok = false;
    r.when((_) {
      ok = true;
      load();
    }, (e) {
      _error = e.toString();
      notifyListeners();
    });
    return ok;
  }

  Future<bool> deleteReward(String rewardId) async {
    final r = await _repo.deleteReward(rewardId);
    bool ok = false;
    r.when((_) {
      ok = true;
      load();
    }, (e) {
      _error = e.toString();
      notifyListeners();
    });
    return ok;
  }
}
