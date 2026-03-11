import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/models/polygon_model.dart';
import '../../../../core/navigation/main_navigation.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_extra.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../providers/history_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatArea(double areaInSquareMeters) {
    if (areaInSquareMeters < 10000) {
      // Less than 1 hectare, show in m²
      return '${areaInSquareMeters.toStringAsFixed(0)} m²';
    } else if (areaInSquareMeters < 1000000) {
      // Less than 1 km², show in hectares
      return '${(areaInSquareMeters / 10000).toStringAsFixed(2)} ha';
    } else {
      // 1 km² or more, show in km²
      return '${(areaInSquareMeters / 1000000).toStringAsFixed(2)} km²';
    }
  }

  String _getTimeAgo(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return l10n.historyJustNow;
        }
        return l10n.historyMinutesAgo(difference.inMinutes);
      }
      return l10n.historyHoursAgo(difference.inHours);
    } else if (difference.inDays == 1) {
      return l10n.historyYesterday;
    } else if (difference.inDays < 7) {
      return l10n.historyDaysAgo(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return l10n.historyWeeksAgo(weeks);
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return l10n.historyMonthsAgo(months);
    } else {
      final years = (difference.inDays / 365).floor();
      return l10n.historyYearsAgo(years);
    }
  }

  static const _keyToday = 'today';
  static const _keyThisWeek = 'this_week';
  static const _keyThisMonth = 'this_month';
  static const _keyThisYear = 'this_year';
  static const _keyOlder = 'older';

  Map<String, List<PolygonModel>> _groupPolygonsByDate(List<PolygonModel> polygons) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final thisYearStart = DateTime(now.year, 1, 1);

    final Map<String, List<PolygonModel>> grouped = {
      _keyToday: [],
      _keyThisWeek: [],
      _keyThisMonth: [],
      _keyThisYear: [],
      _keyOlder: [],
    };

    for (final polygon in polygons) {
      if (polygon.completedAt == null) continue;

      final completedDate = DateTime(
        polygon.completedAt!.year,
        polygon.completedAt!.month,
        polygon.completedAt!.day,
      );

      if (completedDate == today) {
        grouped[_keyToday]!.add(polygon);
      } else if (completedDate.isAfter(thisWeekStart.subtract(const Duration(days: 1)))) {
        grouped[_keyThisWeek]!.add(polygon);
      } else if (completedDate.isAfter(thisMonthStart.subtract(const Duration(days: 1)))) {
        grouped[_keyThisMonth]!.add(polygon);
      } else if (completedDate.isAfter(thisYearStart.subtract(const Duration(days: 1)))) {
        grouped[_keyThisYear]!.add(polygon);
      } else {
        grouped[_keyOlder]!.add(polygon);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  String _getGroupTitle(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case _keyToday:
        return l10n.historyToday;
      case _keyThisWeek:
        return l10n.historyThisWeek;
      case _keyThisMonth:
        return l10n.historyThisMonth;
      case _keyThisYear:
        return l10n.historyThisYear;
      case _keyOlder:
        return l10n.historyOlder;
      default:
        return key;
    }
  }

  void _showPolygonOnMap(BuildContext context, PolygonModel polygon) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    // Get MainNavigation callback before showing dialog
    final mainNav = MainNavigationInherited.of(context);
    
    // Show confirmation dialog before navigating to map
    showDialog(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.border, width: 1),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.map_outlined,
                      color: theme.accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.historyShowOnMapTitle,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.historyShowOnMapQuestion,
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      polygon.name,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.historyAreaLabel}: ${_formatArea(polygon.area)}',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${polygon.points.length} ${l10n.historyPointsLabel}',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.border, width: 1),
                        foregroundColor: theme.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.historyCancel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        // Switch to map tab (index 1) using MainNavigation callback
                        if (mainNav != null) {
                          // Set polygon to focus in MapProvider
                          final mapProvider = Provider.of<MapProvider>(context, listen: false);
                          mapProvider.setPolygonToFocus(polygon);
                          
                          // Switch to map page
                          mainNav.switchToTab(1);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accent,
                        foregroundColor: theme.primaryBackground,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.historyGoToMap,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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

  Widget _buildPolygonCard(
    BuildContext context,
    PolygonModel polygon,
    HistoryProvider provider,
  ) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    return Dismissible(
      key: Key('polygon_${polygon.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: theme.textPrimary,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        // Show delete confirmation dialog
        final theme = context.appTheme;
        return await showDialog<bool>(
          context: context,
          barrierColor: theme.primaryBackground.withOpacity(0.7),
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.border, width: 1),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.textSecondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: theme.textPrimary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.historyDeleteTitle,
                              style: TextStyle(
                                color: theme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.historyDeleteQuestion,
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.border, width: 1),
                    ),
                    child: Text(
                      polygon.name,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.border, width: 1),
                            foregroundColor: theme.textSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.historyCancel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.secondaryBackground,
                            foregroundColor: theme.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.mapDeleted,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
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
        ) ?? false;
      },
      onDismissed: (direction) async {
        if (polygon.id != null) {
          final success = await provider.deletePolygon(polygon.id!);
          if (context.mounted) {
            if (success) {
              final mapProvider = Provider.of<MapProvider>(context, listen: false);
              await mapProvider.loadSavedPolygons();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.historyDeleted,
                    style: TextStyle(color: theme.textPrimary, fontSize: 14),
                  ),
                  backgroundColor: theme.surface,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.surface,
              theme.surface.withOpacity(0.8),
              theme.secondaryBackground.withOpacity(0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryBackground.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showPolygonOnMap(context, polygon),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon with gradient
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.accent,
                              theme.accent.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: theme.primaryBackground,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              polygon.name,
                              style: TextStyle(
                                color: theme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (polygon.completedAt != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: theme.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getTimeAgo(context, polygon.completedAt!),
                                    style: TextStyle(
                                      color: theme.textTertiary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Map icon button
                      IconButton(
                        onPressed: () => _showPolygonOnMap(context, polygon),
                        icon: Icon(
                          Icons.map_outlined,
                          color: theme.accent,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: l10n.historyShowOnMap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    children: [
                      // Area
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.area_chart,
                                size: 18,
                                color: theme.accent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                            Text(
                              l10n.historyAreaLabel,
                                      style: TextStyle(
                                        color: theme.textTertiary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatArea(polygon.area),
                                      style: TextStyle(
                                        color: theme.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Points count
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: 18,
                              color: theme.accent,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.historyPointsLabel,
                                  style: TextStyle(
                                    color: theme.textTertiary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${polygon.points.length}',
                                  style: TextStyle(
                                    color: theme.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          final l10n = AppLocalizations.of(context)!;
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.accent,
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.textSecondary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      color: theme.textSecondary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    provider.errorMessage!,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => provider.loadHistory(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accent,
                      foregroundColor: theme.primaryBackground,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.historyRetry,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.polygons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.history,
                      size: 64,
                      color: theme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.historyNoPolygonsYet,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.historyEmptyHint,
                    style: TextStyle(
                      color: theme.textTertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }

          // Group polygons by date
          final groupedPolygons = _groupPolygonsByDate(provider.polygons);

          return RefreshIndicator(
            onRefresh: () => provider.loadHistory(),
            color: theme.accent,
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      MediaQuery.of(context).padding.top + 16,
                      20,
                      24,
                    ),
                    child: Text(
                      'Geçmiş',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
                // Grouped polygon lists
                ...groupedPolygons.entries.map((entry) {
                  final groupName = entry.key;
                  final polygons = entry.value;
                  
                  return SliverMainAxisGroup(
                    slivers: [
                      // Section header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                          child: Row(
                            children: [
                              Container(
                                width: 3,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: theme.accent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getGroupTitle(context, groupName),
                                style: TextStyle(
                                  color: theme.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Polygon list for this group
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final polygon = polygons[index];
                              return _buildPolygonCard(
                                context,
                                polygon,
                                provider,
                              );
                            },
                            childCount: polygons.length,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
