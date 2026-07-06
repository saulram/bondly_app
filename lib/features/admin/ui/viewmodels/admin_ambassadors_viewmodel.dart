import 'package:bondly_app/features/admin/data/repositories/supabase_admin_ambassadors_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_ambassador.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminAmbassadorsViewModel extends NavigationModel {
  final SupabaseAdminAmbassadorsRepository _repo;

  List<AdminAmbassador> _ambassadors = [];
  bool _isLoading = false;
  String? _error;

  AdminAmbassadorsViewModel(this._repo);

  List<AdminAmbassador> get ambassadors => _ambassadors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getAmbassadors();
    r.when((data) => _ambassadors = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleVisible(AdminAmbassador ambassador) async {
    final r =
        await _repo.toggleVisible(ambassador.id, !ambassador.visible);
    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<bool> recalculate() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    bool ok = false;
    final r = await _repo.recalculate();
    r.when((_) {
      ok = true;
    }, (e) {
      _error = e.toString();
    });

    _isLoading = false;
    notifyListeners();

    if (ok) await load();
    return ok;
  }
}
