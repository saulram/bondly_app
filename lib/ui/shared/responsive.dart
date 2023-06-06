import 'package:bondly_app/resources/constants.dart';
import 'package:flutter/material.dart';

///  Responsive widget
///  This widget is used to render different layouts depending on the screen size
///  You can use this widget not just to render screens but also to render different widgets
///  depending on the screen size
///  Example for screens:
///  Responsive(
///  desktop: _buildDesktopLayout(),
///  mobile: _buildMobileLayout(),
///  tablet: _buildTabletLayout(),
///  )
///  You can use this Widget to build also smaller widgets, lets think into a button, on desktop you require
///  that the button is holding a text and an icon, but on mobile you just want to render the icon, you can use
///  this widget to render different widgets depending on the screen size
///  Example:
///  Responsive(
///   desktop: RaisedButton(
///   child: Row(
///   children: [
///   Text('Text'),
///   Icon(Icons.add)
///   ],
///   ),
///   onPressed: () => print("go to root"),
///   ),
///   mobile: IconButton(
///   icon: Icon(Icons.add),
///   onPressed: () => print("go to root"),
///   ),
///   tablet: RaisedButton(
///   child: Row(
///   children: [
///   Text('Text'),
///   Icon(Icons.add)
///   ],
///   ),
///   onPressed: () => print("go to root"),
///   ),
///   )


class Responsive extends StatefulWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget desktop;
  final double? breakpointS;
  final double? breakpointM;

  const Responsive(
      {Key? key,
      this.mobile,
      this.tablet,
      this.breakpointM = Constants.tabletBreakPooint,
      this.breakpointS = Constants.mobileBreakpoint,
      required this.desktop})
      : super(key: key);

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  Widget? mobile;
  Widget? tablet;
  late Widget desktop;
  double? breakpointS;
  double? breakpointM;

  @override
  void initState() {
    mobile = widget.mobile;
    tablet = widget.tablet;
    desktop = widget.desktop;
    breakpointS = widget.breakpointS;
    breakpointM = widget.breakpointM;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < breakpointM!) {
        return mobile ?? tablet ?? desktop;
      } else if (constraints.maxWidth < breakpointS!) {
        return tablet ?? desktop;
      } else {
        return desktop;
      }
    });
  }
}
