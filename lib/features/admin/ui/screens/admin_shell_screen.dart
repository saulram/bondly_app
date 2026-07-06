import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/admin/ui/viewmodels/admin_shell_viewmodel.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_app_bar.dart';
import 'package:bondly_app/features/admin/ui/widgets/admin_sidebar.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminShellScreen extends StatefulWidget {
  static const String route = '/admin';

  final Widget child;
  final List<String> breadcrumbs;

  const AdminShellScreen({
    super.key,
    required this.child,
    this.breadcrumbs = const [],
  });

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  late AdminShellViewModel _viewModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<AdminShellViewModel>();
    _viewModel.setUp();
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider<AdminShellViewModel>(
      model: _viewModel,
      child: ModelBuilder<AdminShellViewModel>(
        builder: (context, vm, _) {
          final currentRoute =
              GoRouterState.of(context).uri.path;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop =
                  constraints.maxWidth > Constants.desktopBreakpoint;

              if (isDesktop) {
                return Scaffold(
                  key: _scaffoldKey,
                  body: Row(
                    children: [
                      AdminSidebar(
                        viewModel: vm,
                        currentRoute: currentRoute,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AdminAppBar(
                              viewModel: vm,
                              breadcrumbs: widget.breadcrumbs,
                            ),
                            Expanded(child: widget.child),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Mobile: drawer
              return Scaffold(
                key: _scaffoldKey,
                drawer: Drawer(
                  child: AdminSidebar(
                    viewModel: vm,
                    currentRoute: currentRoute,
                  ),
                ),
                appBar: AdminAppBar(
                  viewModel: vm,
                  breadcrumbs: widget.breadcrumbs,
                  onMenuTap: () =>
                      _scaffoldKey.currentState?.openDrawer(),
                ),
                body: widget.child,
              );
            },
          );
        },
      ),
    );
  }
}
