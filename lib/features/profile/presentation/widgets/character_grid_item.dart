import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/character_model.dart';

class CharacterGridItem extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback? onTap;
  final bool isPurchasing;

  const CharacterGridItem({
    super.key,
    required this.character,
    this.onTap,
    this.isPurchasing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    const goldColor = Color(0xFFD4AF37); // Pro badge color (theme-independent)

    return GestureDetector(
      onTap: isPurchasing ? null : onTap,
      child: Opacity(
        opacity: isPurchasing ? 0.6 : 1.0,
        child: Container(
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: character.isOwned ? theme.border : Colors.transparent,
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
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('🎮', style: TextStyle(fontSize: 48)),
                  ),
                ),
                if (!character.isOwned)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        color: theme.textPrimary,
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
                        color: goldColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star,
                        color: theme.primaryBackground,
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
                color: theme.textPrimary,
                fontWeight: AppTypography.semiBold,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Price or Owned or Loading
            if (isPurchasing)
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: goldColor,
                ),
              )
            else
              Text(
                character.isOwned
                    ? 'Sahip'
                    : '₺${character.price.toStringAsFixed(0)}',
                style: AppTypography.labelSmall.copyWith(
                  color: character.isOwned ? theme.textSecondary : goldColor,
                  fontWeight: AppTypography.medium,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
