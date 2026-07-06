import 'package:bondly_app/features/admin/data/repositories/supabase_admin_users_repository.dart';
import 'package:bondly_app/features/admin/data/repositories/supabase_admin_zones_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_user.dart';
import 'package:bondly_app/features/admin/domain/models/paginated_result.dart';
import 'package:bondly_app/features/admin/domain/models/zone.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminUsersViewModel extends NavigationModel {
  final SupabaseAdminUsersRepository _repo;
  final SupabaseAdminZonesRepository _zonesRepo;

  PaginatedResult<AdminUser> _result = PaginatedResult.empty();
  bool _isLoading = false;
  String? _error;
  String _search = '';
  String? _roleFilter;
  bool? _activeFilter;
  int _page = 1;
  static const int _pageSize = 20;

  AdminUsersViewModel(this._repo, this._zonesRepo);

  PaginatedResult<AdminUser> get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get search => _search;
  String? get roleFilter => _roleFilter;
  bool? get activeFilter => _activeFilter;
  int get page => _page;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getUsers(
      search: _search.isEmpty ? null : _search,
      role: _roleFilter,
      isActive: _activeFilter,
      page: _page,
      pageSize: _pageSize,
    );
    r.when(
      (data) => _result = data,
      (e) => _error = e.toString(),
    );

    _isLoading = false;
    notifyListeners();
  }

  void onSearch(String value) {
    _search = value;
    _page = 1;
    load();
  }

  void setRoleFilter(String? role) {
    _roleFilter = role;
    _page = 1;
    load();
  }

  void setActiveFilter(bool? active) {
    _activeFilter = active;
    _page = 1;
    load();
  }

  void setPage(int p) {
    _page = p;
    load();
  }

  Future<void> toggleActive(AdminUser user) async {
    final r = await _repo.toggleActive(user.id, !user.isActive);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> updateRole(String userId, String role) async {
    final r = await _repo.updateRole(userId, role);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> inviteUser({
    required String email,
    required String completeName,
    required String role,
    required int monthlyPoints,
  }) async {
    final r = await _repo.createUser(
      email: email,
      completeName: completeName,
      role: role,
      monthlyPoints: monthlyPoints,
    );
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

  Future<Map<String, int>?> getUserPoints(String userId) async {
    final r = await _repo.getUserPoints(userId);
    return r.when((data) => data, (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    });
  }

  Future<bool> updateUserPoints({
    required String userId,
    required int toGive,
    required int earned,
  }) async {
    final r = await _repo.updateUserPoints(
        userId: userId, toGive: toGive, earned: earned);
    return r.when((_) => true, (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    });
  }

  /// Active zones + the user's current assignments, fetched concurrently.
  Future<(List<Zone>, Set<String>)> getZonesForUser(String userId) async {
    final zonesFuture = _zonesRepo.getZones();
    final userZonesFuture = _repo.getUserZones(userId);
    final zones = (await zonesFuture)
        .when((data) => data.where((z) => z.isActive).toList(), (_) => <Zone>[]);
    final selected =
        (await userZonesFuture).when((data) => data, (_) => <String>{});
    return (zones, selected);
  }

  Future<bool> setUserZones(String userId, Set<String> zoneIds) async {
    final r = await _repo.setUserZones(userId, zoneIds);
    return r.when((_) => true, (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    });
  }
}
