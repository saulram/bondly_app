import 'dart:typed_data';

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
    _error = null;
    notifyListeners();
    final r = await _repo.toggleActive(banner.id, !banner.isActive);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> createBanner(
      {required String name,
      String? slug,
      String? description,
      Uint8List? imageBytes}) async {
    _error = null;
    notifyListeners();
    final r = await _repo.createBanner(
        name: name,
        slug: slug,
        description: description,
        imageBytes: imageBytes);
    var ok = false;
    r.when((data) {
      ok = true;
      _error = null;
      _banners = [data, ..._banners];
      notifyListeners();
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
    Uint8List? imageBytes,
  }) async {
    _error = null;
    notifyListeners();
    final r = await _repo.updateBanner(
        bannerId: bannerId,
        name: name,
        slug: slug,
        description: description,
        imageBytes: imageBytes);
    var ok = false;
    r.when((data) {
      ok = true;
      _error = null;
      final index = _banners.indexWhere((b) => b.id == data.id);
      if (index >= 0) _banners[index] = data;
      notifyListeners();
    }, (e) {
      _error = e.toString();
      notifyListeners();
    });
    return ok;
  }

  Future<bool> deleteBanner(String bannerId) async {
    _error = null;
    notifyListeners();
    final r = await _repo.deleteBanner(bannerId);
    var ok = false;
    r.when((_) {
      ok = true;
      _error = null;
      load();
    }, (e) {
      _error = e.toString();
      notifyListeners();
    });
    return ok;
  }
}
