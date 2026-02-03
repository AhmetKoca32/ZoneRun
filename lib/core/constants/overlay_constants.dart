/// Avatar overlay (aksesuar) sabitleri.
/// ID 0 = yok, 1..5 = crown, star, fire, cup, bandage.
class OverlayConstants {
  OverlayConstants._();

  static const int noneId = 0;
  static const int accessoryCount = 5;

  /// Aksesuar ID → asset path (assets/avatars/overlays/).
  static const Map<int, String> overlayAssetPaths = {
    1: 'assets/avatars/overlays/crown.png',
    2: 'assets/avatars/overlays/star.png',
    3: 'assets/avatars/overlays/fire.png',
    4: 'assets/avatars/overlays/cup.png',
    5: 'assets/avatars/overlays/bandage.png',
  };

  /// Aksesuar ID → görünen ad (Ödüller sayfası için).
  static const Map<int, String> overlayLabels = {
    1: 'Taç',
    2: 'Yıldız',
    3: 'Alev',
    4: 'Kupa',
    5: 'Bandaj',
  };

  static String? overlayAssetPath(int id) =>
      id > 0 && id <= accessoryCount ? overlayAssetPaths[id] : null;

  static String overlayLabel(int id) => overlayLabels[id] ?? 'Aksesuar $id';
}
