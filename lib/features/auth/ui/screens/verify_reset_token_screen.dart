import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_verify_reset_token.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/auth/ui/states/verify_reset_token_ui_state.dart';
import 'package:bondly_app/features/auth/ui/viewmodels/verify_reset_token_viewmodel.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class VerifyResetTokenScreen extends StatefulWidget {
  static const String route = "/verifyResetToken";
  static const String emailParam = "email";

  const VerifyResetTokenScreen({super.key, this.email = ""});

  final String email;

  @override
  State<VerifyResetTokenScreen> createState() => _VerifyResetTokenScreenState();
}

class _VerifyResetTokenScreenState extends State<VerifyResetTokenScreen> {
  final String _logoImagePath = "assets/img_logo.png";
  final String _logoDarkImagePath = "assets/img_logo_dark.png";

  final VerifyResetTokenViewModel model = getIt<VerifyResetTokenViewModel>();
  final List<TextEditingController> _digitControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _token => _digitControllers.map((c) => c.text).join();

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
      body: ModelProvider<VerifyResetTokenViewModel>(
        model: model,
        child: ModelBuilder<VerifyResetTokenViewModel>(
          builder: (context, viewModel, child) {
            var screenWidth =
                MediaQuery.of(context).size.width > Constants.mobileBreakpoint
                    ? Constants.boxedCenteredContentWidth
                    : MediaQuery.of(context).size.width;

            switch (viewModel.state) {
              case VerifyResetTokenLoading _:
                return _buildLoadingView(bondly, screenWidth);
              case VerifyResetTokenFailed error:
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
    VerifyResetTokenErrorType? errorType,
  }) {
    String errorMessage = '';
    switch (errorType) {
      case VerifyResetTokenErrorType.emptyToken:
        errorMessage = VerifyResetTokenStrings.emptyToken;
      case VerifyResetTokenErrorType.invalidToken:
        errorMessage = VerifyResetTokenStrings.invalidToken;
      case VerifyResetTokenErrorType.expiredToken:
        errorMessage = VerifyResetTokenStrings.expiredToken;
      case VerifyResetTokenErrorType.connectionError:
        errorMessage = VerifyResetTokenStrings.connectionError;
      case VerifyResetTokenErrorType.unknownError:
        errorMessage = VerifyResetTokenStrings.unknownError;
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
                _buildOtpFields(bondly),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errorMessage,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),
                _buildVerifyButton(bondly),
                const SizedBox(height: 14),
                _buildResendCode(bondly),
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
      VerifyResetTokenStrings.title,
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
        VerifyResetTokenStrings.description,
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

  Widget _buildOtpFields(BondlyColorScheme bondly) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 48,
          height: 52,
          margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
          decoration: BoxDecoration(
            color: bondly.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: bondly.border),
          ),
          child: TextField(
            controller: _digitControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: bondly.textPrimary,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                _focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton(BondlyColorScheme bondly) {
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
            model.onVerifyToken(widget.email, _token);
          },
          child: Center(
            child: Text(
              VerifyResetTokenStrings.verifyButton,
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

  Widget _buildResendCode(BondlyColorScheme bondly) {
    return GestureDetector(
      onTap: () {
        if (widget.email.isNotEmpty) {
          model.onResendCode(widget.email);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          VerifyResetTokenStrings.resendCode,
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
    for (final controller in _digitControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
