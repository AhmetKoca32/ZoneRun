import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/store_provider.dart';
import '../widgets/featured_character_card.dart';
import '../widgets/character_grid_item.dart';
import '../../../profile/presentation/widgets/section_header.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Consumer<StoreProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.white),
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
                              color: AppColors.lightGray,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Mağaza',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.white,
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
                            color: AppColors.white,
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

