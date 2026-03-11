import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/theme/app_typography.dart';

/// Gizlilik bilgileri sayfası: toplanan veriler, saklama ve kullanıcı hakları.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios, color: theme.textPrimary, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Gizlilik',
                    style: AppTypography.headlineSmall.copyWith(
                      color: theme.textPrimary,
                      fontWeight: AppTypography.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Section(
                      theme: theme,
                      icon: Icons.location_on_outlined,
                      title: 'Konum verisi',
                      items: [
                        'Harita ve poligon çizimi için konumunuz yalnızca cihazınızda işlenir.',
                        'Koşu/yürüyüş sırasında mesafe ve alan hesaplanır; bu veriler yerel veritabanında (SQLite) saklanır.',
                        'Konum verisi sunucularımıza gönderilmez.',
                      ],
                    ),
                    const SizedBox(height: 24),
                    _Section(
                      theme: theme,
                      icon: Icons.account_circle_outlined,
                      title: 'Hesap bilgileri',
                      items: [
                        'Giriş yaparsanız e-posta ve isim Firebase Authentication ile işlenir.',
                        'Kayıt sonrası isim, Firestore\'da (users koleksiyonu) saklanır; sadece uygulama içi gösterim için kullanılır.',
                        'Profil tercihleriniz (avatar, tema, bildirim saatleri vb.) yalnızca cihazınızda (SharedPreferences) tutulur.',
                      ],
                    ),
                    const SizedBox(height: 24),
                    _Section(
                      theme: theme,
                      icon: Icons.notifications_outlined,
                      title: 'Bildirimler',
                      items: [
                        'Bildirim tercihleriniz ve seçtiğiniz saatler cihazınızda saklanır.',
                        'Motivasyon cümleleri ve hatırlatma metinleri sunucudan çekilmez; yerel olarak gösterilir.',
                      ],
                    ),
                    const SizedBox(height: 24),
                    _Section(
                      theme: theme,
                      icon: Icons.storage_outlined,
                      title: 'Veri saklama',
                      items: [
                        'İstatistikler, geçmiş ve ödüller cihazınızda kalır (SQLite, SharedPreferences).',
                        'Hesabı Sil ile giriş yaptıysanız Firestore\'daki profil kaydınız silinir ve hesap kapatılır.',
                      ],
                    ),
                    const SizedBox(height: 24),
                    _Section(
                      theme: theme,
                      icon: Icons.shield_outlined,
                      title: 'Haklarınız',
                      items: [
                        'Profil sayfasından çıkış yaparak oturumu kapatabilirsiniz.',
                        'Hesabı Sil ile hesabınızı ve Firestore verinizi kalıcı olarak silebilirsiniz.',
                        'Uygulama verilerini tamamen kaldırmak için uygulamayı cihazınızdan kaldırmanız yeterlidir.',
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _openFullPrivacyUrl(context),
                        icon: Icon(Icons.description_outlined, size: 20, color: theme.accent),
                        label: Text(
                          'Tam gizlilik politikası (web)',
                          style: AppTypography.labelLarge.copyWith(color: theme.accent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFullPrivacyUrl(BuildContext context) async {
    final locale = Localizations.localeOf(context).languageCode;
    final path = locale == 'tr' ? '/gizlilik/' : '/privacy/';
    final url = 'https://zone-run.vercel.app$path';
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bağlantı açılamadı'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bağlantı açılamadı'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.theme,
    required this.icon,
    required this.title,
    required this.items,
  });

  final dynamic theme;
  final IconData icon;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.border.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  color: theme.textPrimary,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: theme.accent,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.textSecondary,
                        height: 1.45,
                      ),
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
