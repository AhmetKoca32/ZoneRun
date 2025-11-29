import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
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
        final polygonCount = (stats['polygonCount'] as int?) ?? 0;

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
              polygonCount: polygonCount,
              formatArea: provider.formatArea,
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
            color: AppColors.white,
            fontWeight: AppTypography.light,
            fontSize: 27,
          ),
        ),
        const SizedBox(height: 2),
        // Unit (medium)
        Text(
          unit,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.white,
            fontWeight: AppTypography.light,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        // Label (smallest)
        Text(
          'CONQUERED',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.whiteWithOpacity70,
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
    final formatted = formatter(value);
    final parts = formatted.split(' ');
    final unit = parts.length > 1 ? parts[1] : '';

    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.circleGradient,
        border: Border.all(color: AppColors.whiteWithOpacity80, width: 2),
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
                color: AppColors.white,
                fontWeight: AppTypography.light,
                fontSize: 48,
              ),
            ),
            const SizedBox(height: 4),
            // Unit (medium)
            Text(
              unit,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: AppTypography.light,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            // Label (smallest)
            Text(
              'TODAY',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.white,
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
            color: AppColors.white,
            fontWeight: AppTypography.light,
            fontSize: 27,
          ),
        ),
        const SizedBox(height: 2),
        // Unit (medium)
        Text(
          unit,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.white,
            fontWeight: AppTypography.light,
            fontSize: 15,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 2),
        // Label (smallest)
        Text(
          'TOTAL',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.whiteWithOpacity70,
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SEE STATS',
              style: TextStyle(
                color: AppColors.white,
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
                color: AppColors.white,
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
  final int polygonCount;
  final String Function(double) formatArea;

  const _AnimatedStatsCards({
    required this.showStats,
    required this.averageArea,
    required this.polygonCount,
    required this.formatArea,
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
                    title: 'Average Area',
                    value: widget.formatArea(widget.averageArea),
                    icon: Icons.landscape_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Completed',
                    value: '${widget.polygonCount}',
                    icon: Icons.check_circle_outline,
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

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.mediumGray, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.mediumGray,
                  fontWeight: AppTypography.medium,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.black,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
