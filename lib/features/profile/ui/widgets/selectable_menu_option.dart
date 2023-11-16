import 'package:bondly_app/config/colors.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class SelectableMenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool showArrow;
  final VoidCallback onTap;

  const SelectableMenuOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      width: double.infinity,
      height: 56.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primaryColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: theme.unselectedWidgetColor,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontSize: 18.0
                  ),
                ),
              ),
              Icon(
                IconsaxOutline.arrow_right_3,
                color: theme.unselectedWidgetColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}