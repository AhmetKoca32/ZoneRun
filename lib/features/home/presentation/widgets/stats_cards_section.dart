import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/navigation/main_navigation.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/home_provider.dart';

class StatsCardsSection extends StatelessWidget {
  final GlobalKey? startButtonKey;

  const StatsCardsSection({super.key, this.startButtonKey});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ElevatedButton(
            key: startButtonKey,
            onPressed: () {
              // Navigate to map page (index 1)
              final mainNav = MainNavigationInherited.of(context);
              if (mainNav != null) {
                mainNav.switchToTab(1); // Switch to map page
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.accent,
              foregroundColor: theme.primaryBackground,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.startButton,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: AppTypography.bold,
                    color: theme.primaryBackground,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: theme.primaryBackground, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
