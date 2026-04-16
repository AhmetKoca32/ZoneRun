import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/navigation/main_navigation.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../utils/auth_l10n.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _submitted = false;
  bool _primaryButtonPressed = false;
  bool _googleButtonPressed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false,
      );
    } else if (mounted && authProvider.errorCode != null) {
      final theme = context.appTheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AuthL10n.messageFor(context, authProvider.errorCode)!,
            style: AppTypography.bodyMedium.copyWith(color: theme.textPrimary),
          ),
          backgroundColor: theme.secondaryBackground,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController(
      text: _emailController.text.trim(),
    );

    showDialog(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.surface,
                  theme.surface.withOpacity(0.9),
                  theme.secondaryBackground.withOpacity(0.3),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.textPrimary.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.primaryBackground.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: theme.textPrimary,
                        size: 24,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: theme.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.authForgotPasswordTitle,
                  style: AppTypography.headlineSmall.copyWith(
                    color: theme.textPrimary,
                    fontWeight: AppTypography.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.authForgotPasswordDescription,
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.textSecondary,
                    fontWeight: AppTypography.light,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: false,
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.textPrimary,
                    fontWeight: AppTypography.medium,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.authEmailHint,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: theme.textSecondary,
                    ),
                    prefixIcon: Icon(Icons.mail_outline, color: theme.textSecondary),
                    filled: true,
                    fillColor: theme.primaryBackground.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: theme.border, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: theme.border, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: theme.accent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.border, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              l10n.cancel,
                              style: AppTypography.bodyMedium.copyWith(
                                color: theme.textPrimary,
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final email = emailController.text.trim();
                          if (email.isEmpty || !email.contains('@')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.authForgotPasswordInvalidEmail,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: theme.textPrimary,
                                  ),
                                ),
                                backgroundColor: theme.secondaryBackground,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          final success =
                              await authProvider.sendPasswordResetEmail(email);
                          if (!dialogContext.mounted) return;
                          Navigator.of(dialogContext).pop();
                          if (!context.mounted) return;
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.authForgotPasswordSent,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: theme.textPrimary,
                                  ),
                                ),
                                backgroundColor: theme.secondaryBackground,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else if (authProvider.errorCode != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AuthL10n.messageFor(context, authProvider.errorCode)!,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: theme.textPrimary,
                                  ),
                                ),
                                backgroundColor: theme.secondaryBackground,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.accent,
                                theme.accent.withOpacity(0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: theme.accent.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              l10n.authForgotPasswordSend,
                              style: AppTypography.bodyMedium.copyWith(
                                color: theme.primaryBackground,
                                fontWeight: AppTypography.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static const _websiteBaseUrl = 'https://zone-run.vercel.app';

  Future<void> _launchLegalUrl(BuildContext context, {required bool isTerms}) async {
    final locale = Localizations.localeOf(context).languageCode;
    final path = isTerms
        ? (locale == 'tr' ? '/kullanim-kosullari/' : '/terms/')
        : (locale == 'tr' ? '/gizlilik/' : '/privacy/');
    final uri = Uri.parse('$_websiteBaseUrl$path');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.linkOpenFailed),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false,
      );
    } else if (mounted && authProvider.errorCode != null) {
      final theme = context.appTheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AuthL10n.messageFor(context, authProvider.errorCode)!,
            style: AppTypography.bodyMedium.copyWith(color: theme.textPrimary),
          ),
          backgroundColor: theme.secondaryBackground,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  // Top section with logo
                  SizedBox(height: screenHeight * 0.12),
              Center(
                child: Image.asset(
                  'assets/icons/zonerun-high-resolution-logo-transparent.png',
                  height: 80,
                  fit: BoxFit.contain,
                  // Logo always white on login/signup pages
                ),
              ),

              // White card with form - takes remaining space
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: screenHeight * 0.14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.lerp(theme.surface, theme.textPrimary, 0.06)!,
                        theme.surface,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Tab Navigation (pill/segment)
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Already on login page
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.accent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      l10n.authLoginTab,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: theme.primaryBackground,
                                        fontWeight: AppTypography.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => const SignUpPage(),
                                        transitionsBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                        transitionDuration: const Duration(
                                          milliseconds: 300,
                                        ),
                                      ),
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.secondaryBackground,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      l10n.authSignUpTab,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: theme.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.authEmailHint,
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: theme.textSecondary,
                              ),
                              prefixIcon: Icon(Icons.mail_outline, color: theme.textSecondary),
                              filled: true,
                              fillColor: theme.secondaryBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: theme.accent,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.authEmailRequired;
                              }
                              if (!value.contains('@')) {
                                return l10n.authEmailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            autofillHints: const [AutofillHints.password],
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.authPasswordHint,
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: theme.textSecondary,
                              ),
                              prefixIcon: Icon(Icons.lock_outline, color: theme.textSecondary),
                              filled: true,
                              fillColor: theme.secondaryBackground,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: theme.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: theme.accent,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.authPasswordRequired;
                              }
                              if (value.length < 6) {
                                return l10n.authPasswordMinLength;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _showForgotPasswordDialog(context),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.accent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                l10n.authForgotPassword,
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.accent,
                                  fontWeight: AppTypography.medium,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              final emailLoading = authProvider.isLoading && !authProvider.isGoogleLoading;
                              return GestureDetector(
                                onTapDown: authProvider.isLoading ? null : (_) => setState(() => _primaryButtonPressed = true),
                                onTapUp: (_) => setState(() => _primaryButtonPressed = false),
                                onTapCancel: () => setState(() => _primaryButtonPressed = false),
                                onTap: authProvider.isLoading ? null : _handleLogin,
                                child: AnimatedScale(
                                  scale: _primaryButtonPressed ? 0.98 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.textPrimary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: emailLoading
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                      theme.surface,
                                                    ),
                                              ),
                                            )
                                          : Text(
                                              l10n.authContinueButton,
                                              style: AppTypography.bodyLarge
                                                  .copyWith(
                                                    color: theme.surface,
                                                    fontWeight:
                                                        AppTypography.bold,
                                                  ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Divider
                          Center(
                            child: Text(
                              l10n.authOr,
                              style: AppTypography.bodySmall.copyWith(
                                color: theme.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Google Sign In Button
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return GestureDetector(
                                onTapDown: authProvider.isLoading ? null : (_) => setState(() => _googleButtonPressed = true),
                                onTapUp: (_) => setState(() => _googleButtonPressed = false),
                                onTapCancel: () => setState(() => _googleButtonPressed = false),
                                onTap: authProvider.isLoading ? null : _handleGoogleSignIn,
                                child: AnimatedScale(
                                  scale: _googleButtonPressed ? 0.98 : 1.0,
                                  duration: const Duration(milliseconds: 100),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.secondaryBackground,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.border,
                                        width: 1,
                                      ),
                                    ),
                                    child: authProvider.isGoogleLoading
                                        ? Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  theme.textPrimary,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/google_logo.png',
                                                height: 24,
                                                width: 24,
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                      return Icon(
                                                        Icons.g_mobiledata,
                                                        color: theme.textPrimary,
                                                        size: 24,
                                                      );
                                                    },
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                l10n.authContinueWithGoogle,
                                                style: AppTypography.bodyMedium
                                                    .copyWith(
                                                      color: theme.textPrimary,
                                                      fontWeight:
                                                          AppTypography.semiBold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Terms and Privacy
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text.rich(
                              TextSpan(
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.textSecondary,
                                  fontSize: 11,
                                ),
                                children: [
                                  TextSpan(text: l10n.authTermsPrefix),
                                  TextSpan(
                                    text: l10n.termsOfUse,
                                    style: TextStyle(
                                      color: theme.accent,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _launchLegalUrl(context, isTerms: true),
                                  ),
                                  TextSpan(text: l10n.authTermsAnd),
                                  TextSpan(
                                    text: l10n.privacyPolicy,
                                    style: TextStyle(
                                      color: theme.accent,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _launchLegalUrl(context, isTerms: false),
                                  ),
                                  TextSpan(text: l10n.authTermsSuffix),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
