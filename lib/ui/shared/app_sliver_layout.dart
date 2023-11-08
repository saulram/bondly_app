import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/ui/shared/app_body_layout.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BondlySliverLayout extends StatefulWidget {
  final Widget child;
  final String? title;
  final FloatingActionButton? floatingActionButton;

  const BondlySliverLayout(
      {super.key, required this.child, this.title, this.floatingActionButton});

  @override
  State<BondlySliverLayout> createState() => _BondlySliverLayoutState();
}

class _BondlySliverLayoutState extends State<BondlySliverLayout> {
  bool addMargin = false;

  double top = 0.0;
  String _value = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                leading: GestureDetector(
                  onTap: context.pop,
                  child: const Icon(
                    IconsaxOutline.arrow_left,
                  ),
                ),
                backgroundColor: theme.scaffoldBackgroundColor,
                iconTheme: IconThemeData(
                  color: theme.unselectedWidgetColor,
                ),
                expandedHeight: 260.0,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    top = constraints.biggest.height;

                    return FlexibleSpaceBar(
                      centerTitle: true,
                      background: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 44.0),
                          child: BodyLayout(
                            enableBanners: true,
                            child: Container(),
                          ),
                        ),
                      ),
                      title: top < 120.0
                          ? Text(
                              widget.title ?? StringsProfile.myActivity,
                              style: theme.textTheme.titleLarge,
                            )
                          : const SizedBox(),
                    );
                  },
                )),
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: widget.child,
        ),
      ),
    );
  }
}
