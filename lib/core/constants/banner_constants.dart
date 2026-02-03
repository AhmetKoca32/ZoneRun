import 'package:flutter/material.dart';

/// Banner görünüm sabitleri: isimler, gradient fallback ve ödül arka plan görselleri.
/// ID 0 = varsayılan (tema rengi), 1..rewardBannerCount = ödül banner'ları (görsel veya gradient).
class BannerConstants {
  BannerConstants._();

  /// Banner ID → Ödüller sekmesinde görünen isim (havalı, genel geçer)
  static const Map<int, String> labels = {
    0: 'Varsayılan',
    1: 'Aurora',
    2: 'Ateş',
    3: 'Yükseliş',
  };

  static String label(int bannerId) => labels[bannerId] ?? 'Banner $bannerId';

  /// Ödül banner'ları (1, 2, 3) için arka plan görseli yolu. Yoksa gradient kullanılır.
  static const String _bannerAssetDir = 'assets/banners';

  static String? imagePath(int bannerId) {
    if (bannerId >= 1 && bannerId <= 3)
      return '$_bannerAssetDir/banner_$bannerId.png';
    return null;
  }

  static bool hasImage(int bannerId) => imagePath(bannerId) != null;

  /// Koyu tema: ödül banner gradientleri (ID 1, 2, 3)
  static const List<List<Color>> darkGradients = [
    [Color(0xFF1A3A5C), Color(0xFF2D1B4E)], // 1 Aurora
    [Color(0xFF6B2D5F), Color(0xFFE84C3D)], // 2 Ateş
    [Color(0xFF2E7D32), Color(0xFF1565C0)], // 3 Yükseliş
  ];

  /// Açık tema: ödül banner gradientleri
  static const List<List<Color>> lightGradients = [
    [Color(0xFF4FC3F7), Color(0xFFBA68C8)], // 1 Aurora
    [Color(0xFFFFB74D), Color(0xFFE91E63)], // 2 Ateş
    [Color(0xFF81C784), Color(0xFF64B5F6)], // 3 Yükseliş
  ];

  /// [bannerId] ve [isDark] için gradient renk listesi. ID 0 için null (tema ile çizilir).
  static List<Color>? gradientColors(int bannerId, bool isDark) {
    if (bannerId <= 0) return null;
    final set = isDark ? darkGradients : lightGradients;
    final index = bannerId - 1;
    if (index < 0 || index >= set.length) return null;
    return set[index];
  }
}
