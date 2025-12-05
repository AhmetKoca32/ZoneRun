import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback? onJoinProTap;
  final VoidCallback? onSaveNowTap;

  const PromoBanner({super.key, this.onJoinProTap, this.onSaveNowTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.mediumGray,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.mediumGray, AppColors.darkGray],
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
                        color: AppColors.white,
                        fontWeight: AppTypography.medium,
                      ),
                      children: [
                        const TextSpan(text: 'Sınırsız '),
                        TextSpan(
                          text: 'ÜCRETSİZ ',
                          style: TextStyle(
                            fontWeight: AppTypography.bold,
                            color: const Color(0xFFD4AF37),
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
                  color: const Color(0xFFD4AF37),
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
                color: AppColors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              ),
              child: Text(
                'Şimdi Katıl',
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFFD4AF37),
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
