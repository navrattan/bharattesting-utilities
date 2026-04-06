/// BharatTesting app color system - Material 3 with dark mode default
library app_colors;

import 'dart:ui';

/// Color tokens for BharatTesting Utilities
///
/// Primary: Blue (#58A6FF dark / #0969DA light) - GitHub-inspired
/// Secondary: Green (#3FB950 / #1A7F37) - Success/Generate actions
/// Background: Dark GitHub colors (#0D1117 / #FFFFFF)
class AppColors {
  const AppColors._();

  // ============================================================================
  // DARK MODE COLORS (Default)
  // ============================================================================

  /// Primary brand color - blue tones
  static const Color primaryDark = Color(0xFF58A6FF);
  static const Color onPrimaryDark = Color(0xFF0D1117);
  static const Color primaryContainerDark = Color(0xFF1C2128);
  static const Color onPrimaryContainerDark = Color(0xFF58A6FF);

  /// Secondary - green for success/generate actions
  static const Color secondaryDark = Color(0xFF3FB950);
  static const Color onSecondaryDark = Color(0xFF0D1117);
  static const Color secondaryContainerDark = Color(0xFF1A7F37);
  static const Color onSecondaryContainerDark = Color(0xFF3FB950);

  /// Background & Surface
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color onBackgroundDark = Color(0xFFF0F6FC);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color onSurfaceDark = Color(0xFFF0F6FC);
  static const Color surfaceVariantDark = Color(0xFF21262D);
  static const Color onSurfaceVariantDark = Color(0xFF8B949E);

  /// Error states
  static const Color errorDark = Color(0xFFF85149);
  static const Color onErrorDark = Color(0xFF0D1117);
  static const Color errorContainerDark = Color(0xFF8E1538);
  static const Color onErrorContainerDark = Color(0xFFF85149);

  /// Outline & dividers
  static const Color outlineDark = Color(0xFF30363D);
  static const Color outlineVariantDark = Color(0xFF21262D);

  /// Inverse colors for contrast
  static const Color inverseSurfaceDark = Color(0xFFF0F6FC);
  static const Color onInverseSurfaceDark = Color(0xFF0D1117);
  static const Color inversePrimaryDark = Color(0xFF0969DA);

  // ============================================================================
  // LIGHT MODE COLORS
  // ============================================================================

  /// Primary brand color - blue tones
  static const Color primaryLight = Color(0xFF0969DA);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFDDF4FF);
  static const Color onPrimaryContainerLight = Color(0xFF0969DA);

  /// Secondary - green for success/generate actions
  static const Color secondaryLight = Color(0xFF1A7F37);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFDCFFE4);
  static const Color onSecondaryContainerLight = Color(0xFF1A7F37);

  /// Background & Surface
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF1C2128);
  static const Color surfaceLight = Color(0xFFF6F8FA);
  static const Color onSurfaceLight = Color(0xFF1C2128);
  static const Color surfaceVariantLight = Color(0xFFF3F4F6);
  static const Color onSurfaceVariantLight = Color(0xFF656D76);

  /// Error states
  static const Color errorLight = Color(0xFFCF222E);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFEBEE);
  static const Color onErrorContainerLight = Color(0xFFCF222E);

  /// Outline & dividers
  static const Color outlineLight = Color(0xFFD0D7DE);
  static const Color outlineVariantLight = Color(0xFFF3F4F6);

  /// Inverse colors for contrast
  static const Color inverseSurfaceLight = Color(0xFF1C2128);
  static const Color onInverseSurfaceLight = Color(0xFFFFFFFF);
  static const Color inversePrimaryLight = Color(0xFF58A6FF);

  // ============================================================================
  // SEMANTIC COLORS (Both modes)
  // ============================================================================

  /// Success colors (same as secondary)
  static const Color successDark = secondaryDark;
  static const Color successLight = secondaryLight;

  /// Warning colors
  static const Color warningDark = Color(0xFFD29922);
  static const Color warningLight = Color(0xFFBF8700);

  /// Info colors (same as primary)
  static const Color infoDark = primaryDark;
  static const Color infoLight = primaryLight;

  // ============================================================================
  // CUSTOM TOOL COLORS
  // ============================================================================

  /// Document Scanner accent
  static const Color documentScannerDark = Color(0xFF7C3AED);
  static const Color documentScannerLight = Color(0xFF6D28D9);

  /// Image Reducer accent
  static const Color imageReducerDark = Color(0xFFEC4899);
  static const Color imageReducerLight = Color(0xFFDB2777);

  /// PDF Merger accent
  static const Color pdfMergerDark = Color(0xFFF59E0B);
  static const Color pdfMergerLight = Color(0xFFD97706);

  /// JSON Converter accent
  static const Color jsonConverterDark = Color(0xFF10B981);
  static const Color jsonConverterLight = Color(0xFF059669);

  /// Data Faker accent
  static const Color dataFakerDark = Color(0xFFF97316);
  static const Color dataFakerLight = Color(0xFFEA580C);
}