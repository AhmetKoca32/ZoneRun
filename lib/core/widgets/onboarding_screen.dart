import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../l10n/app_localizations.dart';
import '../extensions/theme_extension_helper.dart';
import '../navigation/main_navigation.dart';
import '../theme/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      _OnboardingPage(
        icon: Icons.explore_outlined,
        title: l10n.onboardingWelcomeTitle,
        description: l10n.onboardingWelcomeDescription,
        showLogo: true,
      ),
      _OnboardingPage(
        icon: Icons.map_outlined,
        title: l10n.onboardingMapTitle,
        description: l10n.onboardingMapDescription,
      ),
      _OnboardingPage(
        icon: Icons.emoji_events_outlined,
        title: l10n.onboardingTasksTitle,
        description: l10n.onboardingTasksDescription,
      ),
      _OnboardingPage(
        icon: Icons.bar_chart_outlined,
        title: l10n.onboardingStatsTitle,
        description: l10n.onboardingStatsDescription,
      ),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 20),
                  child: _isLastPage
                      ? const SizedBox(height: 48)
                      : TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            l10n.onboardingSkip,
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textSecondary,
                              fontWeight: AppTypography.medium,
                            ),
                          ),
                        ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _isLastPage = index == pages.length - 1;
                    });
                  },
                  itemBuilder: (_, index) => pages[index],
                ),
              ),

              // Bottom section: indicator + button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: pages.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 12,
                        activeDotColor: theme.textPrimary,
                        dotColor: theme.textTertiary.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isLastPage) {
                            _completeOnboarding();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.accent,
                          foregroundColor: theme.primaryBackground,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _isLastPage
                              ? l10n.onboardingGetStarted
                              : l10n.onboardingNext,
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: AppTypography.bold,
                            color: theme.primaryBackground,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool showLogo;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showLogo) ...[
            Image.asset(
              'assets/icons/zonerun-high-resolution-logo-transparent.png',
              height: 40,
              fit: BoxFit.contain,
              color: theme.textPrimary,
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(height: 48),
          ],
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.accent.withOpacity(0.1),
              border: Border.all(
                color: theme.border,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: 48,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.displaySmall.copyWith(
              color: theme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: theme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
