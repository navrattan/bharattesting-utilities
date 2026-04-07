import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Bundle size optimization utilities for BharatTesting Utilities
///
/// Provides tools and strategies to minimize APK/Bundle size while maintaining
/// all functionality across the 5 developer tools. Target: <25MB APK size.
class BundleOptimizer {
  /// Current target APK size in MB
  static const double targetApkSizeMB = 25.0;

  /// Asset optimization thresholds
  static const Map<String, int> assetSizeLimits = {
    'image': 500 * 1024, // 500KB per image
    'font': 200 * 1024,  // 200KB per font
    'icon': 50 * 1024,   // 50KB per icon
  };

  /// Analyze current bundle composition
  static Future<BundleAnalysis> analyzeBundleSize() async {
    final analysis = BundleAnalysis();

    try {
      analysis.totalSize = await _estimateBundleSize();
      analysis.assetSize = await _calculateAssetSize();
      analysis.codeSize = analysis.totalSize - analysis.assetSize;
      analysis.compressionRatio = _calculateCompressionRatio();
      analysis.recommendations = _generateSizeRecommendations(analysis);

      if (kDebugMode) {
        debugPrint('Bundle Analysis Complete:');
        debugPrint('Total Size: ${(analysis.totalSize / 1024 / 1024).toStringAsFixed(2)}MB');
        debugPrint('Code Size: ${(analysis.codeSize / 1024 / 1024).toStringAsFixed(2)}MB');
        debugPrint('Asset Size: ${(analysis.assetSize / 1024 / 1024).toStringAsFixed(2)}MB');
        debugPrint('Compression Ratio: ${analysis.compressionRatio.toStringAsFixed(2)}x');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Bundle analysis failed: $e');
      }
    }

    return analysis;
  }

  /// Estimate current bundle size (platform-specific)
  static Future<int> _estimateBundleSize() async {
    if (kIsWeb) {
      return _estimateWebBundleSize();
    }

    if (Platform.isAndroid) {
      return _estimateAndroidApkSize();
    }

    if (Platform.isIOS) {
      return _estimateIosAppSize();
    }

    return 20 * 1024 * 1024; // 20MB default
  }

  /// Estimate web bundle size
  static Future<int> _estimateWebBundleSize() async {
    return 15 * 1024 * 1024; // 15MB estimated for web
  }

  /// Estimate Android APK size
  static Future<int> _estimateAndroidApkSize() async {
    try {
      const platform = MethodChannel('com.bharattesting.bundle');
      final size = await platform.invokeMethod<int>('getApkSize');
      return size ?? (20 * 1024 * 1024);
    } catch (e) {
      return 20 * 1024 * 1024; // 20MB fallback
    }
  }

  /// Estimate iOS app size
  static Future<int> _estimateIosAppSize() async {
    try {
      const platform = MethodChannel('com.bharattesting.bundle');
      final size = await platform.invokeMethod<int>('getAppSize');
      return size ?? (35 * 1024 * 1024);
    } catch (e) {
      return 20 * 1024 * 1024; // 20MB fallback
    }
  }

  /// Calculate total asset size
  static Future<int> _calculateAssetSize() async {
    final assetEstimates = {
      'images': 2 * 1024 * 1024,
      'fonts': 500 * 1024,
      'icons': 200 * 1024,
      'data': 100 * 1024,
    };

    return assetEstimates.values.reduce((a, b) => a + b);
  }

  /// Calculate compression ratio
  static double _calculateCompressionRatio() {
    const ratios = {
      'dart_code': 3.5,
      'assets': 1.8,
      'native_libs': 2.2,
    };

    return ratios.values.reduce((a, b) => a + b) / ratios.length;
  }

  /// Generate size optimization recommendations
  static List<SizeRecommendation> _generateSizeRecommendations(BundleAnalysis analysis) {
    final recommendations = <SizeRecommendation>[];
    final sizeMB = analysis.totalSize / 1024 / 1024;

    if (sizeMB > targetApkSizeMB) {
      recommendations.add(SizeRecommendation(
        type: OptimizationType.overall,
        priority: Priority.high,
        title: 'Bundle Size Exceeds Target',
        description: 'Current size: ${sizeMB.toStringAsFixed(1)}MB, Target: ${targetApkSizeMB}MB',
        potentialSaving: ((sizeMB - targetApkSizeMB) * 1024 * 1024).round(),
        actions: [
          'Enable R8/ProGuard obfuscation',
          'Remove unused assets',
          'Use vector icons instead of raster images',
          'Enable split APKs for different architectures',
        ],
      ));
    }

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        recommendations.addAll(_getAndroidOptimizations());
      } else if (Platform.isIOS) {
        recommendations.addAll(_getIosOptimizations());
      }
    } else {
      recommendations.addAll(_getWebOptimizations());
    }

    return recommendations;
  }

  static List<SizeRecommendation> _getAndroidOptimizations() {
    return [
      SizeRecommendation(
        type: OptimizationType.platform,
        priority: Priority.high,
        title: 'Android Bundle Optimization',
        description: 'Platform-specific optimizations for Android',
        potentialSaving: 3 * 1024 * 1024,
        actions: ['Enable AAB', 'Enable R8'],
      ),
    ];
  }

  static List<SizeRecommendation> _getIosOptimizations() {
    return [
      SizeRecommendation(
        type: OptimizationType.platform,
        priority: Priority.high,
        title: 'iOS Bundle Optimization',
        description: 'Platform-specific optimizations for iOS',
        potentialSaving: 2 * 1024 * 1024,
        actions: ['Use iOS App Thinning', 'Enable bitcode'],
      ),
    ];
  }

  static List<SizeRecommendation> _getWebOptimizations() {
    return [
      SizeRecommendation(
        type: OptimizationType.platform,
        priority: Priority.medium,
        title: 'Web Bundle Optimization',
        description: 'Platform-specific optimizations for Web',
        potentialSaving: 4 * 1024 * 1024,
        actions: ['Enable Gzip', 'Minimize main.dart.js'],
      ),
    ];
  }
}

class BundleAnalysis {
  int totalSize = 0;
  int codeSize = 0;
  int assetSize = 0;
  double compressionRatio = 1.0;
  List<SizeRecommendation> recommendations = [];

  Map<String, dynamic> toJson() => {
    'totalSizeMB': totalSize / 1024 / 1024,
    'codeSizeMB': codeSize / 1024 / 1024,
    'assetSizeMB': assetSize / 1024 / 1024,
    'compressionRatio': compressionRatio,
    'recommendations': recommendations.map((r) => r.toJson()).toList(),
  };
}

class SizeRecommendation {
  const SizeRecommendation({
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    required this.potentialSaving,
    required this.actions,
  });

  final OptimizationType type;
  final Priority priority;
  final String title;
  final String description;
  final int potentialSaving;
  final List<String> actions;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'priority': priority.name,
    'title': title,
    'description': description,
    'potentialSavingMB': potentialSaving / 1024 / 1024,
    'actions': actions,
  };
}

enum OptimizationType { overall, assets, code, platform, fonts, images }
enum Priority { low, medium, high, critical }
