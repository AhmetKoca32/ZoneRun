import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_hero_section.dart';
import '../widgets/character_selection_section.dart';
import '../widgets/profile_edit_section.dart';
import '../../../store/presentation/pages/store_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

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
                // Back Button
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
                      ],
                    ),
                  ),
                ),

                // Hero Section
                ProfileHeroSection(
                  userName: provider.userName,
                  avatarIndex: provider.avatarIndex,
                  avatarUrl: provider.avatarUrl,
                  isProMember: provider.isProMember,
                  joinDate: provider.joinDate,
                ),

                const SizedBox(height: 24),

                // Character Selection Section
                CharacterSelectionSection(
                  selectedCharacterId: provider.selectedCharacterId,
                  onCharacterSelect: (characterId) {
                    provider.selectCharacter(characterId);
                  },
                  onCharacterChange: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StorePage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Profile Edit Section
                ProfileEditSection(
                  isProMember: provider.isProMember,
                  onNameEdit: () {
                    _showNameEditDialog(context, provider);
                  },
                  onAvatarEdit: () {
                    _showPhotoSelectionDialog(context, provider);
                  },
                  onUpgradeToPro: () {
                    provider.upgradeToPro();
                    // TODO: Navigate to Pro upgrade page
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

  void _showPhotoSelectionDialog(
      BuildContext context, ProfileProvider provider) {
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
            colors: [
              theme.surface,
              theme.surface.withOpacity(0.95),
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
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
              
              // Options
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
                        iconColor: Colors.red,
                        textColor: Colors.red,
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
          border: Border.all(
            color: theme.border,
            width: 1,
          ),
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
              child: Icon(
                icon,
                color: defaultIconColor,
                size: 24,
              ),
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
            Icon(
              Icons.arrow_forward_ios,
              color: theme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(
      BuildContext context, ProfileProvider provider, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        // For now, we'll use the file path
        // In production, you'd upload to a server and get a URL
        provider.updateAvatarUrl(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf seçilirken bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAvatarSelectionDialog(
      BuildContext context, ProfileProvider provider) {
    final theme = context.appTheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        title: Text(
          'Avatar Seç',
          style: AppTypography.titleMedium.copyWith(
            color: theme.textPrimary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 12, // 12 default avatars
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  provider.updateAvatar(index);
                  provider.updateAvatarUrl(null); // Clear photo URL when selecting avatar
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: provider.avatarIndex == index
                          ? theme.accent
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '👤',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'İptal',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNameEditDialog(
      BuildContext context, ProfileProvider provider) {
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
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
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
              
              // Title
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
              
              // Text Field
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
                    borderSide: BorderSide(
                      color: theme.border,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.border,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.accent,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
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
                          border: Border.all(
                            color: theme.border,
                            width: 1.5,
                          ),
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
}

