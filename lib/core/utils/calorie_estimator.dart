import '../models/polygon_model.dart';
import 'geometry_utils.dart';

/// MET tabanlı kalori tahmini yardımcıları.
///
/// Formül (yaklaşık):
/// kcal = MET × ağırlık(kg) × süre(saat)
class CalorieEstimator {
  CalorieEstimator._();

  /// Kullanıcı kilo girmemişse kullanılan varsayılan kilo (kg).
  static const double defaultWeightKg = 70.0;

  /// Minimum ve maksimum kabul edilen kilo aralığı (güvenlik için clamp).
  static const double minWeightKg = 35.0;
  static const double maxWeightKg = 160.0;

  /// Bir aktivite (poligon) için minimum kabul edilen süre (sn).
  /// Çok kısa süreli kayıtların gerçekçi olmayan hızlara yol açmasını engeller.
  static const int minDurationSeconds = 60;

  /// Bir aktivite için maksimum kabul edilen süre (sn).
  /// Uygulamanın açık unutulduğu uç durumları sınırlamak için.
  static const int maxDurationSeconds = 24 * 60 * 60; // 24 saat

  /// Verilen [polygon] için MET tabanlı yaklaşık kalori tahmini.
  ///
  /// - [weightKg] null ise [defaultWeightKg] kullanılır.
  /// - Süre: completedAt - createdAt (en az [minDurationSeconds]).
  /// - Mesafe: poligon çevresi (metre) → km.
  /// - Hız: km/saat → MET seçiminde kullanılır.
  static int estimateForPolygon(
    PolygonModel polygon, {
    double? weightKg,
  }) {
    if (polygon.completedAt == null || polygon.points.length < 2) {
      return 0;
    }

    final distanceM = polygonPerimeterMeters(polygon.points);
    if (distanceM <= 0) return 0;

    final distanceKm = distanceM / 1000.0;

    final rawSeconds =
        polygon.completedAt!.difference(polygon.createdAt).inSeconds;
    final clampedSeconds = rawSeconds.clamp(
      minDurationSeconds,
      maxDurationSeconds,
    );
    final durationHours = clampedSeconds / 3600.0;

    if (durationHours <= 0) return 0;

    final speedKmh = distanceKm / durationHours;
    if (!speedKmh.isFinite || speedKmh <= 0) return 0;

    final met = _metForSpeed(speedKmh);
    final w = (weightKg ?? defaultWeightKg)
        .clamp(minWeightKg, maxWeightKg)
        .toDouble();

    if (met <= 0 || w <= 0) return 0;

    final kcal = met * w * durationHours;
    if (!kcal.isFinite || kcal <= 0) return 0;

    return kcal.round();
  }

  /// Ortalama hız (km/saat) için yaklaşık MET değeri.
  ///
  /// Kaynak: Koşu/yürüyüş için tipik MET aralıkları; basitleştirilmiş tablo.
  static double _metForSpeed(double speedKmh) {
    if (speedKmh < 3.0) {
      // Çok yavaş tempo: hafif aktivite
      return 2.5;
    } else if (speedKmh < 5.5) {
      // Hızlı yürüyüş
      return 3.5;
    } else if (speedKmh < 8.0) {
      // Çok hızlı yürüyüş / hafif koşu
      return 6.0;
    } else if (speedKmh < 11.0) {
      // Orta tempo koşu
      return 9.0;
    } else if (speedKmh < 15.0) {
      // Hızlı koşu
      return 11.0;
    } else {
      // Çok yüksek hızlar için üst sınır
      return 13.0;
    }
  }
}

