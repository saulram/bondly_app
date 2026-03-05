import 'package:bondly_app/config/backend_config.dart';
import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_login.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/screens/forgot_password_screen.dart';
import 'package:bondly_app/features/auth/ui/states/login_ui_state.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/login_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/main/ui/extensions/device_scale.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/loginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";

  final LoginViewModel model = getIt<LoginViewModel>();

  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    final bondly = Theme.of(context).extension<BondlyColorScheme>()!;

    return Scaffold(
      backgroundColor: bondly.bg,
      body: ModelProvider<LoginViewModel>(
        model: model,
        child: ModelBuilder<LoginViewModel>(
          builder: (context, viewModel, child) {
            var screenWidth =
                MediaQuery.of(context).size.width > Constants.mobileBreakpoint
                    ? Constants.boxedCenteredContentWidth
                    : MediaQuery.of(context).size.width;

            switch (viewModel.state) {
              case LoadingLogin _:
                return LoginSkeletonLoader(screenWidth: screenWidth);
              case SuccessLogin _:
                return Container();
              case FailedLogin error:
                return _buildLoginView(
                  bondly,
                  screenWidth,
                  errorType: error.errorType,
                );
              default:
                return _buildLoginView(bondly, screenWidth);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoginView(
    BondlyColorScheme bondly,
    double screenWidth, {
    LoginErrorType? errorType,
  }) {
    String errorMessage = '';
    switch (errorType) {
      case LoginErrorType.authError:
        errorMessage = LoginStrings.invalidCredentials;
      case LoginErrorType.connectionError:
        errorMessage = LoginStrings.connectionError;
      case LoginErrorType.unknownError:
        errorMessage = LoginStrings.unknownError;
      case LoginErrorType.defaultCompanyError:
        errorMessage = LoginStrings.noCompanySelected;
      default:
        errorMessage = '';
    }

    bool showInputError = errorType == LoginErrorType.invalidInputError;
    final isDesktop =
        MediaQuery.of(context).size.width > Constants.desktopBreakpoint;

    if (isDesktop) {
      return _buildDesktopLoginLayout(bondly, showInputError, errorMessage);
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 16),
                _buildWelcomeText(bondly),
                const SizedBox(height: 32),
                _buildForm(bondly, showInputError, errorMessage),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLoginLayout(
    BondlyColorScheme bondly,
    bool showInputError,
    String errorMessage,
  ) {
    return Row(
      children: [
        // Left info panel
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              decoration: BoxDecoration(
                color: bondly.surface,
                border: Border(right: BorderSide(color: bondly.border)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 24),
                      _buildWelcomeText(bondly),
                      const SizedBox(height: 12),
                      Text(
                        'Tu plataforma de reconocimientos',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: bondly.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Right form panel
        Expanded(
          child: Container(
            color: bondly.bg,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: 8,
                  shadowColor: bondly.accent.withValues(alpha: 0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: bondly.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: SingleChildScrollView(
                      child: _buildForm(bondly, showInputError, errorMessage),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 200,
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          context.isDarkMode ? _logoDarkImagePath : _logoImagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BondlyColorScheme bondly) {
    return Text(
      LoginStrings.welcomeMessage,
      style: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: bondly.textPrimary,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }

  Widget _buildForm(
    BondlyColorScheme bondly,
    bool showInputError,
    String errorMessage,
  ) {
    return Column(
      children: [
        _buildUserInput(bondly),
        if (showInputError) _buildFieldError(),
        const SizedBox(height: 14),
        _buildPasswordInput(bondly),
        if (showInputError) _buildFieldError(),
        if (BackendConfig.isApi) ...[
          const SizedBox(height: 14),
          _buildCompanyPicker(bondly),
        ],
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              errorMessage,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 72),
        _buildLoginButton(bondly),
        const SizedBox(height: 14),
        _buildForgotPassword(bondly),
      ],
    );
  }

  Widget _buildUserInput(BondlyColorScheme bondly) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bondly.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bondly.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(LucideIcons.user, size: 20, color: bondly.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _userController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: Constants.usernameMaxLength,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: bondly.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: LoginStrings.username,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: bondly.textMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput(BondlyColorScheme bondly) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bondly.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bondly.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(LucideIcons.lock, size: 20, color: bondly.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              enableSuggestions: false,
              autocorrect: false,
              maxLength: Constants.passwordMaxLength,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: bondly.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: LoginStrings.password,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: bondly.textMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: Icon(
              _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
              size: 20,
              color: bondly.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyPicker(BondlyColorScheme bondly) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bondly.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bondly.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(LucideIcons.building2, size: 20, color: bondly.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCompany.isEmpty ? null : _selectedCompany,
                hint: Text(
                  LoginStrings.selectYourCompany,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: bondly.textMuted,
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: bondly.textMuted,
                ),
                dropdownColor: bondly.surfaceElevated,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: bondly.textPrimary,
                ),
                items: model.companies
                    .where((c) => c != LoginStrings.selectYourCompany)
                    .map((company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCompany = value ?? "";
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BondlyColorScheme bondly) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bondly.accentGradientStart, bondly.accentGradientEnd],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x307C3AED),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            model.onLoginAction(
              _userController.text,
              _passwordController.text,
              _selectedCompany,
            );
          },
          child: Center(
            child: Text(
              LoginStrings.enter,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: BondlyColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(BondlyColorScheme bondly) {
    return GestureDetector(
      onTap: () {
        model.navigation.push(ForgotPasswordScreen.route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          LoginStrings.forgotPassword,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: bondly.accent,
          ),
        ),
      ),
    );
  }

  Widget _buildFieldError() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          LoginStrings.required,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
