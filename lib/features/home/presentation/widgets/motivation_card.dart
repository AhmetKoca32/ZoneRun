import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/services/motivation_quote_service.dart';

class MotivationCard extends StatelessWidget {
  const MotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final quote = MotivationQuoteService.getDailyQuote();

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
              AppColors.white.withOpacity(0.15),
              AppColors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.white.withOpacity(0.2),
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
                      color: AppColors.white,
                      fontWeight: AppTypography.regular,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '— ${quote.author}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.7),
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
              color: AppColors.white.withOpacity(0.3),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

