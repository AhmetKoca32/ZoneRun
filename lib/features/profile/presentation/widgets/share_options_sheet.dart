import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/data/services/history_service.dart';
import 'share_card.dart';

/// Paylaşım seçenekleri: banner dahil, metin dahil, hangi istatistikler.
/// [userName], [selectedBannerId], [selectedTitleLabel] profil bilgisi;
/// istatistikler [HistoryService] ile yüklenir.
void showShareOptionsSheet(
  BuildContext context, {
  required String userName,
  required int selectedBannerId,
  String? selectedTitleLabel,
  int avatarIndex = 0,
  String? avatarUrl,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ShareOptionsSheetContent(
      userName: userName,
      selectedBannerId: selectedBannerId,
      selectedTitleLabel: selectedTitleLabel,
      avatarIndex: avatarIndex,
      avatarUrl: avatarUrl,
    ),
  );
}

class _ShareOptionsSheetContent extends StatefulWidget {
  final String userName;
  final int selectedBannerId;
  final String? selectedTitleLabel;
  final int avatarIndex;
  final String? avatarUrl;

  const _ShareOptionsSheetContent({
    required this.userName,
    required this.selectedBannerId,
    this.selectedTitleLabel,
    this.avatarIndex = 0,
    this.avatarUrl,
  });

  @override
  State<_ShareOptionsSheetContent> createState() =>
      _ShareOptionsSheetContentState();
}

class _ShareOptionsSheetContentState extends State<_ShareOptionsSheetContent> {
  final HistoryService _historyService = HistoryService();
  final ScreenshotController _screenshotController = ScreenshotController();

  bool _loading = true;
  String? _error;

  bool _includeBanner = true;
  bool _includeText = true;
  bool _statTotalKm = true;
  bool _statPolygonCount = true;
  bool _statStreak = false;
  bool _statMaxStreak = false;
  bool _statThisMonthKm = false;
  bool _statThisMonthPolygon = false;
  bool _statTotalArea = false;

  double _totalDistanceM = 0;
  double _totalArea = 0;
  int _polygonCount = 0;
  int _streak = 0;
  int _maxStreak = 0;
  double _thisMonthDistanceM = 0;
  int _thisMonthPolygonCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final results = await Future.wait([
        _historyService.getTotalDistance(),
        _historyService.getTotalAreaConquered(),
        _historyService.getPolygonCount(),
        _historyService.getCurrentStreak(),
        _historyService.getMaxStreak(),
        _historyService.getThisMonthDistance(),
        _historyService.getThisMonthPolygons(),
      ]);
      if (!mounted) return;
      final thisMonthPolygons = results[6] as List;
      setState(() {
        _totalDistanceM = results[0] as double;
        _totalArea = results[1] as double;
        _polygonCount = results[2] as int;
        _streak = results[3] as int;
        _maxStreak = results[4] as int;
        _thisMonthDistanceM = results[5] as double;
        _thisMonthPolygonCount = thisMonthPolygons.length;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'load_error';
          _loading = false;
        });
      }
    }
  }

  String _formatKm(double m) {
    if (m < 1000) return '${m.toStringAsFixed(0)} m';
    return '${(m / 1000).toStringAsFixed(2)} km';
  }

  String _formatArea(double m2) {
    if (m2 < 10000) return '${m2.toStringAsFixed(0)} m²';
    if (m2 < 1000000) return '${(m2 / 10000).toStringAsFixed(2)} ha';
    return '${(m2 / 1000000).toStringAsFixed(2)} km²';
  }

  List<String> _buildStatLines(AppLocalizations l10n) {
    final lines = <String>[];
    if (_statTotalKm) lines.add('📍 ${l10n.shareStatTotalDistance}: ${_formatKm(_totalDistanceM)}');
    if (_statTotalArea) lines.add('📐 ${l10n.shareStatTotalArea}: ${_formatArea(_totalArea)}');
    if (_statPolygonCount) lines.add('🔷 ${l10n.shareStatPolygonCount}: $_polygonCount');
    if (_statStreak) lines.add('🔥 ${l10n.shareStatStreak}: $_streak');
    if (_statMaxStreak) lines.add('🏆 ${l10n.shareStatLongestStreak}: $_maxStreak');
    if (_statThisMonthKm) {
      lines.add('📅 ${l10n.shareStatMonthDistance}: ${_formatKm(_thisMonthDistanceM)}');
    }
    if (_statThisMonthPolygon) {
      lines.add('📅 ${l10n.shareStatMonthPolygon}: $_thisMonthPolygonCount');
    }
    return lines;
  }

  Widget _buildPreview(BuildContext context, dynamic theme) {
    final l10n = AppLocalizations.of(context)!;
    final hasBanner = _includeBanner;
    final hasText = _includeText;
    if (!hasBanner && !hasText) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.border),
        ),
        child: Text(
          l10n.sharePreviewEmpty,
          style: AppTypography.bodySmall.copyWith(color: theme.textSecondary),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasBanner) ...[
          Text(
            l10n.shareLabelImage,
            style: AppTypography.bodySmall.copyWith(
              color: theme.textSecondary,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 200,
                height: 140,
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    height: 280,
                    child: ShareCard(
                      userName: widget.userName,
                      titleLabel: widget.selectedTitleLabel,
                      selectedBannerId: widget.selectedBannerId,
                      statLines: _buildStatLines(l10n),
                      avatarIndex: widget.avatarIndex,
                      avatarUrl: widget.avatarUrl,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (hasText) const SizedBox(height: 12),
        ],
        if (hasText) ...[
          Text(
            l10n.shareLabelText,
            style: AppTypography.bodySmall.copyWith(
              color: theme.textSecondary,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 100),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.border),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                _buildShareText(l10n),
                style: AppTypography.bodySmall.copyWith(
                  color: theme.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _buildShareText(AppLocalizations l10n) {
    final parts = <String>[l10n.shareDefaultText];
    parts.add(widget.userName);
    if (widget.selectedTitleLabel != null &&
        widget.selectedTitleLabel!.isNotEmpty) {
      parts.add(widget.selectedTitleLabel!);
    }
    if (_statTotalKm) parts.add('${l10n.shareStatTotalDistance}: ${_formatKm(_totalDistanceM)}');
    if (_statPolygonCount) parts.add('${l10n.shareStatPolygonCount}: $_polygonCount');
    if (_statStreak) parts.add('${l10n.shareStatStreak}: $_streak');
    if (_statMaxStreak) parts.add('${l10n.shareStatLongestStreak}: $_maxStreak');
    if (_statThisMonthKm) {
      parts.add('${l10n.shareStatMonthDistance}: ${_formatKm(_thisMonthDistanceM)}');
    }
    if (_statTotalArea) parts.add('${l10n.shareStatTotalArea}: ${_formatArea(_totalArea)}');
    if (_statThisMonthPolygon) {
      parts.add('${l10n.shareStatMonthPolygon}: $_thisMonthPolygonCount');
    }
    return parts.join(' • ');
  }

  Future<void> _onShare() async {
    String shareText = '';
    List<String>? filePaths;

    if (_includeText) {
      shareText = _buildShareText(AppLocalizations.of(context)!);
    }

    if (_includeBanner) {
      try {
        final l10n = AppLocalizations.of(context)!;
        final card = ShareCard(
          userName: widget.userName,
          titleLabel: widget.selectedTitleLabel,
          selectedBannerId: widget.selectedBannerId,
          statLines: _buildStatLines(l10n),
          avatarIndex: widget.avatarIndex,
          avatarUrl: widget.avatarUrl,
        );
        final bytes = await _screenshotController.captureFromWidget(
          MaterialApp(
            theme: Theme.of(context),
            home: Material(child: card),
          ),
          pixelRatio: 2,
          delay: const Duration(milliseconds: 400),
          targetSize: const Size(400, 280),
          context: context,
        );
        if (bytes.isNotEmpty) {
          final dir = await getTemporaryDirectory();
          final file = File(
            '${dir.path}/zone_run_share_${DateTime.now().millisecondsSinceEpoch}.png',
          );
          await file.writeAsBytes(bytes);
          filePaths = [file.path];
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.shareImageCreateError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }
    }

    try {
      if (!mounted) return;
      final defaultText = AppLocalizations.of(context)!.shareDefaultText;
      if (filePaths != null && filePaths.isNotEmpty) {
        await Share.shareXFiles(
          filePaths.map((p) => XFile(p)).toList(),
          text: shareText.isEmpty ? defaultText : shareText,
        );
      } else {
        await Share.share(
          shareText.isEmpty ? defaultText : shareText,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.shareShareOpenError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.shareOptions,
                      style: AppTypography.headlineSmall.copyWith(
                        color: theme.textPrimary,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.shareOptionsDescription,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.shareStatsLoadError,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      )
                    else ...[
                      _SwitchRow(
                        label: l10n.shareIncludeBanner,
                        value: _includeBanner,
                        onChanged: (v) => setState(() => _includeBanner = v),
                      ),
                      _SwitchRow(
                        label: l10n.shareIncludeText,
                        value: _includeText,
                        onChanged: (v) => setState(() => _includeText = v),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.shareStatisticsOnBanner,
                        style: AppTypography.titleSmall.copyWith(
                          color: theme.textPrimary,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _CheckRow(
                        label: l10n.shareStatTotalDistance,
                        value: _statTotalKm,
                        onChanged: (v) => setState(() => _statTotalKm = v),
                      ),
                      _CheckRow(
                        label: l10n.shareStatPolygonCount,
                        value: _statPolygonCount,
                        onChanged: (v) => setState(() => _statPolygonCount = v),
                      ),
                      _CheckRow(
                        label: l10n.shareStatTotalArea,
                        value: _statTotalArea,
                        onChanged: (v) => setState(() => _statTotalArea = v),
                      ),
                      _CheckRow(
                        label: l10n.shareStatStreak,
                        value: _statStreak,
                        onChanged: (v) => setState(() => _statStreak = v),
                      ),
                      _CheckRow(
                        label: l10n.shareStatLongestStreak,
                        value: _statMaxStreak,
                        onChanged: (v) => setState(() => _statMaxStreak = v),
                      ),
                      _CheckRow(
                        label: l10n.shareStatMonthDistance,
                        value: _statThisMonthKm,
                        onChanged: (v) => setState(() => _statThisMonthKm = v),
                      ),
                      _CheckRow(
                        label: l10n.shareStatMonthPolygon,
                        value: _statThisMonthPolygon,
                        onChanged: (v) =>
                            setState(() => _statThisMonthPolygon = v),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.sharePreview,
                        style: AppTypography.titleSmall.copyWith(
                          color: theme.textPrimary,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPreview(context, theme),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _onShare,
                          icon: const Icon(Icons.share, size: 20),
                          label: Text(l10n.shareButton),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.accent,
                            foregroundColor: theme.primaryBackground,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: theme.accent.withOpacity(0.5),
            activeThumbColor: theme.accent,
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CheckboxListTile(
        title: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: theme.textPrimary),
        ),
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return theme.accent;
          return null;
        }),
        checkColor: theme.primaryBackground,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
