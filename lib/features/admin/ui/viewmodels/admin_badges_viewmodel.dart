import 'package:bondly_app/features/admin/data/repositories/supabase_admin_badges_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_badge.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminBadgesViewModel extends NavigationModel {
  final SupabaseAdminBadgesRepository _repo;

  List<AdminBadge> _badges = [];
  List<AdminBadgeCategory> _categories = [];
  bool _isLoading = false;
  String? _error;

  AdminBadgesViewModel(this._repo);

  List<AdminBadge> get badges => _badges;
  List<AdminBadgeCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final badgesResult = await _repo.getBadges();
    final catsResult = await _repo.getCategories();

    badgesResult.when((b) => _badges = b, (e) => _error = e.toString());
    catsResult.when((c) => _categories = c, (_) {});

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleActive(AdminBadge badge) async {
    final r = await _repo.toggleActive(badge.id, !badge.isActive);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> createBadge({
    required String categoryId,
    required String name,
    required int value,
  }) async {
    final r = await _repo.createBadge(
        categoryId: categoryId, name: name, value: value);
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

  Future<bool> updateBadge({
    required String badgeId,
    required String name,
    required int value,
    required String categoryId,
  }) async {
    final r = await _repo.updateBadge(
        badgeId: badgeId, name: name, value: value, categoryId: categoryId);
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

  Future<bool> deleteBadge(String badgeId) async {
    final r = await _repo.deleteBadge(badgeId);
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
