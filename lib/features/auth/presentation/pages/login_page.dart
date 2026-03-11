import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/navigation/main_navigation.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_extra.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
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
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.authForgotPasswordTitle,
            style: AppTypography.headlineSmall.copyWith(
              color: theme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.authForgotPasswordDescription,
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: l10n.authEmailHint,
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: theme.textSecondary,
                  ),
                  filled: true,
                  fillColor: theme.secondaryBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                emailController.dispose();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                l10n.cancel,
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () async {
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
                emailController.dispose();
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
              style: FilledButton.styleFrom(
                backgroundColor: theme.accent,
                foregroundColor: theme.primaryBackground,
              ),
              child: const Text('Gönder'),
            ),
          ],
        );
      },
    );
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
                  margin: const EdgeInsets.only(top: 200),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
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
                          // Tab Navigation
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Already on login page
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: theme.accent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.authLoginTab,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: theme.textPrimary,
                                        fontWeight: AppTypography.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: theme.divider,
                                          width: 1,
                                        ),
                                      ),
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
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.authEmailHint,
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: theme.textSecondary,
                              ),
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
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.authPasswordHint,
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: theme.textSecondary,
                              ),
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
                              return GestureDetector(
                                onTap: authProvider.isLoading
                                    ? null
                                    : _handleLogin,
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
                                    child: authProvider.isLoading
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
                                onTap: authProvider.isLoading
                                    ? null
                                    : _handleGoogleSignIn,
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
                                  child: Row(
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
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Terms and Privacy
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              l10n.authTerms,
                              style: AppTypography.bodySmall.copyWith(
                                color: theme.textSecondary,
                                fontSize: 11,
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
