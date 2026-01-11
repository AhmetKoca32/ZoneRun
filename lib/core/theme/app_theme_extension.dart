import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Custom theme extension for ZoneRun app
/// Provides app-specific colors and gradients that adapt to theme
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  // Base Colors
  final Color primaryBackground;
  final Color secondaryBackground;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  // Accent Colors
  final Color accent;
  final Color border;
  final Color divider;

  // Gradient Colors
  final List<Color> backgroundGradientColors;
  final List<Color> smoothGradientColors;

  // Circle/Metric Colors
  final List<Color> circleGradientColors;

  const AppThemeExtension({
    required this.primaryBackground,
    required this.secondaryBackground,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.border,
    required this.divider,
    required this.backgroundGradientColors,
    required this.smoothGradientColors,
    required this.circleGradientColors,
  });

  /// Dark theme extension
  factory AppThemeExtension.dark() {
    return AppThemeExtension(
      primaryBackground: AppColors.black,
      secondaryBackground: AppColors.darkGray,
      surface: AppColors.mediumGray,
      textPrimary: AppColors.white,
      textSecondary: AppColors.whiteWithOpacity80,
      textTertiary: AppColors.whiteWithOpacity70,
      accent: AppColors.white,
      border: AppColors.whiteWithOpacity30,
      divider: AppColors.whiteWithOpacity15,
      backgroundGradientColors: [
        AppColors.black,
        AppColors.gradientStep1,
        AppColors.gradientStep2,
        AppColors.gradientStep3,
        AppColors.gradientStep4,
        AppColors.gradientStep5,
        AppColors.gradientStep6,
        AppColors.gradientStep7,
        AppColors.gradientStep8,
        AppColors.gradientStep9,
        AppColors.gradientStep10,
      ],
      smoothGradientColors: [
        AppColors.black,
        AppColors.gradientStep1,
        AppColors.gradientStep2,
        AppColors.gradientStep3,
        AppColors.gradientStep4,
        AppColors.gradientStep5,
        AppColors.gradientStep6,
        AppColors.gradientStep7,
        AppColors.gradientStep8,
        AppColors.gradientStep9,
        AppColors.gradientStep10,
      ],
      circleGradientColors: [
        AppColors.mediumGray,
        AppColors.lightGray,
        AppColors.mediumGray,
      ],
    );
  }

  /// Light theme extension
  factory AppThemeExtension.light() {
    return AppThemeExtension(
      primaryBackground: Color(0xFFFFFFFF), // White
      secondaryBackground: Color(0xFFF5F5F5), // Light gray
      surface: Color(0xFFE0E0E0), // Lighter gray
      textPrimary: Color(0xFF000000), // Black
      textSecondary: Color(0xFF1A1A1A), // Dark gray
      textTertiary: Color(0xFF2A2A2A), // Medium gray
      accent: Color(0xFF000000), // Black
      border: Color(0xFFE0E0E0), // Light border
      divider: Color(0xFFF0F0F0), // Very light divider
      backgroundGradientColors: [
        Color(0xFFFFFFFF), // White
        Color(0xFFFAFAFA),
        Color(0xFFF5F5F5),
        Color(0xFFF0F0F0),
        Color(0xFFEBEBEB),
        Color(0xFFE6E6E6),
        Color(0xFFE1E1E1),
        Color(0xFFDCDCDC),
        Color(0xFFD7D7D7),
        Color(0xFFD2D2D2),
        Color(0xFFCDCDCD),
      ],
      smoothGradientColors: [
        Color(0xFFFFFFFF),
        Color(0xFFFAFAFA),
        Color(0xFFF5F5F5),
        Color(0xFFF0F0F0),
        Color(0xFFEBEBEB),
        Color(0xFFE6E6E6),
        Color(0xFFE1E1E1),
        Color(0xFFDCDCDC),
        Color(0xFFD7D7D7),
        Color(0xFFD2D2D2),
        Color(0xFFCDCDCD),
      ],
      circleGradientColors: [
        Color(0xFFFFFFFF), // merkezde beyaz
        Color(0xFFF6F6F6), // orta halkada soft gri
        Color(0xFFE5E5E5), // dış kenarda biraz daha gri
      ],
    );
  }

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primaryBackground,
    Color? secondaryBackground,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? border,
    Color? divider,
    List<Color>? backgroundGradientColors,
    List<Color>? smoothGradientColors,
    List<Color>? circleGradientColors,
  }) {
    return AppThemeExtension(
      primaryBackground: primaryBackground ?? this.primaryBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      backgroundGradientColors: backgroundGradientColors ?? this.backgroundGradientColors,
      smoothGradientColors: smoothGradientColors ?? this.smoothGradientColors,
      circleGradientColors: circleGradientColors ?? this.circleGradientColors,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      primaryBackground: Color.lerp(primaryBackground, other.primaryBackground, t)!,
      secondaryBackground: Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      backgroundGradientColors: _lerpColorList(backgroundGradientColors, other.backgroundGradientColors, t),
      smoothGradientColors: _lerpColorList(smoothGradientColors, other.smoothGradientColors, t),
      circleGradientColors: _lerpColorList(circleGradientColors, other.circleGradientColors, t),
    );
  }

  List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final result = <Color>[];
    final maxLength = a.length > b.length ? a.length : b.length;
    
    for (int i = 0; i < maxLength; i++) {
      final colorA = i < a.length ? a[i] : a.last;
      final colorB = i < b.length ? b[i] : b.last;
      result.add(Color.lerp(colorA, colorB, t)!);
    }
    
    return result;
  }

  /// Helper method to get background gradient
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: smoothGradientColors,
    stops: AppColors.smoothGradientStops,
    tileMode: TileMode.clamp,
  );

  /// Helper method to get circle gradient
  LinearGradient get circleGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: circleGradientColors,
    stops: AppColors.circleGradientStops,
  );
}
