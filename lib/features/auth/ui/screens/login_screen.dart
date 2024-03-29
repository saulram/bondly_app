import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_login.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/states/login_ui_state.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/loginScreen";

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";
  final Logger l = Logger();

  final LoginViewModel model = getIt<LoginViewModel>();

  final userTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  String _selectedCompany = "";

  @override
  void initState() {
    super.initState();
    model.load();
  }

  @override
  void didChangeDependencies() {
    DeviceScale().currentDeviceHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    l.i("LoginScreen build");

    return Scaffold(
        body: ModelProvider<LoginViewModel>(
      model: model,
      child: ModelBuilder<LoginViewModel>(builder: (context, viewModel, child) {
        l.i("LoginScreen ModelBuilder");
        var screenWidth =
            MediaQuery.of(context).size.width > Constants.mobileBreakpoint
                ? Constants.boxedCenteredContentWidth
                : MediaQuery.of(context).size.width;
        l.i("state ${viewModel.state.toString()}");
        switch (viewModel.state) {
          case LoadingLogin _:
            return const Center(child: CupertinoActivityIndicator());
          case SuccessLogin _:
            return Container();
          case FailedLogin error:
            return _buildLoginView(screenWidth, errorType: error.errorType);
          default:
            return _buildLoginView(screenWidth);
        }
      }),
    ));
  }

  Widget _buildLoginView(double screenWidth, {LoginErrorType? errorType}) {
    l.i("LoginScreen _buildLoginView");
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
              _buildWelcomeMessage(),
              _buildForm(errorType),
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
      child:
          Image.asset(context.isDarkMode ? _logoDarkImagePath : _logoImagePath),
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

  Widget _buildForm(LoginErrorType? errorType) {
    bool showInputError = errorType == LoginErrorType.invalidInputError;
    String errorDescription;
    switch (errorType) {
      case LoginErrorType.authError:
        errorDescription = LoginStrings.invalidCredentials;
      case LoginErrorType.connectionError:
        errorDescription = LoginStrings.connectionError;
      case LoginErrorType.unknownError:
        errorDescription = LoginStrings.unknownError;
      case LoginErrorType.defaultCompanyError:
        errorDescription = LoginStrings.noCompanySelected;
      default:
        errorDescription = "";
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 48.dp, vertical: 36.dp),
      child: Column(
        children: [
          TextFormField(
            controller: userTextFieldController,
            decoration: InputDecoration(
              label: Text(
                LoginStrings.username,
                style: context.themeData.textTheme.bodyMedium,
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: Constants.usernameMaxLength,
          ),
          if (showInputError)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8.dp),
              child: const Text(LoginStrings.required),
            )
          else
            SizedBox(height: 8.dp),
          TextFormField(
            controller: passwordTextFieldController,
            decoration: InputDecoration(
              label: Text(
                LoginStrings.password,
                style: context.themeData.textTheme.bodyMedium,
              ),
              prefixIcon: const Icon(Icons.password),
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            maxLength: Constants.passwordMaxLength,
          ),
          if (showInputError)
            const SizedBox(
              width: double.infinity,
              child: Text(LoginStrings.required),
            )
          else if (errorDescription.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 8.dp),
              child: Text(
                errorDescription,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          SizedBox(height: 8.dp),
          DropdownButtonFormField(
              value: LoginStrings.selectYourCompany,
              dropdownColor: Theme.of(context).cardColor,
              items: model.companies.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (item) {
                _selectedCompany = item as String;
              }),
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
              model.onLoginAction(userTextFieldController.text,
                  passwordTextFieldController.text, _selectedCompany);
            },
            child: const Text(
              LoginStrings.enter,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8.dp),
          child: TextButton(
            onPressed: () {
              Logger().w("Forgot password pressed");
            },
            child: const Text(
              LoginStrings.forgotPassword,
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    userTextFieldController.dispose();
    passwordTextFieldController.dispose();
    super.dispose();
  }
}
