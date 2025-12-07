import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'section_header.dart';

class CharacterSelectionSection extends StatefulWidget {
  final int? selectedCharacterId;
  final Function(int) onCharacterSelect;
  final VoidCallback onCharacterChange;

  const CharacterSelectionSection({
    super.key,
    this.selectedCharacterId,
    required this.onCharacterSelect,
    required this.onCharacterChange,
  });

  @override
  State<CharacterSelectionSection> createState() =>
      _CharacterSelectionSectionState();
}

class _CharacterSelectionSectionState extends State<CharacterSelectionSection> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _characterCount = 5; // Mock character count

  // Mock data: which characters are owned and which are premium
  final List<bool> _ownedCharacters = [true, true, false, false, true];
  final List<bool> _premiumCharacters = [false, true, true, true, false];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.selectedCharacterId ?? 0,
    );
    _currentPage = widget.selectedCharacterId ?? 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Karakter'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Carousel with Navigation
                Row(
                  children: [
                    // Left Arrow
                    GestureDetector(
                      onTap: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: _currentPage > 0
                              ? AppColors.white
                              : AppColors.whiteWithOpacity70,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Character Carousel
                    Expanded(
                      child: SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _characterCount,
                          itemBuilder: (context, index) {
                            final isPremium = _premiumCharacters[index];
                            final isOwned = _ownedCharacters[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: widget.selectedCharacterId == index
                                      ? AppColors.white
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Premium Badge (Positioned at top center)
                                  if (isPremium)
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFFD4AF37),
                                                const Color(0xFFB8941F),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: AppColors.black,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Premium',
                                                style: AppTypography.labelSmall
                                                    .copyWith(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          AppTypography.bold,
                                                      fontSize: 9,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Main Content - Centered
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Character Image
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Text(
                                                  '🎮',
                                                  style: TextStyle(
                                                    fontSize: 56,
                                                  ),
                                                ),
                                              ),
                                              if (!isOwned)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.lock,
                                                      color: AppColors.white,
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Karakter ${index + 1}',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.white,
                                                fontWeight:
                                                    AppTypography.semiBold,
                                                fontSize: 13,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Right Arrow
                    GestureDetector(
                      onTap: () {
                        if (_currentPage < _characterCount - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: _currentPage < _characterCount - 1
                              ? AppColors.white
                              : AppColors.whiteWithOpacity70,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Page Indicators (Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _characterCount,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.white
                            : AppColors.whiteWithOpacity70,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Owned Characters Collection
                Row(
                  children: [
                    Text(
                      'Sahip Olduklarım:',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.whiteWithOpacity70,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _characterCount,
                    itemBuilder: (context, index) {
                      final isOwned = _ownedCharacters[index];
                      final isPremium = _premiumCharacters[index];
                      final isSelected = widget.selectedCharacterId == index;

                      return GestureDetector(
                        onTap: isOwned
                            ? () {
                                widget.onCharacterSelect(index);
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isOwned
                                ? (isSelected
                                      ? AppColors.white
                                      : AppColors.lightGray)
                                : AppColors.mediumGray,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  '🎮',
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
                              if (!isOwned)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.lock,
                                      color: AppColors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              if (isPremium && isOwned)
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
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _ownedCharacters[_currentPage]
                            ? () {
                                widget.onCharacterSelect(_currentPage);
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _ownedCharacters[_currentPage]
                                ? (widget.selectedCharacterId == _currentPage
                                      ? AppColors.white
                                      : AppColors.black)
                                : AppColors.mediumGray,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _ownedCharacters[_currentPage]
                                  ? (widget.selectedCharacterId == _currentPage
                                        ? 'Seçili'
                                        : 'Seç')
                                  : 'Kilitli',
                              style: AppTypography.bodyMedium.copyWith(
                                color: _ownedCharacters[_currentPage]
                                    ? (widget.selectedCharacterId ==
                                              _currentPage
                                          ? AppColors.black
                                          : AppColors.white)
                                    : AppColors.whiteWithOpacity70,
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onCharacterChange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mağaza',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
