import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_profile.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/profile_viewmodel.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/cupertino.dart';
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
  final nameTextFieldController = TextEditingController();
  final emailTextFieldController = TextEditingController();
  final dobTextFieldController = TextEditingController();
  final cityTextFieldController = TextEditingController();
  final jobTextFieldController = TextEditingController();

  DateTime selectedDate = DateTime(2000);
  bool updatedDate = false;

  @override
  void initState() {
    super.initState();
    _model.loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _model.dispose();
  }

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
                  child: _buildTopBar(theme)
              ),
              _buildBodyCard(theme, model)
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

  Widget _buildBodyCard(ThemeData theme, ProfileViewModel model) {
    var stringDate = model.userProfile?.dob.toString();
    nameTextFieldController.text = model.userProfile?.user.completeName ?? "";
    emailTextFieldController.text = model.userProfile?.user.email ?? "";
    cityTextFieldController.text = model.userProfile?.location ?? "";
    dobTextFieldController.text = updatedDate
        ? "${selectedDate.year}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}"
        : stringDate?.substring(0, stringDate.indexOf(" ")) ?? "";
    jobTextFieldController.text = model.userProfile?.jobPosition ?? "";

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
        width: double.infinity,
        child: model.busy ? CircularProgressIndicator.adaptive(
          backgroundColor: theme.unselectedWidgetColor,
        )
            : Container(
          margin: const EdgeInsets.symmetric(
              vertical: 36.0,
              horizontal: 32.0
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  StringsProfile.myDataSubtitle,
                  style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: 18.0
                  ),
                ),
                const SizedBox(height: 64.0),
                _getNameTextField(theme),
                const SizedBox(height: 32.0),
                _getEmailTextField(theme),
                const SizedBox(height: 32.0),
                _getCityTextField(theme),
                const SizedBox(height: 32.0),
                _getJobTitleTextField(theme),
                const SizedBox(height: 32.0),
                _getDOBTextField(theme),
                const SizedBox(height: 64.0),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      model.saveMyData(
                          email: emailTextFieldController.text,
                          location: cityTextFieldController.text,
                          dob: dobTextFieldController.text,
                          job: jobTextFieldController.text
                      );
                    },
                    child: const Text(
                      StringsProfile.saveMyData,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getNameTextField(ThemeData theme) {
    return TextFormField(
      readOnly: true,
      controller: nameTextFieldController,
      decoration: InputDecoration(
        label: Text(
          StringsProfile.fullName,
          style: theme.textTheme.bodyMedium,
        ),
        prefixIcon: const Icon(IconsaxBold.user),
      ),
    );
  }

  Widget _getCityTextField(ThemeData theme) {
    return TextFormField(
      controller: cityTextFieldController,
      decoration: InputDecoration(
        label: Text(
          StringsProfile.location,
          style: theme.textTheme.bodyMedium,
        ),
        prefixIcon: const Icon(IconsaxBold.location),
      ),
    );
  }

  Widget _getEmailTextField(ThemeData theme) {
    return TextFormField(
      controller: emailTextFieldController,
      decoration: InputDecoration(
        label: Text(
          StringsProfile.email,
          style: theme.textTheme.bodyMedium,
        ),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }

  Widget _getDOBTextField(ThemeData theme) {
    return TextFormField(
      readOnly: true,
      onTap: _showDialog,
      controller: dobTextFieldController,
      decoration: InputDecoration(
        label: Text(
          StringsProfile.dob,
          style: theme.textTheme.bodyMedium,
        ),
        prefixIcon: const Icon(IconsaxBold.cake),
      )
    );
  }

  Widget _getJobTitleTextField(ThemeData theme) {
    return TextFormField(
      controller: jobTextFieldController,
      decoration: InputDecoration(
        label: Text(
          StringsProfile.jobTitle,
          style: theme.textTheme.bodyMedium,
        ),
        prefixIcon: const Icon(IconsaxBold.briefcase),
      ),
    );
  }

  Future<void> _showDialog() async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: selectedDate,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            // This shows day of week alongside day of month
            showDayOfWeek: true,
            // This is called when the user changes the date.
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                updatedDate = true;
                selectedDate = newDate;
              });
            },
          ),
        ),
      ),
    );
  }
}