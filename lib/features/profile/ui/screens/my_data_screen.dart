import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDataScreen extends StatefulWidget {
  static const String route = "/myData";

  const MyDataScreen({super.key});

  @override
  State<MyDataScreen> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  final ProfileViewModel _model = getIt<ProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ModelProvider<ProfileViewModel>(
      model: _model,
      child: ModelBuilder<ProfileViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: AppColors.secondaryColor,
          body: Column(
            children: [
              SafeArea(
                  child: Column(
                    children: [
                      _buildTopBar(theme),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: 48.0,
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
                      StringsProfile.myData,
                      style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}