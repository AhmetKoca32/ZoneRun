import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/character_model.dart';

class CharacterGridItem extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback? onTap;

  const CharacterGridItem({
    super.key,
    required this.character,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mediumGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: character.isOwned
                ? AppColors.white.withOpacity(0.3)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character Image
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '🎮',
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                if (!character.isOwned)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                if (character.isPremium && character.isOwned)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star,
                        color: AppColors.black,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Character Name
            Text(
              character.name,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.white,
                fontWeight: AppTypography.semiBold,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            
            // Price or Owned
            Text(
              character.isOwned
                  ? 'Sahip'
                  : '₺${character.price.toStringAsFixed(0)}',
              style: AppTypography.labelSmall.copyWith(
                color: character.isOwned
                    ? AppColors.whiteWithOpacity70
                    : const Color(0xFFD4AF37),
                fontWeight: AppTypography.medium,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

