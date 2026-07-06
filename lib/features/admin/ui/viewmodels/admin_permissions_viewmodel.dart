import 'package:bondly_app/features/admin/data/repositories/supabase_admin_permissions_repository.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_user_with_permissions.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminPermissionsViewModel extends NavigationModel {
  final SupabaseAdminPermissionsRepository _repo;

  List<AdminUserWithPermissions> _adminUsers = [];
  bool _isLoading = false;
  String? _error;

  AdminPermissionsViewModel(this._repo);

  List<AdminUserWithPermissions> get adminUsers => _adminUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final r = await _repo.getAdminUsersWithPermissions();
    r.when((data) => _adminUsers = data, (e) => _error = e.toString());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> togglePermission(String userId, AdminModule module) async {
    final currentUser = _adminUsers.firstWhere((u) => u.user.id == userId);
    final hasPermission = currentUser.permissions.contains(module);

    final r = hasPermission
        ? await _repo.revokePermission(userId, module)
        : await _repo.grantPermission(userId, module);

    r.when((_) => load(), (e) {
      _error = e.toString();
      notifyListeners();
    });
  }
}
