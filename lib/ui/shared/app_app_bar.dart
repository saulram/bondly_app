import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
//create app bar widget

class BondlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? child;
  final double height;
  final String? avatar;
  final VoidCallback? afterProfileCall;
  final String defaultAvatar = "https://www.gauchercommunity.org/wp-content/uploads/2020/09/avatar-placeholder.png";

  const BondlyAppBar(this.avatar, {
    super.key,
    this.child,
    this.height = kToolbarHeight,
    this.afterProfileCall,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Image.asset(
        "assets/img_logo.png",
        width: 100,
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            context.push(ProfileScreen.route).then(
                (value) => afterProfileCall?.call()
            );
          },
          child: CircleAvatar(
            backgroundColor: theme.primaryColor,
            maxRadius: 20,
            backgroundImage: NetworkImage(avatar ?? defaultAvatar),
          ),
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
