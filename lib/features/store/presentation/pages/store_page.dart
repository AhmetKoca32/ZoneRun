import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/store_provider.dart';
import '../widgets/featured_character_card.dart';
import '../widgets/character_grid_item.dart';
import '../../../profile/presentation/widgets/section_header.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

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
                    onPurchase: () {
                      provider.purchaseCharacter(featuredCharacter.id);
                    },
                  ),
                ],

                // All Characters Section
                const SectionHeader(title: 'Tüm Karakterler'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onTap: () {
                          // Show character details or purchase
                          if (!character.isOwned) {
                            provider.purchaseCharacter(character.id);
                          }
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

