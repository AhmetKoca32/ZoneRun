import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/store_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/featured_character_card.dart';
import '../widgets/character_grid_item.dart';
import '../widgets/section_header.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  Future<void> _showCharacterPreview(
    BuildContext context,
    StoreProvider storeProvider,
    int characterId,
  ) async {
    final character = storeProvider.characters.firstWhere((char) => char.id == characterId);
    final theme = context.appTheme;
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final isSelected = profileProvider.selectedCharacterId == characterId;

    // Show preview dialog
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Character Image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text('🎮', style: TextStyle(fontSize: 64)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Character Name
              Text(
                character.name,
                style: AppTypography.titleLarge.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Price or Status
              Text(
                character.isOwned
                    ? (isSelected ? 'Seçili' : 'Sahip Olundu')
                    : '₺${character.price.toStringAsFixed(0)}',
                style: AppTypography.titleMedium.copyWith(
                  color: character.isOwned 
                      ? (isSelected ? theme.accent : theme.textSecondary)
                      : const Color(0xFFD4AF37),
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              if (character.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  character.description!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'İptal',
                        style: AppTypography.bodyMedium.copyWith(
                          color: theme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  if (character.isOwned) ...[
                    // Owned character - Show "Seç" button
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSelected
                            ? null
                            : () {
                                profileProvider.selectCharacter(characterId);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${character.name} seçildi',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: theme.primaryBackground,
                                      ),
                                    ),
                                    backgroundColor: theme.accent,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? theme.secondaryBackground
                              : theme.accent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isSelected ? 'Seçili' : 'Seç',
                          style: AppTypography.bodyMedium.copyWith(
                            color: isSelected
                                ? theme.textSecondary
                                : theme.primaryBackground,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Not owned - Show "Satın Al" button
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _handlePurchase(context, storeProvider, characterId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Satın Al',
                          style: AppTypography.bodyMedium.copyWith(
                            color: theme.primaryBackground,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePurchase(
    BuildContext context,
    StoreProvider provider,
    int characterId,
  ) async {
    final character = provider.characters.firstWhere((char) => char.id == characterId);
    final theme = context.appTheme;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        title: Text(
          'Satın Al',
          style: AppTypography.titleLarge.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.bold,
          ),
        ),
        content: Text(
          '${character.name} karakterini ${character.price == 0 ? "ücretsiz olarak" : "₺${character.price.toStringAsFixed(0)} karşılığında"} satın almak istediğinize emin misiniz?',
          style: AppTypography.bodyMedium.copyWith(
            color: theme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'İptal',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Satın Al',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.accent,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: theme.surface,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: theme.accent),
              const SizedBox(height: 16),
              Text(
                'Satın alma işleniyor...',
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Perform purchase
    final success = await provider.purchaseCharacter(characterId);

    // Hide loading
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Show result
    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${character.name} başarıyla satın alındı!',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.primaryBackground,
              ),
            ),
            backgroundColor: theme.accent,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        final error = provider.purchaseError ?? 'Satın alma başarısız';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.surface,
            title: Text(
              'Hata',
              style: AppTypography.titleLarge.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.bold,
              ),
            ),
            content: Text(
              error,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  provider.clearPurchaseError();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Tamam',
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.accent,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Consumer<StoreProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.textPrimary),
            );
          }

          final featuredCharacter = provider.featuredCharacter;
          final allCharacters = provider.characters;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button and Header
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: theme.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Mağaza',
                          style: AppTypography.headlineSmall.copyWith(
                            color: theme.textPrimary,
                            fontWeight: AppTypography.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Featured Character Section
                if (featuredCharacter != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFD4AF37),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Öne Çıkan',
                          style: AppTypography.titleMedium.copyWith(
                            color: theme.textPrimary,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FeaturedCharacterCard(
                    character: featuredCharacter,
                    isPurchasing: provider.isPurchasing && 
                        provider.purchasingCharacterId == featuredCharacter.id,
                    onPurchase: featuredCharacter.isOwned
                        ? null
                        : () async {
                            await _showCharacterPreview(context, provider, featuredCharacter.id);
                          },
                    onTap: featuredCharacter.isOwned
                        ? () async {
                            await _showCharacterPreview(context, provider, featuredCharacter.id);
                          }
                        : null,
                  ),
                ],

                // All Characters Section
                const SectionHeader(title: 'Tüm Karakterler'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: allCharacters.length,
                    itemBuilder: (context, index) {
                      final character = allCharacters[index];
                      return CharacterGridItem(
                        character: character,
                        isPurchasing: provider.isPurchasing && 
                            provider.purchasingCharacterId == character.id,
                        onTap: () async {
                          await _showCharacterPreview(context, provider, character.id);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
