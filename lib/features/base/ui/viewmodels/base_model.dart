import 'dart:async';

import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/src/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// Full screen view models should extend this class to incorporate navigation
/// features.
///
/// This class facilitates 2 main features:
/// - navigation can be mocked and tested easily in unit test.
/// - models can handle navigation directly without a notify/redraw.
///
/// The corresponding widget must do the following to configure navigation.
/// - override didChangeDependencies, adding the following statement:
///   - model.navigator = Navigator.of(context);
class NavigationModel extends ContextModel {
  NavigationModel() {
    getPackageInfo();
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
  String? _appName ;
  String? _packageName ;
  String? _version ;
  String? _buildNumber ;

  String? get appName => _appName;
  String? get packageName => _packageName;
  String? get version => _version;
  String? get buildNumber => _buildNumber;

  set appName(String? value) {
    _appName = value;
    notifyListeners();
  }
  set packageName(String? value) {
    _packageName = value;
    notifyListeners();
  }
  set version(String? value) {
    _version = value;
    notifyListeners();
  }
  set buildNumber(String? value) {
    _buildNumber = value;
    notifyListeners();
  }
  final GoRouter _navigation = getIt<AppRouter>().router;
  GoRouter get navigation => _navigation;
  bool _busy = false;
  bool get busy => _busy;
  set busy(bool value) {
    _busy = value;
    notifyListeners();
  }


}

class DebouncedChangeNotifier extends ChangeNotifier {
  int _currentTaskVersion = 0;
  int _taskVersion = 0;

  /// Handle multiple changes by versioning the microTask.
  @override
  void notifyListeners() {
    if (_taskVersion == _currentTaskVersion) {
      _taskVersion++;
      scheduleMicrotask(() {
        _currentTaskVersion++;
        _taskVersion = _currentTaskVersion;

        if (!hasListeners) return;
        super.notifyListeners();
      });
    }
  }
}

class ContextModel extends DebouncedChangeNotifier {
  BuildContext? context;
}

class ModelProvider<T extends ContextModel> extends ChangeNotifierProvider<T> {
  final T model;

  ModelProvider({Key? key, required this.model, required Widget child})
      : super.value(key: key, value: model, child: child);

  @override
  Widget build(BuildContext context) {
    model.context = context;
    return super.build(context);
  }

  static M of<M extends ContextModel>(
    BuildContext context, {
    bool listen = false,
  }) {
    M model = Provider.of<M>(context, listen: listen);
    model.context = context;
    return model;
  }
}

class ModelBuilder<T extends ContextModel> extends Consumer<T> {
  final bool listen;

  ModelBuilder({
    Key? key,
    required Widget Function(BuildContext context, T value, Widget? child)
        builder,
    Widget? child,
    this.listen = true,
  }) : super(
          key: key,
          builder: builder,
          child: child,
        );

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    var model = Provider.of<T>(context);
    model.context = context;
    return builder(
      context,
      model,
      child,
    );
  }
}
