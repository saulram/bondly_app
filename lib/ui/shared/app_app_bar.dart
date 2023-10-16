import 'package:bondly_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
//create app bar widget

class BondlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? child;
  final double height;
  final String? userAvatarUrl;
  const BondlyAppBar(
      {super.key,
      this.child,
      this.height = kToolbarHeight,
      this.userAvatarUrl});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      title: Image.asset(
        "assets/img_logo.png",
        width: 100,
      ),
      leading: Container(
        margin: const EdgeInsets.all(5),
        child: CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          maxRadius: 20,
          backgroundImage: NetworkImage(userAvatarUrl ??
              "https://www.gauchercommunity.org/wp-content/uploads/2020/09/avatar-placeholder.png"),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: const Icon(
            Iconsax.menu,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
