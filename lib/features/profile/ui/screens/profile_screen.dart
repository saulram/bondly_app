import 'dart:io';

import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/widgets/full_screen_image.dart';
import 'package:bondly_app/features/profile/ui/screens/monthly_balance_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_activity_screen.dart';
import 'package:bondly_app/features/profile/ui/screens/my_rewards_screen.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:bondly_app/features/profile/ui/widgets/selectable_menu_option.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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

  double headerHeight = 200;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    widget.model.load();
  }

  @override
  void dispose() {
    super.dispose();
    _image = null;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ModelProvider<ProfileViewModel>(
      model: widget.model,
      child: ModelBuilder<ProfileViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: AppColors.secondaryColor,
          body: Column(
            children: [
              _buildTopBar(theme),
              _buildHeader(theme, model),
              _buildBodyCard(theme, model)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ProfileViewModel model) {
    return Container(
      width: double.infinity,
      height: headerHeight,
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: model.busy ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          _buildGreetingAndAvatar(theme, model),
          const SizedBox(height: 24,),
          _buildPoints(theme, model)
        ],
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: 56.0,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      IconsaxOutline.arrow_left,
                      color: Colors.white,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  Center(
                    child: Text(
                      StringsProfile.profileTitle,
                      style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingAndAvatar(ThemeData theme, ProfileViewModel model) {
    return Row(
      children: [
        Expanded(
          child: Text(
            StringsProfile.welcomeGreeting(model.user?.completeName
                ?? StringsProfile.defaultUser
            ),
            style: theme.textTheme.headlineSmall!.copyWith(color: Colors.white),
          ),
        ),
        Stack(
          children: [
            _image == null ?
            GestureDetector(
              onTap: () {
                displayAvatar(
                  image: model.user?.avatar ?? defaultAvatar
                );
              },
              child: Hero(
                tag: "AvatarWidget",
                child: CircleAvatar(
                  key: const Key("AvatarWidget"),
                  backgroundColor: theme.primaryColor,
                  maxRadius: 50,
                  backgroundImage: NetworkImage(
                      model.user?.avatar ?? defaultAvatar
                  ),
                ),
              ),
            ) :
            GestureDetector(
              onTap: () {
                displayAvatar(image: "");
              },
              child: CircleAvatar(
                key: const Key("AvatarWidget"),
                backgroundColor: theme.primaryColor,
                maxRadius: 50,
                backgroundImage: FileImage(_image!),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                key: const Key("EditContainer"),
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24))
                ),
                child: IconButton(
                    key: const Key("EditButton"),
                    onPressed: () {
                      showOptions();
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 24.0,
                      color: AppColors.secondaryColor,
                    )
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildPoints(ThemeData theme, ProfileViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          key: const Key("PointsReceivedSection"),
          children: [
            Text(
              model.user?.pointsReceived.toString() ?? "0",
              style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8,),
            Text(
              StringsProfile.receivedPoints,
              style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(width: 32),
        Column(
          key: const Key("MonthlyPointsSection"),
          children: [
            Text(
              model.user?.monthlyPoints.toString() ?? "0",
              style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8,),
            Text(
              StringsProfile.monthlyPoints,
              style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(width: 32),
        Column(
          key: const Key("GiftedPointsSection"),
          children: [
            Text(
              model.user?.giftedPoints.toString() ?? "0",
              style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8,),
            Text(
              StringsProfile.givenPoints,
              style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBodyCard(ThemeData theme, ProfileViewModel model) {
    return Expanded(
      child: Container(
        key: const Key("BackgroundCardWidget"),
        decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0)
            )
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 36.0,
                horizontal: 24.0
              ),
              child: Column(
                children: [
                  SelectableMenuOption(
                      title: StringsProfile.myActivity,
                      icon: IconsaxOutline.notification_bing,
                      onTap: () {
                        context.push(MyActivityScreen.route);
                      }
                  ),
                  SelectableMenuOption(
                      title: StringsProfile.rewards,
                      icon: IconsaxOutline.cup,
                      onTap: () {
                        context.push(MyRewardsScreen.route);
                      }
                  ),
                  SelectableMenuOption(
                      title: StringsProfile.monthlyReport,
                      icon: IconsaxOutline.money,
                      onTap: () {
                        context.push(MonthlyBalanceScreen.route);
                      }
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48.0,
              left: 0,
              right: 0,
              child: Center(
                child: FilledButton(
                  onPressed: model.closeSession,
                  child: const Text(
                    StringsProfile.closeSession,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Image Picker function to get image from gallery
  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 1000,
      maxHeight: 1000
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.model.updateAvatar(_image!);
      }
    });
  }

  //Image Picker function to get image from camera
  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      maxWidth: 1000,
      maxHeight: 1000
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.model.updateAvatar(_image!);
      }
    });
  }

  Future<void> showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          Container(
            color: AppColors.secondaryColor,
            child: CupertinoActionSheetAction(
              child: Text(
                StringsProfile.fromGallery,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                getImageFromGallery();
              },
            ),
          ),
          Container(
            color: AppColors.secondaryColor,
            child: CupertinoActionSheetAction(
              child: Text(
                  StringsProfile.fromCamera,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white)
              ),
              onPressed: () {
                Navigator.of(context).pop();
                getImageFromCamera();
              },
            ),
          ),
        ],
      ),
    );
  }

  void displayAvatar({required String image}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          image: image,
          tag: "AvatarWidget",
          isFile: image.isEmpty,
          imageFile: _image,
        ),
      ),
    );
  }
}
