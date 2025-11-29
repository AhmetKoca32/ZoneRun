import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Gray Scale
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF2A2A2A);
  static const Color lightGray = Color(0xFF3A3A3A);

  // Gradient Colors for Home Page
  static const Color gradientDark = Color(0xFF1A1A1A);
  static const Color gradientMedium = Color(
    0xFF151515,
  ); // Softer, darker medium gray
  static const Color gradientLight = Color(
    0xFF1A1A1A,
  ); // Softer, darker light gray (almost same as dark)

  // Smooth Gradient Colors (for soft transitions)
  static const Color gradientStep1 = Color(0xFF020202);
  static const Color gradientStep2 = Color(0xFF040404);
  static const Color gradientStep3 = Color(0xFF060606);
  static const Color gradientStep4 = Color(0xFF080808);
  static const Color gradientStep5 = Color(0xFF0A0A0A);
  static const Color gradientStep6 = Color(0xFF0C0C0C);
  static const Color gradientStep7 = Color(0xFF0E0E0E);
  static const Color gradientStep8 = Color(0xFF101010);
  static const Color gradientStep9 = Color(0xFF121212);
  static const Color gradientStep10 = Color(0xFF141414);

  // Overlay
  static Color overlayDark = black.withOpacity(0.6);

  // Opacity Colors (for consistent opacity usage)
  static Color whiteWithOpacity70 = white.withOpacity(0.7);
  static Color whiteWithOpacity80 = white.withOpacity(0.8);
  static Color whiteWithOpacity15 = white.withOpacity(0.15);
  static Color whiteWithOpacity30 = white.withOpacity(0.3);
  static Color blackWithOpacity50 = black.withOpacity(0.5);

  // Getter for gradient colors list (legacy)
  static List<Color> get homeGradientColors => [
    black, // Start with pure black at top
    gradientMedium, // Medium gray in the middle
    gradientLight, // End with light gray at bottom
  ];

  // Getter for smooth gradient colors list (ultra smooth with more steps)
  static List<Color> get smoothGradientColors => [
    black,
    gradientStep1,
    gradientStep2,
    gradientStep3,
    gradientStep4,
    gradientStep5,
    gradientStep6,
    gradientStep7,
    gradientStep8,
    gradientStep9,
    gradientStep10,
  ];

  // Getter for smooth gradient stops (evenly distributed for ultra smooth transition)
  static List<double> get smoothGradientStops => [
    0.0,
    0.1,
    0.2,
    0.3,
    0.4,
    0.5,
    0.6,
    0.7,
    0.8,
    0.9,
    1.0,
  ];

  // Circle Gradient Colors (for metric circle)
  static List<Color> get circleGradientColors => [
    mediumGray,
    lightGray.withOpacity(0.3),
    mediumGray,
  ];

  // Circle Gradient Stops
  static List<double> get circleGradientStops => [0.0, 0.5, 1.0];

  // Circle Gradient
  static LinearGradient get circleGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: circleGradientColors,
    stops: circleGradientStops,
  );
}
