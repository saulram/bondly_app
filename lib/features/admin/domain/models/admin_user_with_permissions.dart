import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/domain/models/admin_user.dart';

class AdminUserWithPermissions {
  final AdminUser user;
  final Set<AdminModule> permissions;

  const AdminUserWithPermissions({
    required this.user,
    required this.permissions,
  });
}
