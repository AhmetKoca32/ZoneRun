import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/share_card.dart';

/// Paylaşılacak içeriği tam ekran gösterir; "Paylaş" ile ekran görüntüsü alınıp paylaşım açılır.
class ShareFullScreenPage extends StatefulWidget {
  final String userName;
  final int selectedBannerId;
  final String? selectedTitleLabel;
  final int avatarIndex;
  final String? avatarUrl;
  final bool includeBanner;
  final bool includeText;
  final List<String> statLines;
  final String shareText;
  /// Ana sayfadaki günlük motivasyon cümlesi; metin kısmında bu gösterilir.
  final String? motivationQuoteText;
  /// Motivasyon cümlesini söyleyen kişi; full screen'de sağ altta gösterilir.
  final String? motivationQuoteAuthor;

  const ShareFullScreenPage({
    super.key,
    required this.userName,
    required this.selectedBannerId,
    this.selectedTitleLabel,
    this.avatarIndex = 0,
    this.avatarUrl,
    required this.includeBanner,
    required this.includeText,
    required this.statLines,
    required this.shareText,
    this.motivationQuoteText,
    this.motivationQuoteAuthor,
  });

  @override
  State<ShareFullScreenPage> createState() => _ShareFullScreenPageState();
}

class _ShareFullScreenPageState extends State<ShareFullScreenPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _sharing = false;

  Future<void> _onShare() async {
    if (_sharing) return;
    setState(() => _sharing = true);

    final l10n = AppLocalizations.of(context)!;
    String shareText = widget.shareText.isEmpty ? l10n.shareDefaultText : widget.shareText;
    List<String>? filePaths;

    if (widget.includeBanner) {
      try {
        final card = ShareCard(
          userName: widget.userName,
          titleLabel: widget.selectedTitleLabel,
          selectedBannerId: widget.selectedBannerId,
          statLines: widget.statLines,
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
        if (bytes.isNotEmpty && mounted) {
          final dir = await getTemporaryDirectory();
          final file = File(
            '${dir.path}/zone_run_share_${DateTime.now().millisecondsSinceEpoch}.png',
          );
          await file.writeAsBytes(bytes);
          filePaths = [file.path];
        }
      } catch (_) {
        if (mounted) {
          setState(() => _sharing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.shareImageCreateError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }
    }

    if (!mounted) return;
    try {
      if (filePaths != null && filePaths.isNotEmpty) {
        await Share.shareXFiles(
          filePaths.map((p) => XFile(p)).toList(),
          text: shareText,
        );
      } else {
        await Share.share(shareText);
      }
      if (mounted) {
        Navigator.of(context).pop(); // full screen
        Navigator.of(context).pop(); // preview page
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.shareShareOpenError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Splash ekranındaki gibi arka plan
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: bgColor,
              image: const DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Tam ekran önizleme: banner kartı (varsa) + paylaşım metni (varsa)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.includeBanner)
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ShareCard(
                      userName: widget.userName,
                      titleLabel: widget.selectedTitleLabel,
                      selectedBannerId: widget.selectedBannerId,
                      statLines: widget.statLines,
                      avatarIndex: widget.avatarIndex,
                      avatarUrl: widget.avatarUrl,
                    ),
                  ),
                ),
              if (widget.includeText) ...[
                if (widget.includeBanner) const SizedBox(height: 20),
                _buildShareTextCard(context),
              ],
              if (!widget.includeBanner && !widget.includeText)
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.sharePreviewEmpty,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
            ],
          ),
          // Üstte geri butonu
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Altta Paylaş butonu
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _sharing ? null : _onShare,
                        icon: _sharing
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.primaryBackground,
                                ),
                              )
                            : const Icon(Icons.share, size: 22),
                        label: Text(_sharing ? l10n.sharePreparing : l10n.shareButton),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.accent,
                          foregroundColor: theme.primaryBackground,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareTextCard(BuildContext context) {
    final theme = context.appTheme;
    const maxWidth = 360.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: (theme.accent).withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Üstte ince vurgu çizgisi + ikon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 2,
                      decoration: BoxDecoration(
                        color: theme.accent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.format_quote_rounded,
                        size: 20,
                        color: theme.accent.withOpacity(0.9),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 2,
                      decoration: BoxDecoration(
                        color: theme.accent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  (widget.motivationQuoteText != null && widget.motivationQuoteText!.isNotEmpty)
                      ? widget.motivationQuoteText!
                      : widget.shareText,
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.motivationQuoteAuthor != null &&
                    widget.motivationQuoteAuthor!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— ${widget.motivationQuoteAuthor}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
