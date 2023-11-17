import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:flutter/material.dart';

class GoldBorderedContainer extends StatefulWidget {
  final Widget? child;
  const GoldBorderedContainer({Key? key, this.child}) : super(key: key);

  @override
  _GoldBorderedContainerState createState() => _GoldBorderedContainerState();
}

class _GoldBorderedContainerState extends State<GoldBorderedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.tertiaryColorLight),
          color: context.isDarkMode
              ? AppColors.greyBackGroundColorDark
              : AppColors.greyBackGroundColor,
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode
                  ? Colors.white.withOpacity(0.1) // Adjust the shadow color for dark mode
                  : Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ]),
      padding: const EdgeInsets.all(15),
      child: widget.child,
    );
  }
}
