import 'package:bondly_app/features/admin/data/repositories/supabase_admin_banners_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_banner.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminBannersViewModel extends NavigationModel {
  final SupabaseAdminBannersRepository _repo;

  List<AdminBanner> _banners = [];
  bool _isLoading = false;
  String? _error;

  AdminBannersViewModel(this._repo);

  List<AdminBanner> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getBanners();
    r.when((data) => _banners = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleActive(AdminBanner banner) async {
    final r = await _repo.toggleActive(banner.id, !banner.isActive);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> createBanner(
      {required String name, String? slug, String? description}) async {
    final r =
        await _repo.createBanner(name: name, slug: slug, description: description);
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

  Future<bool> updateBanner({
    required String bannerId,
    required String name,
    String? slug,
    String? description,
  }) async {
    final r = await _repo.updateBanner(
        bannerId: bannerId, name: name, slug: slug, description: description);
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

  Future<bool> deleteBanner(String bannerId) async {
    final r = await _repo.deleteBanner(bannerId);
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
