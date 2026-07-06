import 'package:bondly_app/features/admin/data/repositories/supabase_admin_zones_repository.dart';
import 'package:bondly_app/features/admin/domain/models/zone.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminZonesViewModel extends NavigationModel {
  final SupabaseAdminZonesRepository _repo;

  List<Zone> _zones = [];
  Map<String, int> _userCounts = {};
  bool _isLoading = false;
  String? _error;

  AdminZonesViewModel(this._repo);

  List<Zone> get zones => _zones;
  Map<String, int> get userCounts => _userCounts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int userCountForZone(String zoneId) => _userCounts[zoneId] ?? 0;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Independent queries — run concurrently
    final zonesFuture = _repo.getZones();
    final countsFuture = _repo.getZoneUserCounts();

    (await zonesFuture).when(
        (data) => _zones = data, (e) => _error = e.toString());
    (await countsFuture).when(
      (data) => _userCounts = data,
      (_) {}, // non-critical
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createZone({
    required String name,
    String? description,
    String? parentZoneId,
  }) async {
    final r = await _repo.createZone(
        name: name,
        description: description,
        parentZoneId: parentZoneId);
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

  Future<bool> updateZone({
    required String zoneId,
    required String name,
    String? description,
    String? parentZoneId,
  }) async {
    final r = await _repo.updateZone(
      zoneId: zoneId,
      name: name,
      description: description,
      parentZoneId: parentZoneId,
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

  Future<bool> deleteZone(String zoneId) async {
    final r = await _repo.deleteZone(zoneId);
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
