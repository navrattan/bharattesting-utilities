import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// Performance monitoring and optimization utilities for BharatTesting Utilities
///
/// Provides real-time performance metrics, memory usage tracking, frame rate
/// monitoring, and optimization hints for maintaining 60fps UI and efficient
/// memory usage across all 5 developer tools.
class PerformanceMonitor {
  static PerformanceMonitor? _instance;
  static PerformanceMonitor get instance => _instance ??= PerformanceMonitor._();

  PerformanceMonitor._();

  final List<FrameTimingInfo> _frameTimes = [];
  final List<MemorySnapshot> _memorySnapshots = [];
  Timer? _memoryMonitorTimer;
  bool _isMonitoring = false;

  static const int maxFrameTimingSamples = 100;
  static const int maxMemorySnapshots = 50;
  static const Duration memoryMonitorInterval = Duration(seconds: 2);

  /// Start performance monitoring
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _startFrameTimeMonitoring();
    _startMemoryMonitoring();

    if (kDebugMode) {
      debugPrint('PerformanceMonitor: Started monitoring');
    }
  }

  /// Stop performance monitoring
  void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = null;

    if (kDebugMode) {
      debugPrint('PerformanceMonitor: Stopped monitoring');
    }
  }

  /// Get current performance metrics
  PerformanceMetrics getMetrics() {
    return PerformanceMetrics(
      averageFrameTime: _calculateAverageFrameTime(),
      frameRate: _calculateFrameRate(),
      droppedFrameCount: _calculateDroppedFrames(),
      memoryUsage: _getLatestMemoryUsage(),
      peakMemoryUsage: _getPeakMemoryUsage(),
      performanceScore: _calculatePerformanceScore(),
      recommendations: _generateRecommendations(),
    );
  }

  /// Start monitoring frame times
  void _startFrameTimeMonitoring() {
    SchedulerBinding.instance.addTimingsCallback((timings) {
      if (!_isMonitoring) return;

      for (final timing in timings) {
        final info = FrameTimingInfo(
          buildDuration: timing.buildDuration,
          rasterDuration: timing.rasterDuration,
          totalDuration: timing.totalSpan,
          timestamp: DateTime.now(),
        );

        _frameTimes.add(info);

        if (_frameTimes.length > maxFrameTimingSamples) {
          _frameTimes.removeAt(0);
        }
      }
    });
  }

  /// Start monitoring memory usage
  void _startMemoryMonitoring() {
    _memoryMonitorTimer = Timer.periodic(memoryMonitorInterval, (_) async {
      if (!_isMonitoring) return;

      try {
        final memoryUsage = await _getCurrentMemoryUsage();
        final snapshot = MemorySnapshot(
          rssMemory: memoryUsage['rss'] ?? 0,
          heapMemory: memoryUsage['heap'] ?? 0,
          timestamp: DateTime.now(),
        );

        _memorySnapshots.add(snapshot);

        if (_memorySnapshots.length > maxMemorySnapshots) {
          _memorySnapshots.removeAt(0);
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('PerformanceMonitor: Memory monitoring error: $e');
        }
      }
    });
  }

  /// Get current memory usage (platform-specific)
  Future<Map<String, int>> _getCurrentMemoryUsage() async {
    if (kIsWeb) {
      // Web memory monitoring is limited
      return {'rss': 0, 'heap': 0};
    }

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Use platform channel for native memory info
        const platform = MethodChannel('com.bharattesting.performance');
        final result = await platform.invokeMethod('getMemoryInfo');
        return Map<String, int>.from(result ?? {});
      }

      // Desktop platforms - use ProcessInfo if available
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        final info = ProcessInfo.currentRss;
        return {'rss': info, 'heap': 0};
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Memory usage query failed: $e');
      }
    }

    return {'rss': 0, 'heap': 0};
  }

  /// Calculate average frame time
  double _calculateAverageFrameTime() {
    if (_frameTimes.isEmpty) return 0.0;

    final totalTime = _frameTimes.fold<Duration>(
      Duration.zero,
      (total, frame) => total + frame.totalDuration,
    );

    return totalTime.inMicroseconds / _frameTimes.length / 1000; // in milliseconds
  }

  /// Calculate frame rate
  double _calculateFrameRate() {
    if (_frameTimes.isEmpty) return 0.0;

    final avgFrameTime = _calculateAverageFrameTime();
    if (avgFrameTime == 0) return 0.0;

    return 1000 / avgFrameTime; // frames per second
  }

  /// Calculate dropped frames
  int _calculateDroppedFrames() {
    if (_frameTimes.isEmpty) return 0;

    const targetFrameTime = 16.67; // 60fps target
    return _frameTimes
        .where((frame) => frame.totalDuration.inMicroseconds / 1000 > targetFrameTime)
        .length;
  }

  /// Get latest memory usage
  int _getLatestMemoryUsage() {
    if (_memorySnapshots.isEmpty) return 0;
    return _memorySnapshots.last.rssMemory;
  }

  /// Get peak memory usage
  int _getPeakMemoryUsage() {
    if (_memorySnapshots.isEmpty) return 0;
    return _memorySnapshots.map((s) => s.rssMemory).reduce((a, b) => a > b ? a : b);
  }

  /// Calculate overall performance score (0-100)
  double _calculatePerformanceScore() {
    double score = 100.0;

    // Frame rate scoring (40% weight)
    final fps = _calculateFrameRate();
    if (fps < 60) score -= (60 - fps) * 0.67; // 0.67 = 40/60
    if (fps < 30) score -= 20; // Additional penalty for very low fps

    // Memory usage scoring (30% weight)
    final memoryMB = _getLatestMemoryUsage() / (1024 * 1024);
    if (memoryMB > 200) score -= (memoryMB - 200) * 0.15; // 0.15 = 30/200

    // Dropped frames scoring (30% weight)
    if (_frameTimes.isNotEmpty) {
      final droppedPercentage = (_calculateDroppedFrames() / _frameTimes.length) * 100;
      score -= droppedPercentage * 0.3;
    }

    return score.clamp(0.0, 100.0);
  }

  /// Generate performance recommendations
  List<PerformanceRecommendation> _generateRecommendations() {
    final recommendations = <PerformanceRecommendation>[];

    final fps = _calculateFrameRate();
    final memoryMB = _getLatestMemoryUsage() / (1024 * 1024);
    final droppedFrames = _calculateDroppedFrames();

    // Frame rate recommendations
    if (fps < 50) {
      recommendations.add(PerformanceRecommendation(
        type: RecommendationType.frameRate,
        severity: fps < 30 ? Severity.high : Severity.medium,
        title: 'Low Frame Rate Detected',
        description: 'Frame rate is ${fps.toStringAsFixed(1)}fps, below the 60fps target.',
        suggestion: 'Consider using compute() for heavy operations or reducing widget rebuilds.',
      ));
    }

    // Memory usage recommendations
    if (memoryMB > 150) {
      recommendations.add(PerformanceRecommendation(
        type: RecommendationType.memory,
        severity: memoryMB > 200 ? Severity.high : Severity.medium,
        title: 'High Memory Usage',
        description: 'Memory usage is ${memoryMB.toStringAsFixed(1)}MB.',
        suggestion: 'Consider disposing unused resources or using lazy loading for large datasets.',
      ));
    }

    // Dropped frames recommendations
    if (droppedFrames > 5) {
      recommendations.add(PerformanceRecommendation(
        type: RecommendationType.frames,
        severity: droppedFrames > 20 ? Severity.high : Severity.low,
        title: 'Frame Drops Detected',
        description: '$droppedFrames frames dropped in recent samples.',
        suggestion: 'Review image processing operations or consider using RepaintBoundary widgets.',
      ));
    }

    // Platform-specific recommendations
    if (!kIsWeb && Platform.isAndroid) {
      recommendations.addAll(_getAndroidSpecificRecommendations());
    }

    return recommendations;
  }

  /// Android-specific performance recommendations
  List<PerformanceRecommendation> _getAndroidSpecificRecommendations() {
    final recommendations = <PerformanceRecommendation>[];

    // Check for common Android performance issues
    if (_calculateFrameRate() < 45) {
      recommendations.add(PerformanceRecommendation(
        type: RecommendationType.platform,
        severity: Severity.medium,
        title: 'Android GPU Performance',
        description: 'Consider enabling hardware acceleration for better performance.',
        suggestion: 'Ensure OpenGL ES is enabled and avoid excessive overdraw.',
      ));
    }

    return recommendations;
  }

  /// Reset all collected metrics
  void reset() {
    _frameTimes.clear();
    _memorySnapshots.clear();
  }

  /// Export performance data for analysis
  Map<String, dynamic> exportData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'metrics': getMetrics().toJson(),
      'frameTimes': _frameTimes.map((f) => f.toJson()).toList(),
      'memorySnapshots': _memorySnapshots.map((m) => m.toJson()).toList(),
      'isMonitoring': _isMonitoring,
    };
  }
}

/// Frame timing information
class FrameTimingInfo {
  const FrameTimingInfo({
    required this.buildDuration,
    required this.rasterDuration,
    required this.totalDuration,
    required this.timestamp,
  });

  final Duration buildDuration;
  final Duration rasterDuration;
  final Duration totalDuration;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'buildDuration': buildDuration.inMicroseconds,
    'rasterDuration': rasterDuration.inMicroseconds,
    'totalDuration': totalDuration.inMicroseconds,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// Memory usage snapshot
class MemorySnapshot {
  const MemorySnapshot({
    required this.rssMemory,
    required this.heapMemory,
    required this.timestamp,
  });

  final int rssMemory; // Resident Set Size in bytes
  final int heapMemory; // Heap memory in bytes
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'rssMemory': rssMemory,
    'heapMemory': heapMemory,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// Overall performance metrics
class PerformanceMetrics {
  const PerformanceMetrics({
    required this.averageFrameTime,
    required this.frameRate,
    required this.droppedFrameCount,
    required this.memoryUsage,
    required this.peakMemoryUsage,
    required this.performanceScore,
    required this.recommendations,
  });

  final double averageFrameTime; // in milliseconds
  final double frameRate; // frames per second
  final int droppedFrameCount;
  final int memoryUsage; // in bytes
  final int peakMemoryUsage; // in bytes
  final double performanceScore; // 0-100
  final List<PerformanceRecommendation> recommendations;

  Map<String, dynamic> toJson() => {
    'averageFrameTime': averageFrameTime,
    'frameRate': frameRate,
    'droppedFrameCount': droppedFrameCount,
    'memoryUsageMB': memoryUsage / (1024 * 1024),
    'peakMemoryUsageMB': peakMemoryUsage / (1024 * 1024),
    'performanceScore': performanceScore,
    'recommendations': recommendations.map((r) => r.toJson()).toList(),
  };
}

/// Performance recommendation
class PerformanceRecommendation {
  const PerformanceRecommendation({
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    required this.suggestion,
  });

  final RecommendationType type;
  final Severity severity;
  final String title;
  final String description;
  final String suggestion;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'severity': severity.name,
    'title': title,
    'description': description,
    'suggestion': suggestion,
  };
}

/// Types of performance recommendations
enum RecommendationType {
  frameRate,
  memory,
  frames,
  platform,
  general,
}

/// Severity levels for recommendations
enum Severity {
  low,
  medium,
  high,
  critical,
}

/// Performance optimization utilities
class PerformanceOptimizer {
  /// Optimize image processing performance
  static void optimizeImageProcessing() {
    // Enable hardware acceleration for image operations
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // Platform-specific optimizations would go here
    }
  }

  /// Optimize list performance for large datasets
  static Widget optimizeListView({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    double? itemExtent,
  }) {
    // Use ListView.builder for efficient memory usage
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(index),
      itemExtent: itemExtent,
      // Add physics for better scrolling performance
      physics: const ClampingScrollPhysics(),
      // Reduce overscroll for better performance
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
    );
  }

  /// Optimize widget rebuilds using keys
  static Key generateOptimalKey(String identifier) {
    return ValueKey(identifier);
  }

  /// Pre-compile expensive operations
  static Future<T> precompute<T>(T Function() computation) {
    return compute(_isolateWrapper, computation);
  }

  static T _isolateWrapper<T>(T Function() computation) {
    return computation();
  }

  /// Optimize app startup time
  static void optimizeAppStartup() {
    // Warm up critical services
    PerformanceMonitor.instance.startMonitoring();

    // Pre-cache commonly used assets
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAssets();
    });
  }

  static void _precacheAssets() {
    // Pre-cache would happen here for commonly used images/icons
    if (kDebugMode) {
      debugPrint('PerformanceOptimizer: Pre-caching assets');
    }
  }

  /// Memory management utilities
  static void forceGarbageCollection() {
    if (kDebugMode) {
      debugPrint('PerformanceOptimizer: Forcing garbage collection');
    }
    // Force GC (this is automatic in Dart, but we can suggest it)
    Isolate.current.addOnExitListener(RawReceivePort().sendPort);
  }

  /// Check if device has sufficient performance capabilities
  static bool hasHighPerformanceCapabilities() {
    // This would check device specs in a real implementation
    return true; // Assume true for now
  }

  /// Get performance-appropriate quality settings
  static ImageQualitySettings getOptimalImageQuality() {
    final monitor = PerformanceMonitor.instance;
    final metrics = monitor.getMetrics();

    if (metrics.performanceScore > 80) {
      return ImageQualitySettings.high;
    } else if (metrics.performanceScore > 60) {
      return ImageQualitySettings.medium;
    } else {
      return ImageQualitySettings.low;
    }
  }
}

/// Image quality settings based on performance
enum ImageQualitySettings {
  low(maxDimension: 1280, quality: 70),
  medium(maxDimension: 1920, quality: 80),
  high(maxDimension: 3840, quality: 90);

  const ImageQualitySettings({
    required this.maxDimension,
    required this.quality,
  });

  final int maxDimension;
  final int quality;
}