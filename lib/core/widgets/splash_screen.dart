import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../constants/app_constants.dart';
import '../constants/banner_constants.dart';
import '../constants/overlay_constants.dart';
import '../constants/reward_constants.dart';
import '../navigation/main_navigation.dart';
import '../utils/coach_mark_helper.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Önce splash ekranı çizilsin, sonra precache başlasın 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) _navigateToHome();
      });
    });
  }

  _navigateToHome() async {
    // Record start time to ensure minimum 2 seconds
    final startTime = DateTime.now();

    // Ödüller görsellerini splash görünürken yükle; en az 2 sn bekle ile paralel
    await Future.wait([
      _precacheRewardsAssets(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait for auth state to be determined - listen to loading state changes
    if (authProvider.isLoading) {
      // If still loading, wait for auth state to be determined
      await _waitForAuthState();
    }

    if (!mounted) return;

    // If user is logged in, wait for profile (including premium status) to load
    if (authProvider.isLoggedIn) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.isProfileLoading) {
        await _waitForProfileLoad();
      }
    }

    if (!mounted) return;

    // Ensure minimum 2 seconds have passed
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed.inMilliseconds < 2000) {
      await Future.delayed(
        Duration(milliseconds: 2000 - elapsed.inMilliseconds),
      );
    }

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = CoachMarkHelper.kAlwaysShow
        ? false
        : (prefs.getBool('onboarding_completed') ?? false);

    if (!mounted) return;

    final Widget destination = onboardingCompleted
        ? const MainNavigation()
        : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  /// Tüm ödül görsellerini (avatar, banner, aksesuar) splash ekranında yükler.
  Future<void> _precacheRewardsAssets() async {
    const avatarSize = 128;
    const bannerW = 256;
    const bannerH = 160;
    final futures = <Future<void>>[];

    for (var i = 0; i < RewardConstants.defaultAvatarCount; i++) {
      futures.add(
        precacheImage(
          ResizeImage.resizeIfNeeded(
            avatarSize,
            avatarSize,
            AssetImage(AppConstants.avatarAssetPath(i)),
          ),
          context,
        ),
      );
    }
    for (var i = 0; i < RewardConstants.premiumAvatarCount; i++) {
      final id = RewardConstants.premiumAvatarStartId + i;
      futures.add(
        precacheImage(
          ResizeImage.resizeIfNeeded(
            avatarSize,
            avatarSize,
            AssetImage(AppConstants.avatarAssetPath(id)),
          ),
          context,
        ),
      );
    }
    for (var id = 1; id <= RewardConstants.rewardBannerCount; id++) {
      final path = BannerConstants.imagePath(id);
      if (path != null) {
        futures.add(
          precacheImage(
            ResizeImage.resizeIfNeeded(bannerW, bannerH, AssetImage(path)),
            context,
          ),
        );
      }
    }
    for (var id = 1; id <= OverlayConstants.accessoryCount; id++) {
      final path = OverlayConstants.overlayAssetPath(id);
      if (path != null) {
        futures.add(
          precacheImage(
            ResizeImage.resizeIfNeeded(
              avatarSize,
              avatarSize,
              AssetImage(path),
            ),
            context,
          ),
        );
      }
    }

    await Future.wait(futures);
  }

  Future<void> _waitForAuthState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait until auth state is determined (isLoading becomes false)
    int maxAttempts = 50; // 5 seconds max wait
    int attempts = 0;

    while (authProvider.isLoading && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
      if (!mounted) return;
    }

    // If still loading after max attempts, proceed anyway
    // This ensures the app doesn't get stuck
    if (authProvider.isLoading) {
      // Force stop loading after timeout
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _waitForProfileLoad() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    // Wait until profile (including premium status) is loaded
    int maxAttempts = 50; // 5 seconds max wait
    int attempts = 0;

    while (profileProvider.isProfileLoading && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
      if (!mounted) return;
    }

    // If still loading after max attempts, proceed anyway
    // This ensures the app doesn't get stuck
    if (profileProvider.isProfileLoading) {
      // Force stop loading after timeout
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Siyah ekran olmasın: arka plan rengi opak (splash görseli yüklenene kadar)
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          image: const DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/Start_Logo-Transparent.png',
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ),
    );
  }
}
