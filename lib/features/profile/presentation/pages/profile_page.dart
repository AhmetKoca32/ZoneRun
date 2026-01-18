import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/promo_banner.dart';
import '../widgets/promo_credits_item.dart';
import '../widgets/quick_access_cards.dart';
import '../widgets/section_header.dart';
import '../widgets/settings_list_item.dart';
import 'user_profile_page.dart';
import 'help_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.textPrimary),
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
                              color: theme.secondaryBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: theme.textPrimary,
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
                          color: theme.textSecondary,
                          fontWeight: AppTypography.light,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.userName,
                        style: AppTypography.headlineMedium.copyWith(
                          color: theme.textPrimary,
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
                    _showLogoutConfirmation(context);
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

  void _showLogoutConfirmation(BuildContext context) {
    final theme = context.appTheme;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: theme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Çıkış Yap',
            style: AppTypography.headlineSmall.copyWith(
              color: theme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
          content: Text(
            'Hesabınızdan çıkmak istediğinize emin misiniz?',
            style: AppTypography.bodyMedium.copyWith(
              color: theme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'İptal',
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signOut();
                
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: Text(
                'Çıkış Yap',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.red,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
