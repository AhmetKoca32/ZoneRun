/// Kalori tahmini için sabitler ve formül.
///
/// Kaynak: Koşu/yürüyüş enerji harcaması literatüründe vücut ağırlığı × mesafe
/// formülü yaygın kullanılır. Koşu için ~0.97–1.03 kcal/(kg·km) (hızdan bağımsız
/// kabul eden çalışmalar mevcut). Varsayılan kilo girilmezse tahmin için kullanılır.
class CalorieConstants {
  CalorieConstants._();

  /// Kullanıcı kilo girmemişse kalori tahmininde kullanılan varsayılan kilo (kg).
  static const double defaultWeightKg = 70.0;

  /// Koşu/yürüyüş için kcal per kg body weight per km.
  /// ~0.97–1.0 literatür değerleri; 1.0 basit ve yaygın kullanım.
  static const double kcalPerKgPerKm = 1.0;

  /// Mesafe (km) ve kilo (kg) ile yaklaşık kalori tahmini.
  /// [weightKg] null ise [defaultWeightKg] kullanılır.
  static int estimateCalories(double distanceKm, [double? weightKg]) {
    final w = weightKg ?? defaultWeightKg;
    if (w <= 0 || distanceKm <= 0) return 0;
    return (w * distanceKm * kcalPerKgPerKm).round();
  }
}
