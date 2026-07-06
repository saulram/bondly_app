import 'dart:typed_data';

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

  /// Uploads a reward image and returns its public URL (or null on failure).
  Future<String?> uploadImage(Uint8List bytes, String ext) async {
    final r = await _repo.uploadImage(bytes, ext);
    return r.when((url) => url, (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    });
  }

  Future<bool> createReward({
    required String name,
    String? description,
    String? category,
    required int points,
    String? image,
  }) async {
    final r = await _repo.createReward(
        name: name,
        description: description,
        category: category,
        points: points,
        image: image);
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
    String? image,
  }) async {
    final r = await _repo.updateReward(
        rewardId: rewardId,
        name: name,
        description: description,
        category: category,
        points: points,
        image: image);
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
