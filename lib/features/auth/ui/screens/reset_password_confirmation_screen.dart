import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/constants.dart';
import 'package:bondly_app/config/strings_reset_password.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/features/auth/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ResetPasswordConfirmationScreen extends StatelessWidget {
  static const String route = "/resetPasswordConfirmation";

  const ResetPasswordConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bondly = Theme.of(context).extension<BondlyColorScheme>()!;
    var screenWidth =
        MediaQuery.of(context).size.width > Constants.mobileBreakpoint
            ? Constants.boxedCenteredContentWidth
            : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bondly.bg,
      body: Container(
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
                  _buildLogo(context),
                  const SizedBox(height: 24),
                  _buildCheckIcon(),
                  const SizedBox(height: 24),
                  _buildTitle(bondly),
                  const SizedBox(height: 12),
                  _buildDescription(bondly),
                  const SizedBox(height: 32),
                  _buildGoToLoginButton(context, bondly),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    const logoImagePath = "assets/img_logo.png";
    const logoDarkImagePath = "assets/img_logo_dark.png";

    return SizedBox(
      width: 200,
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          context.isDarkMode ? logoDarkImagePath : logoImagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCheckIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        LucideIcons.checkCircle,
        color: Colors.green,
        size: 64,
      ),
    );
  }

  Widget _buildTitle(BondlyColorScheme bondly) {
    return Text(
      ResetPasswordStrings.confirmationTitle,
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
        ResetPasswordStrings.confirmationDescription,
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

  Widget _buildGoToLoginButton(BuildContext context, BondlyColorScheme bondly) {
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
            context.go(LoginScreen.route);
          },
          child: Center(
            child: Text(
              ResetPasswordStrings.goToLogin,
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
}
