import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_forgot_password.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/screens/verify_reset_token_screen.dart';
import 'package:bondly_app/features/auth/ui/states/forgot_password_ui_state.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/forgot_password_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
  final _emailController = TextEditingController();

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
                return _buildSuccessView(bondly, screenWidth);
              case ForgotPasswordFailed error:
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

  Widget _buildFormView(
    BondlyColorScheme bondly,
    double screenWidth, {
    ForgotPasswordErrorType? errorType,
  }) {
    String errorMessage = '';
    switch (errorType) {
      case ForgotPasswordErrorType.emptyEmail:
        errorMessage = ForgotPasswordStrings.emailRequired;
      case ForgotPasswordErrorType.invalidEmail:
        errorMessage = ForgotPasswordStrings.invalidEmail;
      case ForgotPasswordErrorType.connectionError:
        errorMessage = ForgotPasswordStrings.connectionError;
      case ForgotPasswordErrorType.unknownError:
        errorMessage = ForgotPasswordStrings.unknownError;
      default:
        errorMessage = '';
    }

    final isDesktop =
        MediaQuery.of(context).size.width > Constants.desktopBreakpoint;

    if (isDesktop) {
      return _buildDesktopLayout(bondly, errorMessage);
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
                _buildForm(bondly, errorMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BondlyColorScheme bondly, String errorMessage) {
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
                      _buildTitle(bondly),
                      const SizedBox(height: 12),
                      _buildDescription(bondly),
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
                      child: _buildForm(bondly, errorMessage),
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

  Widget _buildSuccessView(BondlyColorScheme bondly, double screenWidth) {
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
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.checkCircle,
                        color: Colors.green,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ForgotPasswordStrings.successMessage,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: bondly.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildHaveCodeButton(bondly),
                const SizedBox(height: 14),
                _buildBackToLogin(bondly),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHaveCodeButton(BondlyColorScheme bondly) {
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
            model.navigation.push(
              VerifyResetTokenScreen.route,
              extra: {
                VerifyResetTokenScreen.emailParam: _emailController.text,
              },
            );
          },
          child: Center(
            child: Text(
              ForgotPasswordStrings.haveCode,
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
      ForgotPasswordStrings.title,
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

  Widget _buildDescription(BondlyColorScheme bondly) {
    return Text(
      ForgotPasswordStrings.description,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: bondly.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }

  Widget _buildForm(BondlyColorScheme bondly, String errorMessage) {
    return Column(
      children: [
        _buildEmailInput(bondly),
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
        const SizedBox(height: 14),
        _buildSendButton(bondly),
        const SizedBox(height: 14),
        _buildBackToLogin(bondly),
      ],
    );
  }

  Widget _buildEmailInput(BondlyColorScheme bondly) {
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
          Icon(LucideIcons.mail, size: 20, color: bondly.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: bondly.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: ForgotPasswordStrings.emailLabel,
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
        ],
      ),
    );
  }

  Widget _buildSendButton(BondlyColorScheme bondly) {
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
            model.onResetPassword(_emailController.text);
          },
          child: Center(
            child: Text(
              ForgotPasswordStrings.sendButton,
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

  Widget _buildBackToLogin(BondlyColorScheme bondly) {
    return GestureDetector(
      onTap: () {
        model.goBackToLogin();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          ForgotPasswordStrings.backToLogin,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: bondly.accent,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
