import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/data/services/history_service.dart';
import '../../../home/data/services/motivation_quote_service.dart';
import '../widgets/share_card.dart';
import 'share_fullscreen_page.dart';

/// Paylaşım sayfası: üstte banner önizlemesi (seçeneklere göre canlı güncellenir),
/// altta seçenekler, İleri ile tam ekran paylaşım sayfasına geçilir.
class SharePreviewPage extends StatefulWidget {
  final String userName;
  final int selectedBannerId;
  final String? selectedTitleLabel;
  final int avatarIndex;
  final String? avatarUrl;

  const SharePreviewPage({
    super.key,
    required this.userName,
    required this.selectedBannerId,
    this.selectedTitleLabel,
    this.avatarIndex = 0,
    this.avatarUrl,
  });

  @override
  State<SharePreviewPage> createState() => _SharePreviewPageState();
}

class _SharePreviewPageState extends State<SharePreviewPage> {
  final HistoryService _historyService = HistoryService();

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
          _error = AppLocalizations.of(context)!.shareStatsLoadError;
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

  List<String> _buildStatLines(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lines = <String>[];
    if (_statTotalKm) lines.add('📍 ${l10n.totalLabel}: ${_formatKm(_totalDistanceM)}');
    if (_statTotalArea) lines.add('📐 ${l10n.statsTotalArea}: ${_formatArea(_totalArea)}');
    if (_statPolygonCount) lines.add('🔷 ${l10n.statsPolygon}: $_polygonCount');
    if (_statStreak) lines.add('🔥 ${l10n.streak}: ${l10n.statsDays(_streak)}');
    if (_statMaxStreak) lines.add('🏆 ${l10n.statsLongestStreak}: ${l10n.statsDays(_maxStreak)}');
    if (_statThisMonthKm) {
      lines.add('📅 ${l10n.statsThisMonth}: ${_formatKm(_thisMonthDistanceM)}');
    }
    if (_statThisMonthPolygon) {
      lines.add('📅 ${l10n.shareStatMonthPolygon}: $_thisMonthPolygonCount');
    }
    return lines;
  }

  void _onNext() {
    if (_loading || _error != null) return;
    if (!_includeBanner && !_includeText) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.shareSelectBannerOrText)),
      );
      return;
    }
    final localeCode = AppLocalizations.of(context)?.localeName ?? 'tr';
    final dailyQuote =
        MotivationQuoteService.getDailyQuote(localeCode: localeCode);
    final motivationText = '${dailyQuote.quote}\n— ${dailyQuote.author}';

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ShareFullScreenPage(
          userName: widget.userName,
          selectedBannerId: widget.selectedBannerId,
          selectedTitleLabel: widget.selectedTitleLabel,
          avatarIndex: widget.avatarIndex,
          avatarUrl: widget.avatarUrl,
          includeBanner: _includeBanner,
          includeText: _includeText,
          statLines: _buildStatLines(context),
          shareText: _includeText ? motivationText : AppLocalizations.of(context)!.shareDefaultText,
          motivationQuoteText: dailyQuote.quote,
          motivationQuoteAuthor: dailyQuote.author,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.shareTitle,
          style: AppTypography.titleLarge.copyWith(
            color: theme.textPrimary,
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: theme.accent))
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
              children: [
                // Üst: Önizleme (seçeneklere göre canlı güncellenir)
                Expanded(flex: 1, child: _buildPreviewSection(theme)),
                // Alt: Seçenekler + İleri
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.shareOptions,
                            style: AppTypography.titleMedium.copyWith(
                              color: theme.textPrimary,
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.shareOptionsDescription,
                            style: AppTypography.bodySmall.copyWith(
                              color: theme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SwitchRow(
                            label: AppLocalizations.of(context)!.shareIncludeBanner,
                            value: _includeBanner,
                            onChanged: (v) =>
                                setState(() => _includeBanner = v),
                          ),
                          _SwitchRow(
                            label: AppLocalizations.of(context)!.shareIncludeText,
                            value: _includeText,
                            onChanged: (v) => setState(() => _includeText = v),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppLocalizations.of(context)!.shareStatisticsOnBanner,
                            style: AppTypography.titleSmall.copyWith(
                              color: theme.textPrimary,
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _CheckRow(
                            label: AppLocalizations.of(context)!.shareStatTotalDistance,
                            value: _statTotalKm,
                            onChanged: (v) => setState(() => _statTotalKm = v),
                          ),
                          _CheckRow(
                            label: AppLocalizations.of(context)!.shareStatPolygonCount,
                            value: _statPolygonCount,
                            onChanged: (v) =>
                                setState(() => _statPolygonCount = v),
                          ),
                          _CheckRow(
                            label: AppLocalizations.of(context)!.shareStatTotalArea,
                            value: _statTotalArea,
                            onChanged: (v) =>
                                setState(() => _statTotalArea = v),
                          ),
                          _CheckRow(
                            label: AppLocalizations.of(context)!.shareStatStreak,
                            value: _statStreak,
                            onChanged: (v) => setState(() => _statStreak = v),
                          ),
                          _CheckRow(
                            label: AppLocalizations.of(context)!.shareStatLongestStreak,
                            value: _statMaxStreak,
                            onChanged: (v) =>
                                setState(() => _statMaxStreak = v),
                          ),
                          _CheckRow(
                            label: AppLocalizations.of(context)!.shareStatMonthDistance,
                            value: _statThisMonthKm,
                            onChanged: (v) =>
                                setState(() => _statThisMonthKm = v),
                          ),
                          _CheckRow(
                            label: AppLocalizations.of(context)!.shareStatMonthPolygon,
                            value: _statThisMonthPolygon,
                            onChanged: (v) =>
                                setState(() => _statThisMonthPolygon = v),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _onNext,
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              label: Text(AppLocalizations.of(context)!.shareNext),
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.accent,
                                foregroundColor: theme.primaryBackground,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPreviewSection(dynamic theme) {
    final hasBanner = _includeBanner;
    final hasText = _includeText;
    if (!hasBanner && !hasText) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            AppLocalizations.of(context)!.sharePreviewEmpty,
            style: AppTypography.bodyMedium.copyWith(
              color: theme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          if (hasBanner) ...[
            Center(
              child: Builder(
                builder: (context) {
                  final w = (MediaQuery.sizeOf(context).width - 40).clamp(
                    200.0,
                    400.0,
                  );
                  final h = w * (280 / 400);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: w,
                      height: h,
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
                            statLines: _buildStatLines(context),
                            avatarIndex: widget.avatarIndex,
                            avatarUrl: widget.avatarUrl,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (hasText) const SizedBox(height: 12),
          ],
          if (hasText)
            Builder(
              builder: (context) {
                final localeCode =
                    AppLocalizations.of(context)?.localeName ?? 'tr';
                final q = MotivationQuoteService.getDailyQuote(
                  localeCode: localeCode,
                );
                final text = '${q.quote}\n— ${q.author}';
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.border),
                  ),
                  child: SelectableText(
                    text,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.textPrimary,
                    ),
                  ),
                );
              },
            ),
        ],
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
