import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static String route = "/profileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: theme.primaryColor,
              maxRadius: 20,
              backgroundImage: NetworkImage(getIt<ProfileViewModel>().user?.avatar ??
                  "https://www.gauchercommunity.org/wp-content/uploads/2020/09/avatar-placeholder.png"),
            ),
          ],
        ),
      ),
    );
  }

}