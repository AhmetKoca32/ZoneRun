import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/services/motivation_quote_service.dart';

class MotivationCard extends StatelessWidget {
  const MotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final localeCode = AppLocalizations.of(context)?.localeName ?? 'tr';
    final quote = MotivationQuoteService.getDailyQuote(localeCode: localeCode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.textPrimary.withOpacity(0.15),
              theme.textPrimary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    quote.quote,
                    style: AppTypography.bodyMedium.copyWith(
                      color: theme.textPrimary,
                      fontWeight: AppTypography.regular,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '— ${quote.author}',
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.textSecondary,
                      fontWeight: AppTypography.light,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.format_quote,
              color: theme.textTertiary,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

