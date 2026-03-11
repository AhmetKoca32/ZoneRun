import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

/// Uygulama hakkında: tanıtım, sürüm ve bağlantılar.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String appVersion = '1.0.0';
  static const String _websiteBaseUrl = 'https://zone-run.vercel.app';

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: theme.textPrimary,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.about,
                    style: AppTypography.headlineSmall.copyWith(
                      color: theme.textPrimary,
                      fontWeight: AppTypography.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: theme.surface,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                            color: theme.border.withOpacity(0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Image.asset(
                            'assets/icons/Main_Logo.jpg',
                            fit: BoxFit.cover,
                            width: 96,
                            height: 96,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'ZoneRun',
                        style: AppTypography.headlineMedium.copyWith(
                          color: theme.textPrimary,
                          fontWeight: AppTypography.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.aboutTagline,
                        style: AppTypography.bodyLarge.copyWith(
                          color: theme.textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.versionFormat(appVersion),
                          style: AppTypography.labelLarge.copyWith(
                            color: theme.accent,
                            fontWeight: AppTypography.semiBold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.aboutDescription,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _LinkTile(
                      theme: theme,
                      icon: Icons.privacy_tip_outlined,
                      title: AppLocalizations.of(context)!.privacyPolicy,
                      onTap: () {
                        final locale = Localizations.localeOf(context).languageCode;
                        final path = locale == 'tr' ? '/gizlilik/' : '/privacy/';
                        _launchUrl(context, '$_websiteBaseUrl$path');
                      },
                    ),
                    const SizedBox(height: 12),
                    _LinkTile(
                      theme: theme,
                      icon: Icons.description_outlined,
                      title: AppLocalizations.of(context)!.termsOfUse,
                      onTap: () {
                        final locale = Localizations.localeOf(context).languageCode;
                        final path = locale == 'tr' ? '/kullanim-kosullari/' : '/terms/';
                        _launchUrl(context, '$_websiteBaseUrl$path');
                      },
                    ),
                    const SizedBox(height: 12),
                    _LinkTile(
                      theme: theme,
                      icon: Icons.language_outlined,
                      title: AppLocalizations.of(context)!.website,
                      onTap: () => _launchUrl(context, _websiteBaseUrl),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.linkOpenFailed),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.theme,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final dynamic theme;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: theme.accent, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    color: theme.textPrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: theme.textTertiary,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
