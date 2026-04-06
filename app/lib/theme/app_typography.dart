/// BharatTesting app typography system - Material 3 text styles
library app_typography;

import 'dart:ui';
import 'package:flutter/material.dart';

/// Typography system for BharatTesting Utilities
///
/// Uses system fonts with fallbacks for better performance and cross-platform consistency:
/// - Sans-serif: System default (SF Pro on iOS, Roboto on Android, Segoe UI on Windows)
/// - Monospace: Courier New, monospace (for code blocks and identifiers)
class AppTypography {
  const AppTypography._();

  // ============================================================================
  // FONT FAMILIES
  // ============================================================================

  /// System default sans-serif font family
  static const List<String> systemFont = [
    '-apple-system', // iOS/macOS
    'BlinkMacSystemFont', // macOS
    'Segoe UI', // Windows
    'Roboto', // Android
    'Helvetica Neue', // Fallback
    'Arial', // Universal fallback
    'sans-serif', // Generic fallback
  ];

  /// Monospace font family for code and identifiers
  static const List<String> monospaceFont = [
    'SF Mono', // iOS/macOS
    'Monaco', // macOS
    'Cascadia Code', // Windows
    'Roboto Mono', // Android
    'Courier New', // Universal fallback
    'monospace', // Generic fallback
  ];

  // ============================================================================
  // TEXT THEMES
  // ============================================================================

  /// Light mode text theme
  static TextTheme get lightTextTheme => const TextTheme(
        // Display styles
        displayLarge: TextStyle(
          fontFamily: 'System',
          fontSize: 57.0,
          height: 1.12,
          letterSpacing: -0.25,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          fontFamily: 'System',
          fontSize: 45.0,
          height: 1.16,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          fontFamily: 'System',
          fontSize: 36.0,
          height: 1.22,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
        ),

        // Headline styles
        headlineLarge: TextStyle(
          fontFamily: 'System',
          fontSize: 32.0,
          height: 1.25,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'System',
          fontSize: 28.0,
          height: 1.29,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'System',
          fontSize: 24.0,
          height: 1.33,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
        ),

        // Title styles
        titleLarge: TextStyle(
          fontFamily: 'System',
          fontSize: 22.0,
          height: 1.27,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontFamily: 'System',
          fontSize: 16.0,
          height: 1.5,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontFamily: 'System',
          fontSize: 14.0,
          height: 1.43,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500,
        ),

        // Body styles
        bodyLarge: TextStyle(
          fontFamily: 'System',
          fontSize: 16.0,
          height: 1.5,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'System',
          fontSize: 14.0,
          height: 1.43,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontFamily: 'System',
          fontSize: 12.0,
          height: 1.33,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w400,
        ),

        // Label styles
        labelLarge: TextStyle(
          fontFamily: 'System',
          fontSize: 14.0,
          height: 1.43,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          fontFamily: 'System',
          fontSize: 12.0,
          height: 1.33,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontFamily: 'System',
          fontSize: 11.0,
          height: 1.45,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500,
        ),
      );

  /// Dark mode text theme (same metrics, different colors applied by theme)
  static TextTheme get darkTextTheme => lightTextTheme;

  // ============================================================================
  // CUSTOM TEXT STYLES
  // ============================================================================

  /// Code block style (monospace)
  static const TextStyle codeBlock = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14.0,
    height: 1.4,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Inline code style
  static const TextStyle codeInline = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13.0,
    height: 1.2,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Tool card title style
  static const TextStyle toolCardTitle = TextStyle(
    fontSize: 20.0,
    height: 1.3,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w600,
  );

  /// Tool card description style
  static const TextStyle toolCardDescription = TextStyle(
    fontSize: 14.0,
    height: 1.4,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w400,
  );

  /// Identifier display style (PAN, GSTIN, etc.)
  static const TextStyle identifier = TextStyle(
    fontFamily: 'monospace',
    fontSize: 16.0,
    height: 1.2,
    letterSpacing: 1.0,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Footer text style
  static const TextStyle footer = TextStyle(
    fontSize: 12.0,
    height: 1.33,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  /// Error message style
  static const TextStyle errorMessage = TextStyle(
    fontSize: 14.0,
    height: 1.4,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w500,
  );

  /// Success message style
  static const TextStyle successMessage = TextStyle(
    fontSize: 14.0,
    height: 1.4,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w500,
  );
}