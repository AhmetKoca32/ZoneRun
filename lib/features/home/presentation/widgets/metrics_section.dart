import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/home_provider.dart';

class MetricsSection extends StatefulWidget {
  const MetricsSection({super.key});

  @override
  State<MetricsSection> createState() => _MetricsSectionState();
}

class _MetricsSectionState extends State<MetricsSection> {
  void _onSeeStatsPressed() {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    provider.toggleStats();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final stats = provider.stats ?? {};
        final totalArea = (stats['totalArea'] as num?)?.toDouble() ?? 0.0;
        final todayDistance =
            (stats['todayDistance'] as num?)?.toDouble() ?? 0.0;
        final totalDistance =
            (stats['totalDistance'] as num?)?.toDouble() ?? 0.0;
        final averageArea = (stats['averageArea'] as num?)?.toDouble() ?? 0.0;
        final totalCalories = (stats['totalCalories'] as int?) ?? 0;
        final todayCalories = (stats['todayCalories'] as int?) ?? 0;
        final streak = (stats['streak'] as int?) ?? 0;
        final maxArea = (stats['maxArea'] as num?)?.toDouble() ?? 0.0;
        final maxStreak = (stats['maxStreak'] as int?) ?? 0;

        final showStats = provider.showStats;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _LeftMetricCard(
                      value: totalArea,
                      formatter: provider.formatArea,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _CenterMetricCircle(
                    value: todayDistance,
                    formatter: provider.formatDistance,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RightMetricCard(
                      value: totalDistance,
                      formatter: provider.formatDistance,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _AnimatedSeeStatsButton(
              showStats: showStats,
              onTap: _onSeeStatsPressed,
            ),
            _AnimatedStatsCards(
              showStats: showStats,
              averageArea: averageArea,
              totalCalories: totalCalories,
              todayCalories: todayCalories,
              streak: streak,
              maxArea: maxArea,
              maxStreak: maxStreak,
              formatArea: provider.formatArea,
              formatCalories: provider.formatCalories,
              formatStreak: provider.formatStreak,
            ),
          ],
        );
      },
    );
  }
}

// Animated Value Widget (for number only, without unit)
class _AnimatedValue extends StatefulWidget {
  final double targetValue;
  final String Function(double) formatter;
  final TextStyle textStyle;

  const _AnimatedValue({
    required this.targetValue,
    required this.formatter,
    required this.textStyle,
  });

  @override
  State<_AnimatedValue> createState() => _AnimatedValueState();
}

class _AnimatedValueState extends State<_AnimatedValue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _displayValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.targetValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addListener(() {
      setState(() {
        _displayValue = _animation.value;
      });
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue) {
      _animation = Tween<double>(
        begin: _displayValue,
        end: widget.targetValue,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedValue = widget.formatter(_displayValue);
    final parts = formattedValue.split(' ');
    final number = parts[0];

    return Text(number, style: widget.textStyle);
  }
}

// Left Metric Card (CONQUERED)
class _LeftMetricCard extends StatelessWidget {
  final double value;
  final String Function(double) formatter;

  const _LeftMetricCard({required this.value, required this.formatter});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final formatted = formatter(value);
    final parts = formatted.split(' ');
    final unit = parts.length > 1 ? parts[1] : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Value (largest) - Animated
        _AnimatedValue(
          targetValue: value,
          formatter: formatter,
          textStyle: AppTypography.displaySmall.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.light,
            fontSize: 27,
          ),
        ),
        const SizedBox(height: 2),
        // Unit (medium)
        Text(
          unit,
          style: AppTypography.bodyMedium.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.light,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        // Label (smallest)
        Text(
          'FETHEDİLEN',
          style: AppTypography.labelSmall.copyWith(
            color: theme.textSecondary,
            fontWeight: AppTypography.light,
            letterSpacing: 1.0,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// Center Metric Circle (TODAY)
class _CenterMetricCircle extends StatelessWidget {
  final double value;
  final String Function(double) formatter;

  const _CenterMetricCircle({required this.value, required this.formatter});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final formatted = formatter(value);
    final parts = formatted.split(' ');
    final unit = parts.length > 1 ? parts[1] : '';

    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: theme.circleGradient,
        border: Border.all(color: theme.border, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Value (largest, very large) - Animated
            _AnimatedValue(
              targetValue: value,
              formatter: formatter,
              textStyle: AppTypography.displayLarge.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.light,
                fontSize: 48,
              ),
            ),
            const SizedBox(height: 4),
            // Unit (medium)
            Text(
              unit,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.light,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            // Label (smallest)
            Text(
              'BUGÜN',
              style: AppTypography.labelSmall.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.light,
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Right Metric Card (TOTAL)
class _RightMetricCard extends StatelessWidget {
  final double value;
  final String Function(double) formatter;

  const _RightMetricCard({required this.value, required this.formatter});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final formatted = formatter(value);
    final parts = formatted.split(' ');
    final unit = parts.length > 1 ? parts[1] : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Value (largest) - Animated
        _AnimatedValue(
          targetValue: value,
          formatter: formatter,
          textStyle: AppTypography.displaySmall.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.light,
            fontSize: 27,
          ),
        ),
        const SizedBox(height: 2),
        // Unit (medium)
        Text(
          unit,
          style: AppTypography.bodyMedium.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.light,
            fontSize: 15,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 2),
        // Label (smallest)
        Text(
          'TOPLAM',
          style: AppTypography.labelSmall.copyWith(
            color: theme.textSecondary,
            fontWeight: AppTypography.light,
            letterSpacing: 1.0,
            fontSize: 11,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

// Animated SEE STATS Button
class _AnimatedSeeStatsButton extends StatefulWidget {
  final bool showStats;
  final VoidCallback onTap;

  const _AnimatedSeeStatsButton({required this.showStats, required this.onTap});

  @override
  State<_AnimatedSeeStatsButton> createState() =>
      _AnimatedSeeStatsButtonState();
}

class _AnimatedSeeStatsButtonState extends State<_AnimatedSeeStatsButton> {
  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'İSTATİSTİKLER',
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              turns: widget.showStats
                  ? 0.5
                  : 0.0, // Up arrow when open (180°), down when closed
              child: Icon(
                Icons.keyboard_arrow_down,
                color: theme.textPrimary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Stats Cards
class _AnimatedStatsCards extends StatefulWidget {
  final bool showStats;
  final double averageArea;
  final int totalCalories;
  final int todayCalories;
  final int streak;
  final double maxArea;
  final int maxStreak;
  final String Function(double) formatArea;
  final String Function(int) formatCalories;
  final String Function(int) formatStreak;

  const _AnimatedStatsCards({
    required this.showStats,
    required this.averageArea,
    required this.totalCalories,
    required this.todayCalories,
    required this.streak,
    required this.maxArea,
    required this.maxStreak,
    required this.formatArea,
    required this.formatCalories,
    required this.formatStreak,
  });

  @override
  State<_AnimatedStatsCards> createState() => _AnimatedStatsCardsState();
}

class _AnimatedStatsCardsState extends State<_AnimatedStatsCards>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    if (widget.showStats) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(_AnimatedStatsCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showStats && !oldWidget.showStats) {
      _animationController.forward();
    } else if (!widget.showStats && oldWidget.showStats) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      axisAlignment: -1.0, // Align to top
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Ortalama Alan',
                    value: widget.formatArea(widget.averageArea),
                    icon: Icons.landscape_outlined,
                    badgeLabel: 'En Büyük Alan',
                    badgeValue: widget.formatArea(widget.maxArea),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CalorieStatCard(
                    todayCalories: widget.todayCalories,
                    totalCalories: widget.totalCalories,
                    formatCalories: widget.formatCalories,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    title: 'Seri',
                    value: widget.formatStreak(widget.streak),
                    icon: Icons.trending_up,
                    badgeLabel: 'En Yüksek Seri',
                    badgeValue: widget.formatStreak(widget.maxStreak),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? badgeLabel;
  final String? badgeValue;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.badgeLabel,
    this.badgeValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.textTertiary, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    color: theme.textSecondary,
                    fontWeight: AppTypography.medium,
                    letterSpacing: 0.5,
                    fontSize: 9,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: theme.textPrimary,
              fontWeight: AppTypography.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (badgeLabel != null && badgeValue != null) ...[
            const SizedBox(height: 6),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: theme.textTertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$badgeLabel: ',
                      style: AppTypography.labelSmall.copyWith(
                        color: theme.textSecondary,
                        fontWeight: AppTypography.medium,
                        fontSize: 9,
                      ),
                    ),
                    TextSpan(
                      text: badgeValue,
                      style: AppTypography.labelSmall.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.semiBold,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            const SizedBox(height: 6),
        ],
      ),
    );
  }
}

// Calorie Stat Card Widget (shows today and total calories)
class _CalorieStatCard extends StatelessWidget {
  final int todayCalories;
  final int totalCalories;
  final String Function(int) formatCalories;

  const _CalorieStatCard({
    required this.todayCalories,
    required this.totalCalories,
    required this.formatCalories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: theme.textTertiary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Kalori',
                  style: AppTypography.labelSmall.copyWith(
                    color: theme.textSecondary,
                    fontWeight: AppTypography.medium,
                    letterSpacing: 0.5,
                    fontSize: 9,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Today's calories (main value)
          Text(
            formatCalories(todayCalories),
            style: AppTypography.titleMedium.copyWith(
              color: theme.textPrimary,
              fontWeight: AppTypography.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          // Total calories (badge style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: theme.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Toplam: ',
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.textSecondary,
                      fontWeight: AppTypography.medium,
                      fontSize: 9,
                    ),
                  ),
                  TextSpan(
                    text: formatCalories(totalCalories),
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.textPrimary,
                      fontWeight: AppTypography.semiBold,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
