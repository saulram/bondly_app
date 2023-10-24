import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/features/profile/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//create app bar widget

class BondlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? child;
  final double height;
  final String? avatar;
  final VoidCallback? onExitProfileCallback;
  final String defaultAvatar = "https://www.gauchercommunity.org/wp-content/uploads/2020/09/avatar-placeholder.png";
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";

  const BondlyAppBar(this.avatar, {
    super.key,
    this.child,
    this.height = kToolbarHeight,
    this.onExitProfileCallback,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Center(
        child: Image.asset(
          context.isDarkMode ? _logoDarkImagePath : _logoImagePath,
          width: 100,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            context.push(ProfileScreen.route).then(
                (value) => onExitProfileCallback?.call()
            );
          },
          child: Hero(
            tag: "AvatarWidget",
            child: CircleAvatar(
              backgroundColor: theme.primaryColor,
              maxRadius: 20,
              backgroundImage: NetworkImage(avatar ?? defaultAvatar),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
