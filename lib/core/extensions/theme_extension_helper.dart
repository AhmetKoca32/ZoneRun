import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';

/// Helper extension to easily access AppThemeExtension from BuildContext
extension ThemeExtensionHelper on BuildContext {
  /// Get the AppThemeExtension from current theme
  AppThemeExtension get appTheme {
    return Theme.of(this).extension<AppThemeExtension>() ?? AppThemeExtension.dark();
  }
}
