import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/character_model.dart';

class FeaturedCharacterCard extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback? onPurchase;

  const FeaturedCharacterCard({
    super.key,
    required this.character,
    this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mediumGray,
            AppColors.mediumGray.withOpacity(0.8),
            AppColors.lightGray.withOpacity(0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Character Image
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '🎮',
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Character Name
          Text(
            character.name,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.white,
              fontWeight: AppTypography.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          
          // Price
          Text(
            character.isOwned
                ? 'Sahip Olundu'
                : '₺${character.price.toStringAsFixed(0)}',
            style: AppTypography.titleMedium.copyWith(
              color: character.isOwned
                  ? AppColors.whiteWithOpacity70
                  : const Color(0xFFD4AF37),
              fontWeight: AppTypography.semiBold,
              fontSize: 18,
            ),
          ),
          if (character.description != null) ...[
            const SizedBox(height: 8),
            Text(
              character.description!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.whiteWithOpacity70,
                fontWeight: AppTypography.light,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          
          // Purchase Button
          if (!character.isOwned)
            GestureDetector(
              onTap: onPurchase,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD4AF37),
                      const Color(0xFFB8941F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Satın Al',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.black,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Sahip Olundu',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

