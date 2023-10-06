import 'package:bondly_app/ui/shared/responsive.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final bool isBusy;
  final Widget? child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;

  const AppScaffold(
      {super.key, required this.isBusy,
      this.child,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.drawer,
      this.endDrawer,
      this.bottomSheet,
      this.backgroundColor,
      this.resizeToAvoidBottomInset,
      this.appBar});

  Widget _desktopLayout() {
    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _desktopLayout();
    throw UnimplementedError();
  }

  static Widget tabletLayout({
    bool isBusy = false,
    Widget? child,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    Widget? drawer,
    Widget? endDrawer,
    Widget? bottomSheet,
    Color? backgroundColor,
    bool? resizeToAvoidBottomInset,
    PreferredSizeWidget? appBar,
  }) {
    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  static Widget mobileLayout({
    bool isBusy = false,
    Widget? child,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    Widget? drawer,
    Widget? endDrawer,
    Widget? bottomSheet,
    Color? backgroundColor,
    bool? resizeToAvoidBottomInset,
    PreferredSizeWidget? appBar,
  }) {
    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
