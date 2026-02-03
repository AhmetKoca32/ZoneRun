import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/reward_constants.dart';
import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_hero_section.dart';
import '../widgets/promo_credits_item.dart';
import '../widgets/quick_access_cards.dart';
import '../widgets/section_header.dart';
import '../widgets/settings_list_item.dart';
import 'help_page.dart';
import 'rewards_page.dart';
import 'tasks_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _precacheRewardsAvatars();
    });
  }

  void _precacheRewardsAvatars() {
    const size = 128;
    final count = RewardConstants.defaultAvatarCount;
    for (var i = 0; i < count; i++) {
      final path = AppConstants.avatarAssetPath(i);
      precacheImage(
        ResizeImage.resizeIfNeeded(size, size, AssetImage(path)),
        context,
      );
    }
  }

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

                // Profil banner (avatar + isim) — tıklanınca isim/avatar düzenleme
                GestureDetector(
                  onTap: () => _showProfileEditOptions(context, provider),
                  child: ProfileHeroSection(
                    userName: provider.userName,
                    avatarIndex: provider.avatarIndex,
                    avatarUrl: provider.avatarUrl,
                    joinDate: provider.joinDate,
                    selectedBannerId: provider.selectedBannerId,
                    selectedTitleLabel: provider.selectedTitleId != null
                        ? RewardConstants.titleLabels[provider.selectedTitleId]
                        : null,
                    selectedAccessoryIds: provider.selectedAccessoryIds,
                  ),
                ),

                // Quick Access Cards
                QuickAccessCards(
                  isDarkTheme: provider.isDarkTheme,
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

                // Başarılar & Ödüller Section
                const SectionHeader(title: 'Başarılar & Ödüller'),
                PromoCreditsItem(
                  icon: Icons.emoji_events,
                  title: 'Görevler',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TasksPage(),
                      ),
                    );
                  },
                ),
                PromoCreditsItem(
                  icon: Icons.card_giftcard,
                  title: 'Ödüller',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RewardsPage(),
                      ),
                    );
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

  void _showProfileEditOptions(BuildContext context, ProfileProvider provider) {
    final theme = context.appTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.surface, theme.secondaryBackground.withOpacity(0.5)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: theme.textPrimary.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.textSecondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                // Başlık
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.accent.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: theme.accent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Profil Düzenle',
                      style: AppTypography.headlineSmall.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'İsim veya profil fotoğrafını güncelle',
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.textSecondary,
                    fontWeight: AppTypography.light,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                // Seçenek kartları
                _buildProfileEditOptionCard(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: 'İsim Düzenle',
                  subtitle: 'Görünen adınızı değiştirin',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showNameEditDialog(context, provider);
                  },
                ),
                const SizedBox(height: 12),
                _buildProfileEditOptionCard(
                  context: context,
                  icon: Icons.photo_camera_outlined,
                  title: 'Profil Fotoğrafı',
                  subtitle: 'Fotoğraf veya avatar seçin',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showPhotoSelectionSheet(context, provider);
                  },
                ),
                const SizedBox(height: 12),
                _buildProfileEditOptionCard(
                  context: context,
                  icon: Icons.monitor_weight_outlined,
                  title: 'Kilo (isteğe bağlı)',
                  subtitle: provider.weightKg != null
                      ? '${provider.weightKg!.toStringAsFixed(0)} kg · Kalori tahmini için'
                      : 'Kalori tahmini için kilo girin',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showWeightEditDialog(context, provider);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWeightEditDialog(BuildContext context, ProfileProvider provider) {
    final theme = context.appTheme;
    final textController = TextEditingController(
      text: provider.weightKg != null
          ? provider.weightKg!.toStringAsFixed(0)
          : '',
    );
    showDialog(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.surface,
                theme.surface.withOpacity(0.9),
                theme.secondaryBackground.withOpacity(0.3),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.textPrimary.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.monitor_weight_outlined,
                      color: theme.textPrimary,
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: theme.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Kilo (isteğe bağlı)',
                style: AppTypography.headlineSmall.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kalori tahmini için kg girin. Boş bırakırsanız varsayılan değer kullanılır.',
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textSecondary,
                  fontWeight: AppTypography.light,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: textController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: AppTypography.bodyLarge.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.medium,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Örn. 70',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: theme.textSecondary,
                  ),
                  suffixText: ' kg',
                  filled: true,
                  fillColor: theme.primaryBackground.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.border, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.accent, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.border, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            'İptal',
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textPrimary,
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
                      onTap: () {
                        final text = textController.text.trim();
                        if (text.isEmpty) {
                          provider.updateWeightKg(null);
                        } else {
                          final value = double.tryParse(
                            text.replaceAll(',', '.'),
                          );
                          if (value != null && value > 0 && value < 300) {
                            provider.updateWeightKg(value);
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.accent,
                              theme.accent.withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Kaydet',
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.primaryBackground,
                              fontWeight: AppTypography.bold,
                            ),
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
    );
  }

  Widget _buildProfileEditOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = context.appTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: theme.secondaryBackground.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.border.withOpacity(0.5), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.primaryBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: theme.accent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.semiBold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.textSecondary,
                        fontWeight: AppTypography.light,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: theme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoSelectionSheet(
    BuildContext context,
    ProfileProvider provider,
  ) {
    final theme = context.appTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.surface, theme.surface.withOpacity(0.95)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: theme.textPrimary.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.primaryBackground.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: theme.textPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profil Fotoğrafı Seç',
                            style: AppTypography.headlineSmall.copyWith(
                              color: theme.textPrimary,
                              fontWeight: AppTypography.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fotoğraf veya avatar seçin',
                            style: AppTypography.bodySmall.copyWith(
                              color: theme.textSecondary,
                              fontWeight: AppTypography.light,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildPhotoOptionCard(
                      context: context,
                      icon: Icons.photo_library,
                      title: 'Galeriden Seç',
                      subtitle: 'Fotoğraf galerinizden seçin',
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(context, provider, ImageSource.gallery);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPhotoOptionCard(
                      context: context,
                      icon: Icons.camera_alt,
                      title: 'Kamera ile Çek',
                      subtitle: 'Yeni fotoğraf çekin',
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(context, provider, ImageSource.camera);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPhotoOptionCard(
                      context: context,
                      icon: Icons.face,
                      title: 'Avatar Seç',
                      subtitle: 'Hazır avatar\'lardan seçin',
                      onTap: () {
                        Navigator.of(context).pop();
                        _showAvatarSelectionDialog(context, provider);
                      },
                    ),
                    if (provider.avatarUrl != null) ...[
                      const SizedBox(height: 12),
                      _buildPhotoOptionCard(
                        context: context,
                        icon: Icons.delete_outline,
                        title: 'Fotoğrafı Kaldır',
                        subtitle: 'Mevcut fotoğrafı sil',
                        iconColor: theme.textSecondary,
                        textColor: theme.textSecondary,
                        onTap: () {
                          provider.updateAvatarUrl(null);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final theme = context.appTheme;
    final defaultIconColor = iconColor ?? theme.textPrimary;
    final defaultTextColor = textColor ?? theme.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.primaryBackground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: defaultIconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: defaultTextColor,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.textSecondary,
                      fontWeight: AppTypography.light,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: theme.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    ProfileProvider provider,
    ImageSource source,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        provider.updateAvatarUrl(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        final theme = context.appTheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fotoğraf seçilirken bir hata oluştu: $e',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.textPrimary,
              ),
            ),
            backgroundColor: theme.secondaryBackground,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAvatarSelectionDialog(
    BuildContext context,
    ProfileProvider provider,
  ) {
    final theme = context.appTheme;
    showDialog(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.surface,
                theme.surface.withOpacity(0.95),
                theme.secondaryBackground.withOpacity(0.35),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.border.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: theme.textPrimary.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: icon + close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.face_rounded,
                      color: theme.textPrimary,
                      size: 26,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.border.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: theme.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Title & subtitle
              Text(
                'Avatar Seç',
                style: AppTypography.headlineSmall.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Profilinizde görünecek avatarı seçin',
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textSecondary,
                  fontWeight: AppTypography.light,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // Avatar grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1,
                ),
                itemCount: AppConstants.avatarCount,
                itemBuilder: (context, index) {
                  final isSelected = provider.avatarIndex == index;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        provider.updateAvatar(index);
                        provider.updateAvatarUrl(null);
                        Navigator.of(dialogContext).pop();
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: theme.accent.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            BoxShadow(
                              color: theme.textPrimary.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: isSelected
                                ? theme.accent
                                : theme.border.withOpacity(0.4),
                            width: isSelected ? 3 : 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                AppConstants.avatarAssetPath(index),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Text(
                                    '👤',
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  color: theme.accent.withOpacity(0.2),
                                  child: Center(
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: theme.accent,
                                      size: 32,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Bottom hint
              Text(
                'Seçmek için avatara dokunun',
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textSecondary.withOpacity(0.8),
                  fontWeight: AppTypography.light,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNameEditDialog(BuildContext context, ProfileProvider provider) {
    final theme = context.appTheme;
    final textController = TextEditingController(text: provider.userName);
    showDialog(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.surface,
                theme.surface.withOpacity(0.9),
                theme.secondaryBackground.withOpacity(0.3),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.textPrimary.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: theme.textPrimary,
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: theme.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'İsim Düzenle',
                style: AppTypography.headlineSmall.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Yeni isminizi girin',
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textSecondary,
                  fontWeight: AppTypography.light,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: textController,
                autofocus: true,
                style: AppTypography.bodyLarge.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.medium,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'İsminizi girin',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: theme.textSecondary,
                  ),
                  filled: true,
                  fillColor: theme.primaryBackground.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.border, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.accent, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.border, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            'İptal',
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textPrimary,
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
                      onTap: () {
                        if (textController.text.trim().isNotEmpty) {
                          provider.updateUserName(textController.text.trim());
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.accent,
                              theme.accent.withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Kaydet',
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.primaryBackground,
                              fontWeight: AppTypography.bold,
                            ),
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
                  color: theme.textPrimary,
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
