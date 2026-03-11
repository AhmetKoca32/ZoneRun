import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/data/services/history_service.dart';

/// Mock veri kullanılsın mı? false = gerçek veri (HistoryService).
const bool _useMockData = false;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final HistoryService _historyService = HistoryService();
  final math.Random _random = math.Random(42);
  bool _loading = true;
  String? _error;

  double _totalDistanceM = 0;
  double _totalArea = 0;
  int _polygonCount = 0;
  int _streak = 0;
  int _maxStreak = 0;
  double _maxArea = 0;
  double _maxDistanceSingleDayM = 0;
  double _thisMonthDistanceM = 0;
  int _thisMonthPolygonCount = 0;
  double _lastMonthDistanceM = 0;
  int _lastMonthPolygonCount = 0;
  Map<DateTime, double> _dailyDistance = {};
  List<({DateTime weekStart, double distanceM, int polygonCount})>
  _weeklyTotals = [];
  int? _selectedWeekIndex;

  static const int _heatmapWeeks = 12;
  static const int _barChartWeeks = 8;
  static const double _kcalPerKm = 55;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _applyMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = now.weekday;
    final mondayOffset = weekday - DateTime.monday;
    final thisWeekStart = today.subtract(Duration(days: mondayOffset));

    _totalDistanceM = 47250; // ~47.25 km
    _totalArea = 185000; // m²
    _polygonCount = 28;
    _streak = 5;
    _maxStreak = 12;

    _dailyDistance = {};
    final startDate = thisWeekStart.subtract(Duration(days: _heatmapWeeks * 7));
    for (var i = 0; i < _heatmapWeeks * 7; i++) {
      final date = startDate.add(Duration(days: i));
      if (_random.nextDouble() > 0.45) {
        final km = 0.5 + _random.nextDouble() * 5.5;
        _dailyDistance[date] = km * 1000;
      }
    }

    _weeklyTotals = [];
    for (var w = 0; w < _barChartWeeks; w++) {
      final weekStart = thisWeekStart.subtract(Duration(days: 7 * w));
      final km = 2.0 + _random.nextDouble() * 12.0;
      final count = 1 + _random.nextInt(5);
      _weeklyTotals.add((
        weekStart: weekStart,
        distanceM: km * 1000,
        polygonCount: count,
      ));
    }
    _maxArea = 12500;
    _maxDistanceSingleDayM = 8200;
    _thisMonthDistanceM = 18500;
    _thisMonthPolygonCount = 7;
    _lastMonthDistanceM = 14200;
    _lastMonthPolygonCount = 5;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      _applyMockData();
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final totalDistance = await _historyService.getTotalDistance();
      final totalArea = await _historyService.getTotalAreaConquered();
      final polygonCount = await _historyService.getPolygonCount();
      final streak = await _historyService.getCurrentStreak();
      final maxStreak = await _historyService.getMaxStreak();
      final maxArea = await _historyService.getMaxArea();
      final maxDistanceSingleDay = await _historyService
          .getMaxDistanceInSingleDay();
      final thisMonthPolygons = await _historyService.getThisMonthPolygons();
      final thisMonthDistance = await _historyService.getThisMonthDistance();
      final lastMonthPolygons = await _historyService.getLastMonthPolygons();
      final lastMonthDistance = await _historyService.getLastMonthDistance();
      final dailyDistance = await _historyService.getDailyDistanceForLastDays(
        _heatmapWeeks * 7,
      );
      final weeklyTotals = await _historyService.getWeeklyTotalsForLastWeeks(
        _barChartWeeks,
      );

      if (mounted) {
        setState(() {
          _totalDistanceM = totalDistance;
          _totalArea = totalArea;
          _polygonCount = polygonCount;
          _streak = streak;
          _maxStreak = maxStreak;
          _maxArea = maxArea;
          _maxDistanceSingleDayM = maxDistanceSingleDay;
          _thisMonthDistanceM = thisMonthDistance;
          _thisMonthPolygonCount = thisMonthPolygons.length;
          _lastMonthDistanceM = lastMonthDistance;
          _lastMonthPolygonCount = lastMonthPolygons.length;
          _dailyDistance = dailyDistance;
          _weeklyTotals = weeklyTotals;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.statsLoadError;
          _loading = false;
        });
      }
    }
  }

  String _formatDistance(double m) {
    if (m < 1000) return '${m.toStringAsFixed(0)} m';
    return '${(m / 1000).toStringAsFixed(2)} km';
  }

  String _formatArea(double m2) {
    if (m2 < 10000) return '${m2.toStringAsFixed(0)} m²';
    if (m2 < 1000000) return '${(m2 / 10000).toStringAsFixed(2)} ha';
    return '${(m2 / 1000000).toStringAsFixed(2)} km²';
  }

  int get _totalCalories => (_totalDistanceM / 1000 * _kcalPerKm).round();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    if (_loading) {
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: _buildAppBar(context, theme),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: _buildAppBar(context, theme),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error!, style: TextStyle(color: theme.textSecondary)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: _buildAppBar(context, theme),
      body: RefreshIndicator(
        onRefresh: _load,
        color: theme.accent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummarySection(context, theme),
              const SizedBox(height: 32),
              _buildSectionTitle(context, theme, AppLocalizations.of(context)!.statsSectionPersonalRecords),
              const SizedBox(height: 8),
              _buildPersonalRecordsSection(context, theme),
              const SizedBox(height: 32),
              _buildSectionTitle(context, theme, AppLocalizations.of(context)!.statsSectionMonthComparison),
              const SizedBox(height: 8),
              _buildMonthComparisonSection(context, theme),
              const SizedBox(height: 32),
              _buildSectionTitle(context, theme, AppLocalizations.of(context)!.statsSectionActivityCalendar),
              const SizedBox(height: 8),
              _buildHeatmap(context, theme),
              const SizedBox(height: 32),
              _buildSectionTitle(context, theme, AppLocalizations.of(context)!.statsSectionWeeklySummary),
              const SizedBox(height: 16),
              _buildWeeklyBarChart(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, dynamic theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: theme.textPrimary, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        AppLocalizations.of(context)!.statsPageTitle,
        style: AppTypography.headlineSmall.copyWith(
          color: theme.textPrimary,
          fontWeight: AppTypography.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSectionTitle(BuildContext context, dynamic theme, String title) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        color: theme.textPrimary,
        fontWeight: AppTypography.semiBold,
      ),
    );
  }

  Widget _buildPersonalRecordsSection(BuildContext context, dynamic theme) {
    final l10n = AppLocalizations.of(context)!;
    const milestonesKm = [10, 50, 100];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _recordCard(
                  theme,
                  l10n.statsRecordLargestArea,
                  _formatArea(_maxArea),
                  Icons.landscape,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _recordCard(
                  theme,
                  l10n.statsRecordSingleDay,
                  _formatDistance(_maxDistanceSingleDayM),
                  Icons.directions_run,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.statsMilestones,
            style: AppTypography.labelMedium.copyWith(
              color: theme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final km in milestonesKm) ...[
                if (km > 10) const SizedBox(width: 8),
                _milestoneChip(theme, '$km km', _totalDistanceM >= km * 1000),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _recordCard(dynamic theme, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: theme.accent, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: theme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: theme.textSecondary,
              fontSize: 10,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _milestoneChip(dynamic theme, String label, bool achieved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: achieved
            ? theme.accent.withOpacity(0.15)
            : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: achieved ? theme.accent : theme.border.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (achieved) Icon(Icons.check_circle, color: theme.accent, size: 18),
          if (achieved) const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: achieved ? theme.accent : theme.textSecondary,
              fontWeight: achieved
                  ? AppTypography.semiBold
                  : AppTypography.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthComparisonSection(BuildContext context, dynamic theme) {
    final l10n = AppLocalizations.of(context)!;
    final thisMonthKm = _thisMonthDistanceM / 1000;
    final lastMonthKm = _lastMonthDistanceM / 1000;
    final diffKm = thisMonthKm - lastMonthKm;
    String? diffText;
    if (lastMonthKm > 0 && diffKm != 0) {
      final kmStr = (diffKm > 0 ? diffKm : -diffKm).toStringAsFixed(1);
      diffText = diffKm > 0 ? l10n.statsMonthDiffMore(kmStr) : l10n.statsMonthDiffLess(kmStr);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsThisMonth,
                      style: AppTypography.labelMedium.copyWith(
                        color: theme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDistance(_thisMonthDistanceM),
                      style: AppTypography.titleMedium.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    Text(
                      l10n.statsPolygonCount(_thisMonthPolygonCount),
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: theme.border.withOpacity(0.5),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsLastMonth,
                      style: AppTypography.labelMedium.copyWith(
                        color: theme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDistance(_lastMonthDistanceM),
                      style: AppTypography.titleMedium.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    Text(
                      l10n.statsPolygonCount(_lastMonthPolygonCount),
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (diffText != null) ...[
            const SizedBox(height: 12),
            Text(
              diffText,
              style: AppTypography.labelSmall.copyWith(
                color: diffKm > 0 ? theme.accent : theme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, dynamic theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _summaryCard(
                theme,
                l10n.statsTotalDistance,
                _formatDistance(_totalDistanceM),
                Icons.straighten,
              ),
              const SizedBox(width: 12),
              _summaryCard(
                theme,
                l10n.statsTotalArea,
                _formatArea(_totalArea),
                Icons.landscape_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _summaryCard(
                theme,
                l10n.statsPolygon,
                '$_polygonCount',
                Icons.pentagon_outlined,
              ),
              const SizedBox(width: 12),
              _summaryCard(
                theme,
                l10n.statsCaloriesEstimate,
                '$_totalCalories kcal',
                Icons.local_fire_department_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _summaryCard(
                theme,
                l10n.statsStreakDays,
                '$_streak',
                Icons.local_fire_department,
              ),
              const SizedBox(width: 12),
              _summaryCard(
                theme,
                l10n.statsLongestStreak,
                l10n.statsDays(_maxStreak),
                Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    dynamic theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.textTertiary, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTypography.titleSmall.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: theme.textSecondary,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap(BuildContext context, dynamic theme) {
    final l10n = AppLocalizations.of(context)!;
    const daysInWeek = 7;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = now.weekday;
    final mondayOffset = weekday - DateTime.monday;
    final thisWeekStart = today.subtract(Duration(days: mondayOffset));
    final startDate = thisWeekStart.subtract(Duration(days: _heatmapWeeks * 7));

    double maxDailyM = 1.0;
    for (final v in _dailyDistance.values) {
      if (v > maxDailyM) maxDailyM = v;
    }

    final weekDayLabels = [
      l10n.statsHeatmapMon,
      l10n.statsHeatmapTue,
      l10n.statsHeatmapWed,
      l10n.statsHeatmapThu,
      l10n.statsHeatmapFri,
      l10n.statsHeatmapSat,
      l10n.statsHeatmapSun,
    ];

    String weekLabel(int w) {
      if (w == 0) return l10n.statsHeatmapWeeksAgo;
      if (w == _heatmapWeeks - 1) return l10n.statsHeatmapThisWeek;
      return l10n.statsHeatmapNWeeks(_heatmapWeeks - w);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsHeatmapDescription,
            style: AppTypography.labelSmall.copyWith(
              color: theme.textTertiary,
              fontSize: 10,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 28),
              ...List.generate(daysInWeek, (d) {
                return Expanded(
                  child: Center(
                    child: Text(
                      weekDayLabels[d],
                      style: AppTypography.labelSmall.copyWith(
                        color: theme.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 6),
          ...List.generate(_heatmapWeeks, (w) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      weekLabel(w),
                      style: AppTypography.labelSmall.copyWith(
                        color: theme.textSecondary,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  ...List.generate(daysInWeek, (d) {
                    final date = startDate.add(
                      Duration(days: w * daysInWeek + d),
                    );
                    final dist = _dailyDistance[date] ?? 0.0;
                    final level = maxDailyM > 0
                        ? (dist / maxDailyM).clamp(0.0, 1.0)
                        : 0.0;
                    Color cellColor;
                    if (level <= 0) {
                      cellColor = theme.secondaryBackground;
                    } else {
                      cellColor = Color.lerp(
                        const Color(0xFF81C784),
                        const Color(0xFF1B5E20),
                        level,
                      )!;
                    }
                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.statsHeatmapColorMeaning,
                style: AppTypography.labelSmall.copyWith(
                  color: theme.textTertiary,
                  fontSize: 9,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.statsHeatmapLess,
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ...List.generate(4, (i) {
                    final t = (i + 1) / 4;
                    final c = Color.lerp(
                      const Color(0xFF81C784),
                      const Color(0xFF1B5E20),
                      t,
                    )!;
                    return Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                  const SizedBox(width: 4),
                  Text(
                    l10n.statsHeatmapMore,
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyBarChart(BuildContext context, dynamic theme) {
    final l10n = AppLocalizations.of(context)!;
    if (_weeklyTotals.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.border.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(
            l10n.statsWeeklyNoData,
            style: TextStyle(color: theme.textSecondary),
          ),
        ),
      );
    }

    final maxDistance = _weeklyTotals
        .map((e) => e.distanceM)
        .fold(0.0, (a, b) => a > b ? a : b);
    final maxY = maxDistance > 0
        ? (maxDistance / 1000 * 1.2).ceilToDouble()
        : 1.0;

    const barColorLight = Color(0xFF81C784);
    const barColorDark = Color(0xFF1B5E20);
    final barGroups = _weeklyTotals.asMap().entries.map((e) {
      final km = e.value.distanceM / 1000;
      final t = _barChartWeeks > 1 ? 1.0 - (e.key / (_barChartWeeks - 1)) : 1.0;
      final barColor = Color.lerp(barColorLight, barColorDark, t)!;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: km,
            color: barColor,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
        showingTooltipIndicators: _selectedWeekIndex == e.key ? [0] : [],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.statsWeeklyDescription,
            style: AppTypography.labelSmall.copyWith(
              color: theme.textTertiary,
              fontSize: 10,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (event is FlTapUpEvent && response?.spot != null) {
                      final index = response!.spot!.touchedBarGroupIndex;
                      if (index >= 0 && index < _weeklyTotals.length) {
                        setState(() {
                          _selectedWeekIndex = _selectedWeekIndex == index
                              ? null
                              : index;
                        });
                      }
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => theme.secondaryBackground,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final w = _weeklyTotals[group.x];
                      return BarTooltipItem(
                        l10n.statsWeeklyTooltip(
                          (rod.toY).toStringAsFixed(2),
                          w.polygonCount,
                        ),
                        AppTypography.labelSmall.copyWith(
                          color: theme.textPrimary,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: AppTypography.labelSmall.copyWith(
                            color: theme.textSecondary,
                            fontSize: 9,
                          ),
                        );
                      },
                      reservedSize: 24,
                      interval: maxY > 0 ? maxY / 4 : 1,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 4 : 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.border.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: barGroups,
              ),
              duration: const Duration(milliseconds: 200),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.statsWeeklyTapHint,
            style: AppTypography.labelSmall.copyWith(
              color: theme.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
