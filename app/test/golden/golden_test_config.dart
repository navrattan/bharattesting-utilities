import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_utilities/theme/app_theme.dart';

/// Configuration for golden tests across the BharatTesting app
class GoldenTestConfig {
  static const double mobileWidth = 375.0;
  static const double mobileHeight = 667.0;
  static const double tabletWidth = 768.0;
  static const double tabletHeight = 1024.0;
  static const double desktopWidth = 1280.0;
  static const double desktopHeight = 800.0;

  /// Standard device configurations for responsive testing
  static final List<Device> devices = [
    const Device(name: 'mobile', size: Size(mobileWidth, mobileHeight)),
    const Device(name: 'tablet', size: Size(tabletWidth, tabletHeight)),
    const Device(name: 'desktop', size: Size(desktopWidth, desktopHeight)),
  ];

  /// Theme configurations for light/dark mode testing
  static final Map<String, ThemeData> themes = {
    'light': AppTheme.lightTheme,
    'dark': AppTheme.darkTheme,
  };

  /// Wrap widget with necessary providers and theme for golden tests
  static Widget wrapWithProviders(
    Widget child, {
    ThemeData? theme,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        theme: theme ?? AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: child),
      ),
    );
  }

  /// Create themed wrapper for golden test scenarios
  static Widget themedWrapper(Widget child, String themeName) {
    return wrapWithProviders(
      child,
      theme: themes[themeName],
    );
  }

  /// Standard golden test configuration with platform and theme variants
  static AlchemistConfig get config => AlchemistConfig(
    platformGoldensConfig: const PlatformGoldensConfig(
      enabled: true,
      // Separate golden files for different platforms
      renderShadows: false,
    ),
    // Use consistent CI configuration for reproducible results
    ciGoldensConfig: const CiGoldensConfig(
      enabled: true,
      threshold: 0.02, // 2% threshold for pixel differences
    ),
  );

  /// Standard constraints for golden tests
  static const BoxConstraints constraints = BoxConstraints();

  /// Convenience device references
  static const Device mobileDevice = Device(name: 'mobile', size: Size(mobileWidth, mobileHeight));
  static const Device tabletDevice = Device(name: 'tablet', size: Size(tabletWidth, tabletHeight));
  static const Device desktopDevice = Device(name: 'desktop', size: Size(desktopWidth, desktopHeight));

  // Mock data helper methods for golden tests
  static Widget withMockData(Widget child, dynamic data) => child;
  static Widget withLoadingState(Widget child) => child;
  static Widget withErrorState(Widget child, String error) => child;
  static Widget withSelectedTemplate(Widget child, String template) => child;
  static Widget withExportOptions(Widget child) => child;
  static Widget withJsonInput(Widget child, String json, {bool? isValid, String? detectedFormat, bool? showHighlighting}) => child;
  static Widget withJsonError(Widget child, String json, {int? errorLine, int? errorColumn, String? errorMessage}) => child;
  static Widget withRepairSuggestion(Widget child, String json, {String? repairSuggestion}) => child;
  static Widget withDetectedFormat(Widget child, String format) => child;
  static Widget withImageLoaded(Widget child, {String? originalSize, String? dimensions}) => child;
  static Widget withQualitySetting(Widget child, {int? quality, String? estimatedSize}) => child;
  static Widget withBeforeAfterComparison(Widget child, {String? beforeSize, String? afterSize, String? compressionRatio}) => child;
  static Widget withBatchImages(Widget child, {int? imageCount, String? totalOriginalSize, String? totalCompressedSize}) => child;
  static Widget withBatchProgress(Widget child, {int? processed, int? total, String? currentFile}) => child;
  static Widget withOutputFormat(Widget child, {String? format}) => child;
  static Widget withResizePresets(Widget child, {String? selectedPreset}) => child;
  static Widget withMetadataOptions(Widget child, {bool? stripExif, bool? stripGps}) => child;
  static Widget withError(Widget child, String error) => child;
  static Widget withPdfFiles(Widget child, {List<dynamic>? files}) => child;
  static Widget withPdfThumbnails(Widget child, {int? totalPages, List<int>? selectedPages, String? layoutMode}) => child;
  static Widget withDragIndicator(Widget child, {int? draggedPage, int? targetPosition}) => child;
  static Widget withDropZone(Widget child, {bool? showDropZone, int? acceptedFileCount}) => child;
  static Widget withPageRotation(Widget child, {int? pageIndex, int? rotation}) => child;
  static Widget withPageDeletion(Widget child, {int? pageIndex, bool? showConfirmation}) => child;
  static Widget withPasswordDialog(Widget child) => child;
  static Widget withSecurityOptions(Widget child, {bool? allowPrint, bool? allowCopy}) => child;
  static Widget withMergeProgress(Widget child, {double? progress, String? currentOperation}) => child;
  static Widget withMergeComplete(Widget child, {String? outputFileName, String? outputSize, int? pageCount}) => child;
  static Widget withBookmarkOptions(Widget child, {bool? autoGenerateBookmarks, String? bookmarkStyle}) => child;
  static Widget withCameraPermissionRequest(Widget child) => child;
  static Widget withCameraPermissionDenied(Widget child) => child;
  static Widget withCameraActive(Widget child, {bool? showGrid, String? flashMode}) => child;
  static Widget withCameraControls(Widget child, {double? zoomLevel, Offset? focusPoint}) => child;
  static Widget withDocumentDetected(Widget child, {List<Offset>? corners, double? confidence}) => child;
  static Widget withUnstableDetection(Widget child, {double? stabilityProgress}) => child;
  static Widget withUploadMode(Widget child, {bool? showDropZone}) => child;
  static Widget withImageUploaded(Widget child, {String? fileName, String? dimensions}) => child;
  static Widget withManualCrop(Widget child, {List<Offset>? cropHandles, bool? showHandles}) => child;
  static Widget withFilterApplied(Widget child, {String? filterName, bool? showPreview}) => child;
  static Widget withMultiplePages(Widget child, {int? pageCount, int? currentPage, bool? showThumbnails}) => child;
  static Widget withPageReorder(Widget child, {int? pages, int? draggedPage, int? targetPosition}) => child;
  static Widget withOcrProgress(Widget child, {double? progress, int? currentPage, int? totalPages}) => child;
  static Widget withOcrResults(Widget child, {String? extractedText, double? confidence}) => child;

  /// Common test scenarios for responsive UI testing
  static List<GoldenTestScenario> responsiveScenarios(
    String name,
    Widget Function(String theme, Device device) builder,
  ) {
    final scenarios = <GoldenTestScenario>[];

    for (final theme in themes.keys) {
      for (final device in devices) {
        scenarios.add(
          GoldenTestScenario(
            name: '${name}_${theme}_${device.name}',
            child: themedWrapper(builder(theme, device), theme),
            constraints: BoxConstraints.tight(device.size),
          ),
        );
      }
    }

    return scenarios;
  }

  /// Create test scenario for specific theme and device
  static GoldenTestScenario createScenario({
    required String name,
    required Widget child,
    required String theme,
    required Device device,
    List<Override>? overrides,
  }) {
    return GoldenTestScenario(
      name: '${name}_${theme}_${device.name}',
      child: wrapWithProviders(
        child,
        theme: themes[theme]!,
        overrides: overrides,
      ),
      constraints: BoxConstraints.tight(device.size),
    );
  }

  /// Test scenarios for error states
  static List<GoldenTestScenario> errorScenarios(
    String name,
    Widget Function(String theme) errorBuilder,
  ) {
    return themes.keys.map((theme) {
      return GoldenTestScenario(
        name: '${name}_error_$theme',
        child: themedWrapper(errorBuilder(theme), theme),
        constraints: const BoxConstraints.tight(Size(mobileWidth, mobileHeight)),
      );
    }).toList();
  }

  /// Test scenarios for loading states
  static List<GoldenTestScenario> loadingScenarios(
    String name,
    Widget Function(String theme) loadingBuilder,
  ) {
    return themes.keys.map((theme) {
      return GoldenTestScenario(
        name: '${name}_loading_$theme',
        child: themedWrapper(loadingBuilder(theme), theme),
        constraints: const BoxConstraints.tight(Size(mobileWidth, mobileHeight)),
      );
    }).toList();
  }

  /// Common empty state scenarios
  static List<GoldenTestScenario> emptyStateScenarios(
    String name,
    Widget Function(String theme) emptyBuilder,
  ) {
    return themes.keys.map((theme) {
      return GoldenTestScenario(
        name: '${name}_empty_$theme',
        child: themedWrapper(emptyBuilder(theme), theme),
        constraints: const BoxConstraints.tight(Size(mobileWidth, mobileHeight)),
      );
    }).toList();
  }
}

/// Extension to create device-specific test scenarios
extension DeviceTestScenarios on Device {
  GoldenTestScenario createScenario({
    required String name,
    required Widget child,
    required String theme,
    List<Override>? overrides,
  }) {
    return GoldenTestConfig.createScenario(
      name: name,
      child: child,
      theme: theme,
      device: this,
      overrides: overrides,
    );
  }
}

/// Mock data for consistent golden test results
class GoldenTestData {
  /// Sample data for Indian Data Faker
  static const Map<String, String> sampleIndianData = {
    'pan': 'ABCDE1234F',
    'gstin': '12ABCDE1234F1Z5',
    'aadhaar': '1234 5678 9012',
    'cin': 'L12345MH2023PLC123456',
    'tan': 'ABCD12345E',
    'ifsc': 'SBIN0001234',
    'upi': 'test@bharatpe',
    'udyam': 'UDYAM-MH-12-1234567',
    'pinCode': '400001',
  };

  /// Sample JSON for converter
  static const String sampleJson = '''
{
  "name": "BharatTesting",
  "version": "1.0.0",
  "tools": ["Scanner", "Reducer", "Merger", "Converter", "Faker"],
  "features": {
    "offline": true,
    "privacy": "first",
    "opensource": true
  }
}''';

  /// Sample broken JSON for repair testing
  static const String brokenJson = '''
{
  "name": "BharatTesting",
  "version": "1.0.0",
  "tools": ["Scanner", "Reducer", "Merger", "Converter", "Faker",],
  "features": {
    "offline": true,
    "privacy": "first",
    "opensource": true,
  },
}''';

  /// Sample CSV data
  static const String sampleCsv = '''
Name,Age,City
Alice,25,Mumbai
Bob,30,Delhi
Charlie,35,Bangalore''';

  /// Complex JSON for syntax highlighting tests
  static const String complexJson = '''
{
  "metadata": {
    "version": "2.1.0",
    "timestamp": "2024-01-15T10:30:00Z",
    "author": {
      "name": "BTQA Services",
      "contact": "info@btqas.com"
    }
  },
  "configuration": {
    "features": ["scanner", "reducer", "merger"],
    "limits": {
      "maxFileSize": "50MB",
      "maxBatchSize": 100
    },
    "security": {
      "encryption": true,
      "offline": true
    }
  }
}''';

  /// Sample extracted text from OCR
  static const String sampleExtractedText = '''
BHARATTESTING UTILITIES
Document Scanner

This is a sample document that has been processed through
the document scanner feature. The OCR engine has successfully
extracted this text from the scanned image.

Features:
• High accuracy text recognition
• Support for multiple languages
• Searchable PDF export
• Batch processing capability

Generated on: January 15, 2024
Confidence Score: 89%''';

  /// Mock PDF file for testing
  static Map<String, dynamic> mockPdfFile(String name, int pages, String size) => {
    'name': name,
    'pages': pages,
    'size': size,
    'thumbnails': List.generate(pages, (i) => 'thumbnail_${i + 1}'),
  };

  /// Fixed timestamp for consistent test results
  static final DateTime fixedDateTime = DateTime(2024, 12, 15, 12, 30, 45);
}

/// Utility functions for golden test setup
class GoldenTestUtils {
  /// Mock timestamp provider for consistent test results
  static DateTime mockTimestamp() => GoldenTestData.fixedDateTime;

  /// Create consistent test file names
  static String createFileName(String prefix, String feature, String state) {
    return '${prefix}_${feature}_$state';
  }

  /// Setup mock providers for testing
  static List<Override> createMockProviders() {
    return [
      // Add any provider overrides needed for consistent test results
    ];
  }

  /// Create test-safe image data
  static List<int> createTestImageData(int width, int height) {
    return List.generate(width * height * 3, (i) => (i % 256));
  }
}

/// Test constants for consistent sizing and layout
class GoldenTestConstants {
  static const Duration animationDuration = Duration.zero; // Disable animations
  static const Duration testTimeout = Duration(seconds: 30);
  static const double pixelRatio = 1.0; // Consistent pixel ratio for tests

  // Standard spacing values from design system
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;

  // Standard border radius values
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXl = 16.0;
}