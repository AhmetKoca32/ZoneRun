import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback? onJoinProTap;
  final VoidCallback? onSaveNowTap;

  const PromoBanner({super.key, this.onJoinProTap, this.onSaveNowTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    const goldColor = Color(0xFFD4AF37); // Pro badge color (theme-independent)
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.surface, theme.secondaryBackground],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.medium,
                      ),
                      children: [
                        const TextSpan(text: 'Sınırsız '),
                        TextSpan(
                          text: 'ÜCRETSİZ ',
                          style: TextStyle(
                            fontWeight: AppTypography.bold,
                            color: goldColor,
                          ),
                        ),
                        const TextSpan(
                          text: 'karakter seçimi ve daha fazlası için ! ',
                        ),
                        TextSpan(
                          text: 'Pro\'ya Katıl',
                          style: TextStyle(fontWeight: AppTypography.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.emoji_events,
                  color: goldColor,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onSaveNowTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: goldColor, width: 1.5),
              ),
              child: Text(
                'Şimdi Katıl',
                style: AppTypography.bodySmall.copyWith(
                  color: goldColor,
                  fontWeight: AppTypography.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
