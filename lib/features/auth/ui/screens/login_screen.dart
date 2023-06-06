import 'package:bondly_app/features/auth/ui/viewmodels/login_view_model.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_login.dart';
import 'package:bondly_app/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String _logoImagePath = "assets/img_logo.png";
  final LoginViewModel _model = LoginViewModel();

  @override
  void didChangeDependencies() {
    DeviceScale().currentDeviceHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModelProvider<LoginViewModel>(
        model: _model,
        child: ModelBuilder<LoginViewModel>(
          builder: (context, model, child) {
            var screenWidth = MediaQuery.of(context).size.width > Constants.mobileBreakpoint ?
                Constants.boxedCenteredContentWidth : MediaQuery.of(context).size.width;
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
        ),
      )
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 36.dp),
      child: Image.asset(
          _logoImagePath
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      margin: EdgeInsets.only(
        top: 48.dp,
        left: 24.dp,
        right: 24.dp
      ),
      child: Text(
        LoginStrings.welcomeMessage,
        style: AppStyles.baseTextStyle.copyWith(
          fontSize: 18
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 48.dp,
        vertical: 36.dp
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: Text(
                LoginStrings.username,
                style: AppStyles.baseTextStyle,
              ),
              prefixIcon: const Icon(Icons.person),
              border: const OutlineInputBorder()
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: Constants.usernameMaxLength,
          ),
          SizedBox(height: 12.dp,),
          TextFormField(
            decoration: InputDecoration(
              label: Text(
                LoginStrings.password,
                style: AppStyles.baseTextStyle,
              ),
              prefixIcon: const Icon(Icons.password),
              border: const OutlineInputBorder()
            ),
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
          margin: EdgeInsets.only(
            top: 24.dp,
            left: 48.dp,
            right: 48.dp
          ),
          child: FilledButton(
            onPressed: () { print("Enter pressed");
              _model.login();
            },
            style: AppStyles.primaryButtonStyle,
            child: Text(
              LoginStrings.enter,
              style: AppStyles.primaryButtonTextStyle,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 8.dp
          ),
          child: TextButton(
            onPressed: () { print("hola"); },
            style: AppStyles.transparentButtonStyle,
            child: Text(
              LoginStrings.forgotPassword,
              style: AppStyles.transparentButtonTextStyle,
            ),
          ),
        )
      ],
    );
  }

}
