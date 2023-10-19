import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  static String route = "/profileScreen";

  final ProfileViewModel model = getIt<ProfileViewModel>();

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final String defaultAvatar =
      "https://www.gauchercommunity.org/wp-content/uploads/2020/09/avatar-placeholder.png";

  @override
  void initState() {
    super.initState();
    widget.model.load();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ModelProvider<ProfileViewModel>(
      model: widget.model,
      child: ModelBuilder<ProfileViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(theme, model)
              ],
            ),
          ),
          appBar: AppBar(
            titleTextStyle: theme.textTheme.titleLarge,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: const Text(
              StringsProfile.profileTitle,
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.unselectedWidgetColor,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ProfileViewModel model) {
    return Container(
      width: double.infinity,
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                    StringsProfile.welcomeGreeting(model.user?.completeName
                        ?? StringsProfile.defaultUser
                    ),
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              CircleAvatar(
                backgroundColor: theme.primaryColor,
                maxRadius: 60,
                backgroundImage: NetworkImage(
                    model.user?.avatar ?? defaultAvatar
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}