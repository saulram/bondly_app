import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/usecases/get_admin_permissions_usecase.dart';
import 'package:bondly_app/features/auth/domain/models/user_model.dart';
import 'package:bondly_app/features/auth/domain/usecases/user_usecase.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';

class AdminShellViewModel extends NavigationModel {
  final UserUseCase _userUseCase;
  final GetAdminPermissionsUseCase _getPermissionsUseCase;

  User? _user;
  List<AdminModule> _permissions = [];
  String _selectedRoute = '/admin';
  bool _isLoading = false;
  String? _error;

  AdminShellViewModel(this._userUseCase, this._getPermissionsUseCase);

  List<AdminModule> get permissions => _permissions;
  String get selectedRoute => _selectedRoute;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get userId => _user?.id;
  String? get userRole => _user?.role;
  String? get userName => _user?.completeName;
  String? get userAvatar => _user?.avatar;
  bool get isSuperAdmin => userRole == 'superAdmin';

  Future<void> setUp() async {
    _isLoading = true;
    notifyListeners();

    final userResult = await _userUseCase.invoke();
    userResult.when(
      (user) => _user = user,
      (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
        return;
      },
    );

    final id = _user?.id;
    if (id == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _getPermissionsUseCase.invoke(id);
    result.when(
      (permissions) {
        _permissions = permissions;
        _error = null;
      },
      (error) {
        _error = error.toString();
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  bool hasPermission(AdminModule module) {
    if (isSuperAdmin) return true;
    return _permissions.contains(module);
  }

  void selectRoute(String route) {
    _selectedRoute = route;
    notifyListeners();
  }
}
