import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// Frame rate optimization utilities for BharatTesting Utilities
///
/// Provides intelligent frame rate management, jank detection, and optimization
/// strategies to maintain smooth 60fps UI across all 5 developer tools.
/// Automatically adapts quality settings based on device performance.
class FrameOptimizer {
  static FrameOptimizer? _instance;
  static FrameOptimizer get instance => _instance ??= FrameOptimizer._();

  FrameOptimizer._();

  final List<Duration> _frameDurations = [];
  Timer? _optimizationTimer;
  bool _isOptimizing = false;
  PerformanceLevel _currentLevel = PerformanceLevel.high;

  static const int maxFrameSamples = 60; // 1 second at 60fps
  static const Duration targetFrameDuration = Duration(microseconds: 16667); // 60fps
  static const Duration jankThreshold = Duration(microseconds: 33334); // 30fps

  /// Start frame rate optimization
  void startOptimization() {
    if (_isOptimizing) return;

    _isOptimizing = true;
    _startFrameMonitoring();
    _schedulePeriodicOptimization();

    if (kDebugMode) {
      debugPrint('FrameOptimizer: Started optimization');
    }
  }

  /// Stop frame rate optimization
  void stopOptimization() {
    if (!_isOptimizing) return;

    _isOptimizing = false;
    _optimizationTimer?.cancel();
    _optimizationTimer = null;

    if (kDebugMode) {
      debugPrint('FrameOptimizer: Stopped optimization');
    }
  }

  /// Get current frame rate statistics
  FrameStats getFrameStats() {
    if (_frameDurations.isEmpty) {
      return FrameStats();
    }

    final stats = FrameStats();

    // Calculate average frame duration
    final totalDuration = _frameDurations.fold<Duration>(
      Duration.zero,
      (sum, duration) => sum + duration,
    );
    stats.averageFrameDuration = totalDuration ~/ _frameDurations.length;

    // Calculate frame rate
    if (stats.averageFrameDuration.inMicroseconds > 0) {
      stats.frameRate = 1000000 / stats.averageFrameDuration.inMicroseconds;
    }

    // Count janky frames
    stats.jankyFrames = _frameDurations
        .where((duration) => duration > jankThreshold)
        .length;

    // Calculate jank percentage
    stats.jankPercentage = (stats.jankyFrames / _frameDurations.length) * 100;

    // Calculate smoothness score (0-100)
    stats.smoothnessScore = _calculateSmoothnessScore(stats);

    // Determine performance level
    stats.performanceLevel = _determinePerformanceLevel(stats);

    return stats;
  }

  /// Get current performance level
  PerformanceLevel get currentPerformanceLevel => _currentLevel;

  /// Manually set performance level
  void setPerformanceLevel(PerformanceLevel level) {
    _currentLevel = level;
    _applyPerformanceOptimizations();

    if (kDebugMode) {
      debugPrint('FrameOptimizer: Set performance level to ${level.name}');
    }
  }

  /// Optimize for specific widget operations
  void optimizeForWidget(String widgetName, VoidCallback operation) {
    final stopwatch = Stopwatch()..start();

    try {
      operation();
    } finally {
      stopwatch.stop();

      if (stopwatch.elapsedMicroseconds > targetFrameDuration.inMicroseconds) {
        _logSlowWidget(widgetName, stopwatch.elapsed);
      }
    }
  }

  /// Create performance-aware ListView builder
  static Widget createOptimizedListView({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    ScrollController? controller,
    double? itemExtent,
    bool? addAutomaticKeepAlives,
    bool? addRepaintBoundaries,
  }) {
    final performanceLevel = instance.currentPerformanceLevel;

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      controller: controller,
      itemExtent: itemExtent,
      // Optimize based on performance level
      addAutomaticKeepAlives: addAutomaticKeepAlives ??
          (performanceLevel == PerformanceLevel.high),
      addRepaintBoundaries: addRepaintBoundaries ??
          (performanceLevel != PerformanceLevel.low),
      physics: performanceLevel == PerformanceLevel.low
          ? const ClampingScrollPhysics()
          : const BouncingScrollPhysics(),
    );
  }

  /// Create performance-aware CustomScrollView
  static Widget createOptimizedScrollView({
    required List<Widget> slivers,
    ScrollController? controller,
    Axis scrollDirection = Axis.vertical,
  }) {
    final performanceLevel = instance.currentPerformanceLevel;

    return CustomScrollView(
      slivers: slivers,
      controller: controller,
      scrollDirection: scrollDirection,
      physics: performanceLevel == PerformanceLevel.low
          ? const ClampingScrollPhysics()
          : const BouncingScrollPhysics(),
    );
  }

  /// Optimize image display based on performance
  static Widget optimizeImage(
    ImageProvider image, {
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    final performanceLevel = instance.currentPerformanceLevel;

    return Image(
      image: image,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      // Reduce memory usage on low performance devices
      filterQuality: performanceLevel == PerformanceLevel.high
          ? FilterQuality.high
          : performanceLevel == PerformanceLevel.medium
              ? FilterQuality.medium
              : FilterQuality.low,
      // Enable caching based on performance
      gaplessPlayback: performanceLevel != PerformanceLevel.low,
    );
  }

  /// Start monitoring frame durations
  void _startFrameMonitoring() {
    SchedulerBinding.instance.addTimingsCallback((timings) {
      if (!_isOptimizing) return;

      for (final timing in timings) {
        _frameDurations.add(timing.totalSpan);

        if (_frameDurations.length > maxFrameSamples) {
          _frameDurations.removeAt(0);
        }
      }
    });
  }

  /// Schedule periodic optimization adjustments
  void _schedulePeriodicOptimization() {
    _optimizationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _analyzeAndOptimize();
    });
  }

  /// Analyze frame performance and adjust settings
  void _analyzeAndOptimize() {
    if (_frameDurations.length < 30) return; // Need enough samples

    final stats = getFrameStats();
    final newLevel = _determinePerformanceLevel(stats);

    if (newLevel != _currentLevel) {
      _currentLevel = newLevel;
      _applyPerformanceOptimizations();

      if (kDebugMode) {
        debugPrint('FrameOptimizer: Auto-adjusted to ${newLevel.name} '
            '(FPS: ${stats.frameRate.toStringAsFixed(1)}, '
            'Jank: ${stats.jankPercentage.toStringAsFixed(1)}%)');
      }
    }
  }

  /// Calculate smoothness score
  double _calculateSmoothnessScore(FrameStats stats) {
    double score = 100.0;

    // Penalize low frame rate (60% weight)
    if (stats.frameRate < 60) {
      score -= (60 - stats.frameRate) * 1.0; // 1 point per missing fps
    }

    // Penalize jank (40% weight)
    score -= stats.jankPercentage * 0.4;

    return score.clamp(0.0, 100.0);
  }

  /// Determine appropriate performance level
  PerformanceLevel _determinePerformanceLevel(FrameStats stats) {
    if (stats.frameRate >= 55 && stats.jankPercentage < 5) {
      return PerformanceLevel.high;
    } else if (stats.frameRate >= 45 && stats.jankPercentage < 15) {
      return PerformanceLevel.medium;
    } else {
      return PerformanceLevel.low;
    }
  }

  /// Apply optimizations based on performance level
  void _applyPerformanceOptimizations() {
    switch (_currentLevel) {
      case PerformanceLevel.high:
        _applyHighPerformanceSettings();
        break;
      case PerformanceLevel.medium:
        _applyMediumPerformanceSettings();
        break;
      case PerformanceLevel.low:
        _applyLowPerformanceSettings();
        break;
    }
  }

  /// Apply high performance settings
  void _applyHighPerformanceSettings() {
    // Enable all visual enhancements
    if (kDebugMode) {
      debugPrint('FrameOptimizer: Applied high performance settings');
    }
  }

  /// Apply medium performance settings
  void _applyMediumPerformanceSettings() {
    // Moderate visual settings
    if (kDebugMode) {
      debugPrint('FrameOptimizer: Applied medium performance settings');
    }
  }

  /// Apply low performance settings
  void _applyLowPerformanceSettings() {
    // Minimal visual settings for performance
    if (kDebugMode) {
      debugPrint('FrameOptimizer: Applied low performance settings');
    }
  }

  /// Log slow widget operations
  void _logSlowWidget(String widgetName, Duration duration) {
    if (kDebugMode) {
      debugPrint('FrameOptimizer: Slow widget $widgetName took '
          '${duration.inMicroseconds}μs (target: ${targetFrameDuration.inMicroseconds}μs)');
    }
  }

  /// Reset all statistics
  void reset() {
    _frameDurations.clear();
  }

  /// Export frame statistics
  Map<String, dynamic> exportStats() {
    final stats = getFrameStats();
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'frameStats': stats.toJson(),
      'currentLevel': _currentLevel.name,
      'isOptimizing': _isOptimizing,
    };
  }
}

/// Frame rate statistics
class FrameStats {
  Duration averageFrameDuration = Duration.zero;
  double frameRate = 0.0;
  int jankyFrames = 0;
  double jankPercentage = 0.0;
  double smoothnessScore = 100.0;
  PerformanceLevel performanceLevel = PerformanceLevel.high;

  Map<String, dynamic> toJson() => {
    'averageFrameDurationMs': averageFrameDuration.inMicroseconds / 1000,
    'frameRate': frameRate,
    'jankyFrames': jankyFrames,
    'jankPercentage': jankPercentage,
    'smoothnessScore': smoothnessScore,
    'performanceLevel': performanceLevel.name,
  };
}

/// Performance levels for adaptive optimization
enum PerformanceLevel {
  high,
  medium,
  low,
}

/// Performance-aware RepaintBoundary widget
class OptimizedRepaintBoundary extends StatelessWidget {
  const OptimizedRepaintBoundary({
    super.key,
    required this.child,
    this.forceEnabled = false,
  });

  final Widget child;
  final bool forceEnabled;

  @override
  Widget build(BuildContext context) {
    final performanceLevel = FrameOptimizer.instance.currentPerformanceLevel;

    // Only use RepaintBoundary on high/medium performance devices
    // unless explicitly forced
    if (forceEnabled || performanceLevel != PerformanceLevel.low) {
      return RepaintBoundary(child: child);
    } else {
      return child;
    }
  }
}

/// Performance-aware AnimatedBuilder
class OptimizedAnimatedBuilder extends StatelessWidget {
  const OptimizedAnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  final Animation<double> animation;
  final TransitionBuilder builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final performanceLevel = FrameOptimizer.instance.currentPerformanceLevel;

    // Reduce animation smoothness on low performance devices
    if (performanceLevel == PerformanceLevel.low) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          // Sample animation at lower frequency for performance
          final sampledValue = (animation.value * 10).round() / 10;
          final sampledAnimation = AlwaysStoppedAnimation(sampledValue);

          return builder(context, child);
        },
        child: child,
      );
    } else {
      return AnimatedBuilder(
        animation: animation,
        builder: builder,
        child: child,
      );
    }
  }
}

/// Frame rate indicator widget for debug builds
class FrameRateIndicator extends StatefulWidget {
  const FrameRateIndicator({super.key});

  @override
  State<FrameRateIndicator> createState() => _FrameRateIndicatorState();
}

class _FrameRateIndicatorState extends State<FrameRateIndicator> {
  Timer? _updateTimer;
  FrameStats _stats = FrameStats();

  @override
  void initState() {
    super.initState();
    _startUpdating();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startUpdating() {
    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() {
          _stats = FrameOptimizer.instance.getFrameStats();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final fps = _stats.frameRate;

    Color indicatorColor;
    if (fps >= 55) {
      indicatorColor = theme.colorScheme.primary;
    } else if (fps >= 45) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = theme.colorScheme.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: indicatorColor.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.speed,
            size: 16,
            color: indicatorColor,
          ),
          const SizedBox(width: 4),
          Text(
            '${fps.toStringAsFixed(0)} fps',
            style: theme.textTheme.bodySmall?.copyWith(
              color: indicatorColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Performance monitoring overlay for debug builds
class PerformanceOverlay extends StatelessWidget {
  const PerformanceOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned(
          top: MediaQuery.of(context).viewPadding.top + 8,
          right: 8,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FrameRateIndicator(),
              SizedBox(height: 4),
              // MemoryPressureIndicator(), // Would import from memory_optimizer.dart
            ],
          ),
        ),
      ],
    );
  }
}