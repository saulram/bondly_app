import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_forgot_password.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/states/forgot_password_ui_state.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/forgot_password_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String route = "/forgotPassword";

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";

  final ForgotPasswordViewModel model = getIt<ForgotPasswordViewModel>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModelProvider<ForgotPasswordViewModel>(
        model: model,
        child: ModelBuilder<ForgotPasswordViewModel>(
          builder: (context, viewModel, child) {
            var screenWidth =
                MediaQuery.of(context).size.width > Constants.mobileBreakpoint
                    ? Constants.boxedCenteredContentWidth
                    : MediaQuery.of(context).size.width;

            switch (viewModel.state) {
              case ForgotPasswordLoading _:
                return ForgotPasswordSkeletonLoader(screenWidth: screenWidth);
              case ForgotPasswordSuccess _:
                return _buildSuccessView(screenWidth);
              case ForgotPasswordFailed error:
                return _buildFormView(screenWidth, errorType: error.errorType);
              default:
                return _buildFormView(screenWidth);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFormView(
    double screenWidth, {
    ForgotPasswordErrorType? errorType,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(),
              _buildTitle(),
              _buildDescription(),
              _buildEmailField(errorType),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(double screenWidth) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(),
              _buildTitle(),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 32.dp,
                  vertical: 24.dp,
                ),
                padding: EdgeInsets.all(16.dp),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12.dp),
                    Expanded(
                      child: Text(
                        ForgotPasswordStrings.successMessage,
                        style: context.themeData.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              _buildBackToLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 36.dp),
      child: Image.asset(
        context.isDarkMode ? _logoDarkImagePath : _logoImagePath,
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 48.dp, left: 24.dp, right: 24.dp),
      child: Text(
        ForgotPasswordStrings.title,
        style: context.themeData.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.only(top: 16.dp, left: 32.dp, right: 32.dp),
      child: Text(
        ForgotPasswordStrings.description,
        style: context.themeData.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmailField(ForgotPasswordErrorType? errorType) {
    String errorDescription;
    switch (errorType) {
      case ForgotPasswordErrorType.emptyEmail:
        errorDescription = ForgotPasswordStrings.emailRequired;
      case ForgotPasswordErrorType.invalidEmail:
        errorDescription = ForgotPasswordStrings.invalidEmail;
      case ForgotPasswordErrorType.connectionError:
        errorDescription = ForgotPasswordStrings.connectionError;
      case ForgotPasswordErrorType.unknownError:
        errorDescription = ForgotPasswordStrings.unknownError;
      default:
        errorDescription = "";
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.dp, vertical: 36.dp),
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              label: Text(
                ForgotPasswordStrings.emailLabel,
                style: context.themeData.textTheme.bodyMedium,
              ),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
          if (errorDescription.isNotEmpty)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8.dp),
              child: Text(
                errorDescription,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 48.dp),
          child: FilledButton(
            onPressed: () {
              model.onResetPassword(emailController.text);
            },
            child: const Text(ForgotPasswordStrings.sendButton),
          ),
        ),
        _buildBackToLoginButton(),
      ],
    );
  }

  Widget _buildBackToLoginButton() {
    return Container(
      margin: EdgeInsets.only(top: 8.dp),
      child: TextButton(
        onPressed: () {
          model.goBackToLogin();
        },
        child: const Text(ForgotPasswordStrings.backToLogin),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
