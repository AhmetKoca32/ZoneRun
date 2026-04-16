import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

class QuickAccessCards extends StatelessWidget {
  final VoidCallback? onHelpCenterTap;
  final VoidCallback? onStatisticsTap;
  final VoidCallback? onThemeTap;
  final bool isDarkTheme;
  final GlobalKey? quickAccessKey;

  const QuickAccessCards({
    super.key,
    this.onHelpCenterTap,
    this.onStatisticsTap,
    this.onThemeTap,
    required this.isDarkTheme,
    this.quickAccessKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return Container(
      key: quickAccessKey,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickAccessItem(
            icon: Icons.headset_mic_outlined,
            label: AppLocalizations.of(context)!.quickAccessHelp,
            onTap: onHelpCenterTap,
          ),
          _QuickAccessItem(
            icon: Icons.analytics_outlined,
            label: AppLocalizations.of(context)!.quickAccessStatistics,
            onTap: onStatisticsTap,
          ),
          _ThemeItem(isDarkTheme: isDarkTheme, onTap: onThemeTap),
        ],
      ),
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickAccessItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.textPrimary, size: 24),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: theme.textPrimary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeItem extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback? onTap;

  const _ThemeItem({required this.isDarkTheme, this.onTap});

  @override
  State<_ThemeItem> createState() => _ThemeItemState();
}

class _ThemeItemState extends State<_ThemeItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _handleTap() {
    _animationController.forward(from: 0.0).then((_) {
      _animationController.reverse();
      widget.onTap?.call();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                color: theme.textPrimary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: SizedBox(
              key: ValueKey(widget.isDarkTheme),
              width: 70,
              child: Text(
                widget.isDarkTheme
                    ? AppLocalizations.of(context)!.quickAccessThemeDark
                    : AppLocalizations.of(context)!.quickAccessThemeLight,
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textPrimary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
