import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_reset_password.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/states/reset_password_ui_state.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/reset_password_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String route = "/resetPassword";
  static const String tokenParam = "token";

  const ResetPasswordScreen({super.key, this.token = ""});

  final String token;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";

  final ResetPasswordViewModel model = getIt<ResetPasswordViewModel>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final bondly = Theme.of(context).extension<BondlyColorScheme>()!;

    return Scaffold(
      backgroundColor: bondly.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bondly.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.arrowLeft,
              size: 18,
              color: bondly.textPrimary,
            ),
          ),
        ),
      ),
      body: ModelProvider<ResetPasswordViewModel>(
        model: model,
        child: ModelBuilder<ResetPasswordViewModel>(
          builder: (context, viewModel, child) {
            var screenWidth =
                MediaQuery.of(context).size.width > Constants.mobileBreakpoint
                    ? Constants.boxedCenteredContentWidth
                    : MediaQuery.of(context).size.width;

            switch (viewModel.state) {
              case ResetPasswordLoading _:
                return _buildLoadingView(bondly, screenWidth);
              case ResetPasswordFailed error:
                return _buildFormView(
                  bondly,
                  screenWidth,
                  errorType: error.errorType,
                );
              default:
                return _buildFormView(bondly, screenWidth);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView(BondlyColorScheme bondly, double screenWidth) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildFormView(
    BondlyColorScheme bondly,
    double screenWidth, {
    ResetPasswordErrorType? errorType,
  }) {
    String errorMessage = '';
    switch (errorType) {
      case ResetPasswordErrorType.emptyPassword:
        errorMessage = ResetPasswordStrings.emptyPassword;
      case ResetPasswordErrorType.weakPassword:
        errorMessage = ResetPasswordStrings.weakPassword;
      case ResetPasswordErrorType.passwordsDoNotMatch:
        errorMessage = ResetPasswordStrings.passwordsDoNotMatch;
      case ResetPasswordErrorType.connectionError:
        errorMessage = ResetPasswordStrings.connectionError;
      case ResetPasswordErrorType.unknownError:
        errorMessage = ResetPasswordStrings.unknownError;
      default:
        errorMessage = '';
    }

    return Container(
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
                _buildTitle(bondly),
                const SizedBox(height: 12),
                _buildDescription(bondly),
                const SizedBox(height: 32),
                _buildPasswordInput(bondly),
                const SizedBox(height: 14),
                _buildConfirmPasswordInput(bondly),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                _buildResetButton(bondly),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildTitle(BondlyColorScheme bondly) {
    return Text(
      ResetPasswordStrings.title,
      style: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: bondly.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BondlyColorScheme bondly) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        ResetPasswordStrings.description,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: bondly.textSecondary,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
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
              style: GoogleFonts.inter(
                fontSize: 14,
                color: bondly.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: ResetPasswordStrings.passwordLabel,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: bondly.textMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
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

  Widget _buildConfirmPasswordInput(BondlyColorScheme bondly) {
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
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              enableSuggestions: false,
              autocorrect: false,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: bondly.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: ResetPasswordStrings.confirmPasswordLabel,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: bondly.textMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            child: Icon(
              _obscureConfirmPassword ? LucideIcons.eyeOff : LucideIcons.eye,
              size: 20,
              color: bondly.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BondlyColorScheme bondly) {
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
            model.onResetPassword(
              widget.token,
              _passwordController.text,
              _confirmPasswordController.text,
            );
          },
          child: Center(
            child: Text(
              ResetPasswordStrings.resetButton,
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

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
