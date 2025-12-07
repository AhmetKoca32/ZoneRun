import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/profile_provider.dart';
import '../widgets/promo_banner.dart';
import '../widgets/promo_credits_item.dart';
import '../widgets/quick_access_cards.dart';
import '../widgets/section_header.dart';
import '../widgets/settings_list_item.dart';
import 'user_profile_page.dart';
import '../../../help/presentation/pages/help_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Button and Header
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
                              Icons.close,
                              color: AppColors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // User Greeting
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merhaba',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.whiteWithOpacity70,
                          fontWeight: AppTypography.light,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.userName,
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: AppTypography.extraBold,
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Access Cards
                QuickAccessCards(
                  isDarkTheme: provider.isDarkTheme,
                  onUserProfileTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserProfilePage(),
                      ),
                    );
                  },
                  onHelpCenterTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HelpPage(),
                      ),
                    );
                  },
                  onStatisticsTap: () {
                    // Navigate to statistics
                  },
                  onThemeTap: () {
                    provider.toggleTheme();
                  },
                ),

                // Promo Banner
                PromoBanner(
                  onJoinProTap: () {
                    // Navigate to join pro
                  },
                  onSaveNowTap: () {
                    // Show save now dialog
                  },
                ),

                // Promos & Credits Section
                const SectionHeader(title: 'Promosyonlar & Krediler'),
                PromoCreditsItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Krediler',
                  value: '₺0.00',
                  onTap: () {
                    // Navigate to credits
                  },
                ),
                PromoCreditsItem(
                  icon: Icons.local_offer_outlined,
                  title: 'Kuponlar',
                  onTap: () {
                    // Navigate to coupons
                  },
                ),
                PromoCreditsItem(
                  icon: Icons.emoji_events,
                  title: 'Başarılar',
                  onTap: () {
                    // Navigate to achievements
                  },
                ),
                PromoCreditsItem(
                  icon: Icons.card_giftcard,
                  title: 'Ödüller',
                  onTap: () {
                    // Navigate to rewards
                  },
                ),

                // My Account Section
                const SectionHeader(title: 'Hesabım'),
                SettingsListItem(
                  icon: Icons.notifications_outlined,
                  title: 'Bildirimler',
                  onTap: () {
                    // Navigate to notifications settings
                  },
                ),
                SettingsListItem(
                  icon: Icons.lock_outline,
                  title: 'Gizlilik',
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
                SettingsListItem(
                  icon: Icons.language_outlined,
                  title: 'Dil ve Bölge',
                  onTap: () {
                    // Navigate to language settings
                  },
                ),
                SettingsListItem(
                  icon: Icons.info_outline,
                  title: 'Hakkında',
                  onTap: () {
                    // Navigate to about page
                  },
                ),
                SettingsListItem(
                  icon: Icons.logout,
                  title: 'Çıkış Yap',
                  onTap: () {
                    // Show logout confirmation
                  },
                ),
                SettingsListItem(
                  icon: Icons.delete_outline,
                  title: 'Hesabı Sil',
                  onTap: () {
                    // Show delete account confirmation
                  },
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
