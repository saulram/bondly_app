import 'package:bondly_app/features/auth/ui/viewmodels/login_ui_state.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_view_model.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_login.dart';
import 'package:bondly_app/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  final LoginViewModel model;

  const LoginScreen(this.model, {Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String _logoImagePath = "assets/img_logo.png";

  @override
  void didChangeDependencies() {
    DeviceScale().currentDeviceHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModelProvider<LoginViewModel>(
        model: widget.model,
        child: ModelBuilder<LoginViewModel>(
          builder: (context, model, child) {
            var screenWidth = MediaQuery.of(context).size.width > Constants.mobileBreakpoint ?
            Constants.boxedCenteredContentWidth : MediaQuery.of(context).size.width;
            switch (model.state) {
              case LoadingLogin _:
                return const Center(child: CupertinoActivityIndicator());
              case SuccessLogin _:
                return Container();
              case FailureLogin error:
              default:
                return _buildLoginView(screenWidth);
            }
          }
        ),
      )
    );
  }


  Widget _buildLoginView(double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: 64.dp),
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
              _buildWelcomeMessage(),
              _buildForm(),
              _buildActions()
            ],
          ),
        ),
      ),
    );
}

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 36.dp),
      child: Image.asset(_logoImagePath),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      margin: EdgeInsets.only(top: 48.dp, left: 24.dp, right: 24.dp),
      child: Text(
        LoginStrings.welcomeMessage,
        style: context.themeData.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 48.dp, vertical: 36.dp),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                label: Text(
                  LoginStrings.username,
                  style: context.themeData.textTheme.bodyMedium,
                ),
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder()),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: Constants.usernameMaxLength,
          ),
          SizedBox(
            height: 12.dp,
          ),
          TextFormField(
            decoration: InputDecoration(
                label: Text(
                  LoginStrings.password,
                  style: context.themeData.textTheme.bodyMedium,
                ),
                prefixIcon: const Icon(Icons.password),
                border: const OutlineInputBorder()),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            maxLength: Constants.passwordMaxLength,
          )
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 24.dp, left: 48.dp, right: 48.dp),
          child: FilledButton(
            onPressed: () {
              widget.model.onLoginAction();
            },
            style: AppStyles.primaryButtonStyle,
            child: Text(
              LoginStrings.enter,
              style: AppStyles.primaryButtonTextStyle,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8.dp),
          child: TextButton(
            style: context.themeData.textButtonTheme.style,
            onPressed: () {
              print("hola");
            },
            child:const Text(
              LoginStrings.forgotPassword,
            ),
          ),
        )
      ],
    );
  }
}
