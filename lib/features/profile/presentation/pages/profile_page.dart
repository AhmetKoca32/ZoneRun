import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/coach_mark_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/reward_constants.dart';
import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/utils/auth_l10n.dart';
import '../helpers/task_l10n_helper.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_hero_section.dart';
import '../widgets/promo_credits_item.dart';
import '../widgets/quick_access_cards.dart';
import '../widgets/section_header.dart';
import '../widgets/settings_list_item.dart';
import 'share_preview_page.dart';
import 'help_page.dart';
import 'privacy_page.dart';
import 'about_page.dart';
import 'language_region_page.dart';
import 'rewards_page.dart';
import 'statistics_page.dart';
import 'tasks_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _prefKey = 'coach_mark_profile_completed';

  final _bannerKey = GlobalKey();
  final _shareKey = GlobalKey();
  final _quickAccessKey = GlobalKey();
  final _tasksKey = GlobalKey();
  final _rewardsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _precacheRewardsAvatars();
      _showCoachMarks();
      // Email doğrulandıysa banner'ın güncellenmesi için kullanıcıyı yenile
      context.read<AuthProvider>().reloadUser();
    });
  }

  Future<void> _showCoachMarks() async {
    try {
      if (!mounted) return;
      final shouldShow = await CoachMarkHelper.shouldShow(_prefKey);
      if (!shouldShow || !mounted) return;

      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      await CoachMarkHelper.show(
        context: context,
        prefKey: _prefKey,
        targets: [
          CoachMarkTarget(key: _bannerKey, text: l10n.coachProfileBanner),
          CoachMarkTarget(
            key: _shareKey,
            text: l10n.coachProfileShare,
            align: ContentAlign.bottom,
          ),
          CoachMarkTarget(key: _quickAccessKey, text: l10n.coachProfileQuickAccess),
          CoachMarkTarget(key: _tasksKey, text: l10n.coachProfileTasks),
          CoachMarkTarget(key: _rewardsKey, text: l10n.coachProfileRewards),
        ],
      );
    } catch (_) {
      // Widget deactivated during coach mark flow; safe to ignore.
    }
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

                // Profil banner (avatar + isim) — tıklanınca isim/avatar düzenleme; sağ üstte paylaş
                Builder(
                  builder: (context) {
                    final isLoggedIn =
                        Provider.of<AuthProvider>(context).isLoggedIn;
                    final displayName =
                        isLoggedIn ? provider.userName : AppLocalizations.of(context)!.guest;
                    return KeyedSubtree(
                      key: _bannerKey,
                      child: GestureDetector(
                        onTap: () => _showProfileEditOptions(context, provider),
                        child: ProfileHeroSection(
                          userName: displayName,
                          avatarIndex: provider.avatarIndex,
                          avatarUrl: provider.avatarUrl,
                          joinDate: isLoggedIn ? provider.joinDate : null,
                          selectedBannerId: provider.selectedBannerId,
                          selectedTitleLabel: provider.selectedTitleId != null
                              ? TaskL10nHelper.getTitleLabel(
                                  AppLocalizations.of(context)!,
                                  provider.selectedTitleId!,
                                )
                              : null,
                          selectedAccessoryIds: provider.selectedAccessoryIds,
                          shareKey: _shareKey,
                          onShareTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SharePreviewPage(
                                  userName: displayName,
                                  selectedBannerId: provider.selectedBannerId,
                                  selectedTitleLabel:
                                      provider.selectedTitleId != null
                                          ? TaskL10nHelper.getTitleLabel(
                                              AppLocalizations.of(context)!,
                                              provider.selectedTitleId!,
                                            )
                                          : null,
                                  avatarIndex: provider.avatarIndex,
                                  avatarUrl: provider.avatarUrl,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Email verification banner (below profile hero)
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    if (!authProvider.isLoggedIn || authProvider.isEmailVerified) {
                      return const SizedBox.shrink();
                    }
                    final l10n = AppLocalizations.of(context)!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange.shade700,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.profileEmailNotVerified,
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                await authProvider.reloadUser();
                                if (!context.mounted) return;
                                if (authProvider.isEmailVerified) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.profileEmailVerified),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                final sent = await authProvider.resendEmailVerification();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      sent
                                          ? l10n.profileEmailResendSuccess
                                          : l10n.profileEmailResendError,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l10n.profileEmailResend,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: Colors.orange.shade700,
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Quick Access Cards
                QuickAccessCards(
                  quickAccessKey: _quickAccessKey,
                  isDarkTheme: provider.isDarkTheme,
                  onHelpCenterTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HelpPage(),
                      ),
                    );
                  },
                  onStatisticsTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StatisticsPage(),
                      ),
                    );
                  },
                  onThemeTap: () {
                    provider.toggleTheme();
                  },
                ),

                // Başarılar & Ödüller Section
                SectionHeader(title: AppLocalizations.of(context)!.sectionAchievements),
                KeyedSubtree(
                  key: _tasksKey,
                  child: PromoCreditsItem(
                    icon: Icons.emoji_events,
                    title: AppLocalizations.of(context)!.tasks,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TasksPage(),
                        ),
                      );
                    },
                  ),
                ),
                KeyedSubtree(
                  key: _rewardsKey,
                  child: PromoCreditsItem(
                    icon: Icons.card_giftcard,
                    title: AppLocalizations.of(context)!.rewards,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RewardsPage(),
                        ),
                      );
                    },
                  ),
                ),

                // My Account Section
                SectionHeader(title: AppLocalizations.of(context)!.sectionMyAccount),
                SettingsListItem(
                  icon: Icons.lock_outline,
                  title: AppLocalizations.of(context)!.privacy,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPage(),
                      ),
                    );
                  },
                ),
                SettingsListItem(
                  icon: Icons.language_outlined,
                  title: AppLocalizations.of(context)!.language,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LanguageRegionPage(),
                      ),
                    );
                  },
                ),
                SettingsListItem(
                  icon: Icons.info_outline,
                  title: AppLocalizations.of(context)!.about,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  },
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    if (authProvider.isLoggedIn) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SettingsListItem(
                            icon: Icons.logout,
                            title: AppLocalizations.of(context)!.logout,
                            onTap: () {
                              _showLogoutConfirmation(context);
                            },
                          ),
                          SettingsListItem(
                            icon: Icons.delete_outline,
                            title: AppLocalizations.of(context)!.deleteAccount,
                            onTap: () {
                              _showDeleteAccountConfirmation(context);
                            },
                          ),
                        ],
                      );
                    }
                    final theme = context.appTheme;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.border.withOpacity(0.8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.textPrimary.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.profileLoginPrompt,
                              style: AppTypography.bodySmall.copyWith(
                                color: theme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.login_rounded, size: 20),
                                label: Text(AppLocalizations.of(context)!.loginOrSignUp),
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.accent,
                                  foregroundColor: theme.primaryBackground,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
                      AppLocalizations.of(context)!.profileEditTitle,
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
                  AppLocalizations.of(context)!.profileEditSubtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.textSecondary,
                    fontWeight: AppTypography.light,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                // Seçenek kartları (giriş yapmamışsa isim düzenleme gösterilmez)
                if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn) ...[
                  _buildProfileEditOptionCard(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    title: AppLocalizations.of(context)!.editName,
                    subtitle: AppLocalizations.of(context)!.editNameSubtitle,
                    onTap: () {
                      Navigator.of(context).pop();
                      _showNameEditDialog(context, provider);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                _buildProfileEditOptionCard(
                  context: context,
                  icon: Icons.face_rounded,
                  title: AppLocalizations.of(context)!.selectAvatar,
                  subtitle: AppLocalizations.of(context)!.selectAvatarSubtitle,
                  onTap: () {
                    Navigator.of(context).pop();
                    _showAvatarSelectionDialog(context, provider);
                  },
                ),
                const SizedBox(height: 12),
                _buildProfileEditOptionCard(
                  context: context,
                  icon: Icons.monitor_weight_outlined,
                  title: AppLocalizations.of(context)!.weightOptional,
                  subtitle: provider.weightKg != null
                      ? '${provider.weightKg!.toStringAsFixed(0)} kg · ${AppLocalizations.of(context)!.weightSubtitle}'
                      : AppLocalizations.of(context)!.weightSubtitle,
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
                AppLocalizations.of(context)!.weightOptional,
                style: AppTypography.headlineSmall.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.weightDialogHint,
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
                  hintText: AppLocalizations.of(context)!.weightHintExample,
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
                            AppLocalizations.of(context)!.cancel,
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
                            AppLocalizations.of(context)!.save,
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
                AppLocalizations.of(context)!.selectAvatar,
                style: AppTypography.headlineSmall.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.profileSelectAvatarDescription,
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
                AppLocalizations.of(context)!.profileTapAvatarToSelect,
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
                AppLocalizations.of(context)!.editName,
                style: AppTypography.headlineSmall.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.profileEnterNewName,
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
                  hintText: AppLocalizations.of(context)!.profileEnterNameHint,
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
                            AppLocalizations.of(context)!.cancel,
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
                            AppLocalizations.of(context)!.save,
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

  void _showLogoutConfirmation(BuildContext ctx) {
    final theme = ctx.appTheme;
    final l10n = AppLocalizations.of(ctx)!;
    final authProvider = Provider.of<AuthProvider>(ctx, listen: false);

    showDialog(
      context: ctx,
      barrierColor: theme.primaryBackground.withOpacity(0.85),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: theme.border.withOpacity(0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.textPrimary.withOpacity(0.15),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.accent.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 28,
                    color: theme.accent,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.logoutConfirmTitle,
                  style: AppTypography.headlineSmall.copyWith(
                    color: theme.textPrimary,
                    fontWeight: AppTypography.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.logoutConfirmMessage,
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.textSecondary,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.textSecondary,
                          side: BorderSide(
                            color: theme.border.withOpacity(0.8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await authProvider.signOut();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.accent,
                          foregroundColor: theme.primaryBackground,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(l10n.logout),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountConfirmation(BuildContext ctx) {
    final theme = ctx.appTheme;
    final l10n = AppLocalizations.of(ctx)!;
    final authProvider = Provider.of<AuthProvider>(ctx, listen: false);

    showDialog(
      context: ctx,
      barrierColor: theme.primaryBackground.withOpacity(0.85),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: theme.border.withOpacity(0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.textPrimary.withOpacity(0.15),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    size: 28,
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.deleteAccountConfirmTitle,
                  style: AppTypography.headlineSmall.copyWith(
                    color: theme.textPrimary,
                    fontWeight: AppTypography.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.deleteAccountConfirmMessage,
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.textSecondary,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.textSecondary,
                          side: BorderSide(
                            color: theme.border.withOpacity(0.8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          try {
                            await authProvider.deleteAccount();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.profileAccountDeleted,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: theme.textPrimary,
                                    ),
                                  ),
                                  backgroundColor: theme.secondaryBackground,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AuthL10n.messageFor(context, authProvider.errorCode) ??
                                        l10n.profileAccountDeleteError,
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
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(l10n.deleteAccountConfirmConfirm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
