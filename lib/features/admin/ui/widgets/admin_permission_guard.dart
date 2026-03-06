import 'package:bondly_app/config/strings_admin.dart';
import 'package:bondly_app/features/admin/domain/models/admin_module.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_shell_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_empty_state.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminPermissionGuard extends StatelessWidget {
  final AdminModule module;
  final Widget child;

  const AdminPermissionGuard({
    super.key,
    required this.module,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final vm = ModelProvider.of<AdminShellViewModel>(context);
    if (vm.hasPermission(module)) return child;
    return AdminEmptyState(
      icon: LucideIcons.shieldOff,
      message: StringsAdmin.noPermission,
    );
  }
}
