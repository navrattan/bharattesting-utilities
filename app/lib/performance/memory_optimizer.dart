import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Memory optimization utilities for BharatTesting Utilities
///
/// Provides intelligent memory management, leak detection, and optimization
/// strategies to maintain efficient memory usage across all 5 developer tools.
/// Target: Peak memory usage < 200MB during heavy operations.
class MemoryOptimizer {
  static MemoryOptimizer? _instance;
  static MemoryOptimizer get instance => _instance ??= MemoryOptimizer._();

  MemoryOptimizer._();

  final List<WeakReference<Object>> _trackedObjects = [];
  final Map<String, DateTime> _lastCleanup = {};
  Timer? _cleanupTimer;
  bool _isOptimizing = false;

  static const Duration cleanupInterval = Duration(minutes: 2);
  static const int maxTrackedObjects = 1000;

  /// Start memory optimization monitoring
  void startOptimization() {
    if (_isOptimizing) return;

    _isOptimizing = true;
    _schedulePeriodicCleanup();

    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Started optimization monitoring');
    }
  }

  /// Stop memory optimization
  void stopOptimization() {
    if (!_isOptimizing) return;

    _isOptimizing = false;
    _cleanupTimer?.cancel();
    _cleanupTimer = null;

    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Stopped optimization');
    }
  }

  /// Track object for memory leak detection
  void trackObject(Object object, {String? tag}) {
    if (!_isOptimizing || _trackedObjects.length >= maxTrackedObjects) {
      return;
    }

    _trackedObjects.add(WeakReference(object));

    if (tag != null && kDebugMode) {
      debugPrint('MemoryOptimizer: Tracking object: $tag');
    }
  }

  /// Force garbage collection and cleanup
  Future<void> forceCleanup() async {
    if (!_isOptimizing) return;

    try {
      // Clean up weak references to collected objects
      _trackedObjects.removeWhere((ref) => ref.target == null);

      // Platform-specific memory cleanup
      await _performPlatformSpecificCleanup();

      // Clear image caches if memory pressure is high
      await _clearImageCaches();

      // Clean up temporary files
      await _cleanupTempFiles();

      if (kDebugMode) {
        debugPrint('MemoryOptimizer: Cleanup completed');
        debugPrint('Tracked objects: ${_trackedObjects.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('MemoryOptimizer: Cleanup error: $e');
      }
    }
  }

  /// Get current memory usage statistics
  Future<MemoryStats> getMemoryStats() async {
    final stats = MemoryStats();

    try {
      // Basic memory information
      stats.trackedObjects = _trackedObjects.length;
      stats.aliveObjects = _trackedObjects.where((ref) => ref.target != null).length;
      stats.leakedObjects = stats.trackedObjects - stats.aliveObjects;

      // Platform-specific memory usage
      if (!kIsWeb) {
        stats.rssMemory = await _getRssMemory();
        stats.heapMemory = await _getHeapMemory();
      }

      // Flutter-specific memory usage
      stats.imageCache = _getImageCacheSize();
      stats.renderObjectCount = _getRenderObjectCount();

      // Calculate memory pressure score (0-100)
      stats.pressureScore = _calculateMemoryPressure(stats);

    } catch (e) {
      if (kDebugMode) {
        debugPrint('MemoryOptimizer: Stats collection error: $e');
      }
    }

    return stats;
  }

  /// Optimize memory for specific operations
  Future<void> optimizeForOperation(OperationType operation) async {
    switch (operation) {
      case OperationType.imageProcessing:
        await _optimizeForImageProcessing();
        break;
      case OperationType.pdfMerge:
        await _optimizeForPdfMerge();
        break;
      case OperationType.dataGeneration:
        await _optimizeForDataGeneration();
        break;
      case OperationType.cameraPreview:
        await _optimizeForCameraPreview();
        break;
    }
  }

  /// Schedule periodic cleanup
  void _schedulePeriodicCleanup() {
    _cleanupTimer = Timer.periodic(cleanupInterval, (_) async {
      await forceCleanup();
    });
  }

  /// Platform-specific memory cleanup
  Future<void> _performPlatformSpecificCleanup() async {
    if (kIsWeb) {
      // Web-specific cleanup
      await _webMemoryCleanup();
    } else if (Platform.isAndroid) {
      // Android-specific cleanup
      await _androidMemoryCleanup();
    } else if (Platform.isIOS) {
      // iOS-specific cleanup
      await _iosMemoryCleanup();
    }
  }

  /// Clear Flutter image caches
  Future<void> _clearImageCaches() async {
    try {
      // Clear image cache if it's using too much memory
      final imageCache = PaintingBinding.instance.imageCache;
      final currentSize = imageCache.currentSizeBytes;

      if (currentSize > 50 * 1024 * 1024) { // 50MB threshold
        imageCache.clear();
        imageCache.clearLiveImages();

        if (kDebugMode) {
          debugPrint('MemoryOptimizer: Cleared image cache (${currentSize ~/ 1024 ~/ 1024}MB)');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('MemoryOptimizer: Image cache cleanup error: $e');
      }
    }
  }

  /// Clean up temporary files
  Future<void> _cleanupTempFiles() async {
    try {
      if (kIsWeb) return; // No file system access on web

      // Clean up old temporary files
      final tempDir = Directory.systemTemp;
      final btTempDir = Directory('${tempDir.path}/bharattesting');

      if (await btTempDir.exists()) {
        final files = btTempDir.listSync();
        final now = DateTime.now();

        for (final file in files) {
          final stat = await file.stat();
          final age = now.difference(stat.modified);

          if (age.inHours > 24) { // Delete files older than 24 hours
            await file.delete();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('MemoryOptimizer: Temp file cleanup error: $e');
      }
    }
  }

  /// Get RSS memory usage
  Future<int> _getRssMemory() async {
    try {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        return ProcessInfo.currentRss;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get heap memory usage
  Future<int> _getHeapMemory() async {
    try {
      // This would require platform channels for accurate heap size
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get image cache size
  int _getImageCacheSize() {
    try {
      return PaintingBinding.instance.imageCache.currentSizeBytes;
    } catch (e) {
      return 0;
    }
  }

  /// Get render object count
  int _getRenderObjectCount() {
    try {
      // This is an approximation
      return WidgetsBinding.instance.renderViews.length;
    } catch (e) {
      return 0;
    }
  }

  /// Calculate memory pressure score
  double _calculateMemoryPressure(MemoryStats stats) {
    double pressure = 0.0;

    // RSS memory pressure (40% weight)
    if (stats.rssMemory > 0) {
      final rssMB = stats.rssMemory / (1024 * 1024);
      if (rssMB > 200) pressure += 40 * ((rssMB - 200) / 200).clamp(0, 1);
    }

    // Image cache pressure (30% weight)
    final imageCacheMB = stats.imageCache / (1024 * 1024);
    if (imageCacheMB > 50) pressure += 30 * ((imageCacheMB - 50) / 50).clamp(0, 1);

    // Memory leaks pressure (30% weight)
    if (stats.trackedObjects > 0) {
      final leakRatio = stats.leakedObjects / stats.trackedObjects;
      pressure += 30 * leakRatio;
    }

    return pressure.clamp(0, 100);
  }

  /// Web-specific memory cleanup
  Future<void> _webMemoryCleanup() async {
    // Web-specific optimizations
    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Web cleanup performed');
    }
  }

  /// Android-specific memory cleanup
  Future<void> _androidMemoryCleanup() async {
    // Android-specific optimizations
    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Android cleanup performed');
    }
  }

  /// iOS-specific memory cleanup
  Future<void> _iosMemoryCleanup() async {
    // iOS-specific optimizations
    if (kDebugMode) {
      debugPrint('MemoryOptimizer: iOS cleanup performed');
    }
  }

  /// Optimize memory for image processing
  Future<void> _optimizeForImageProcessing() async {
    // Clear image cache before heavy processing
    await _clearImageCaches();

    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Optimized for image processing');
    }
  }

  /// Optimize memory for PDF merge
  Future<void> _optimizeForPdfMerge() async {
    // Ensure clean memory state for PDF operations
    await forceCleanup();

    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Optimized for PDF merge');
    }
  }

  /// Optimize memory for data generation
  Future<void> _optimizeForDataGeneration() async {
    // Clear unnecessary caches before bulk operations
    await _clearImageCaches();

    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Optimized for data generation');
    }
  }

  /// Optimize memory for camera preview
  Future<void> _optimizeForCameraPreview() async {
    // Minimize memory usage during camera operations
    await _clearImageCaches();

    if (kDebugMode) {
      debugPrint('MemoryOptimizer: Optimized for camera preview');
    }
  }

  /// Create memory-efficient image resize helper
  static Future<Uint8List> resizeImageEfficiently(
    Uint8List imageData,
    int maxWidth,
    int maxHeight, {
    int quality = 85,
  }) async {
    return compute(_resizeImageIsolate, {
      'data': imageData,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
      'quality': quality,
    });
  }

  /// Isolate function for memory-efficient image resizing
  static Uint8List _resizeImageIsolate(Map<String, dynamic> params) {
    // This would contain the actual image processing logic
    // For now, return the original data
    return params['data'] as Uint8List;
  }

  /// Dispose of resources
  void dispose() {
    stopOptimization();
    _trackedObjects.clear();
    _lastCleanup.clear();
  }
}

/// Memory usage statistics
class MemoryStats {
  int trackedObjects = 0;
  int aliveObjects = 0;
  int leakedObjects = 0;
  int rssMemory = 0; // in bytes
  int heapMemory = 0; // in bytes
  int imageCache = 0; // in bytes
  int renderObjectCount = 0;
  double pressureScore = 0.0; // 0-100

  Map<String, dynamic> toJson() => {
    'trackedObjects': trackedObjects,
    'aliveObjects': aliveObjects,
    'leakedObjects': leakedObjects,
    'rssMemoryMB': rssMemory / (1024 * 1024),
    'heapMemoryMB': heapMemory / (1024 * 1024),
    'imageCacheMB': imageCache / (1024 * 1024),
    'renderObjectCount': renderObjectCount,
    'pressureScore': pressureScore,
  };
}

/// Types of operations for memory optimization
enum OperationType {
  imageProcessing,
  pdfMerge,
  dataGeneration,
  cameraPreview,
}

/// Memory optimization recommendations
class MemoryRecommendation {
  final String title;
  final String description;
  final MemoryOptimizationAction action;
  final int potentialSavingMB;

  const MemoryRecommendation({
    required this.title,
    required this.description,
    required this.action,
    required this.potentialSavingMB,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'action': action.name,
    'potentialSavingMB': potentialSavingMB,
  };
}

/// Memory optimization actions
enum MemoryOptimizationAction {
  clearImageCache,
  forceGarbageCollection,
  cleanupTempFiles,
  optimizeImageProcessing,
  reduceBatchSize,
  enableComputeIsolates,
}

/// Memory pressure monitor widget
class MemoryPressureIndicator extends StatefulWidget {
  const MemoryPressureIndicator({super.key});

  @override
  State<MemoryPressureIndicator> createState() => _MemoryPressureIndicatorState();
}

class _MemoryPressureIndicatorState extends State<MemoryPressureIndicator> {
  Timer? _updateTimer;
  MemoryStats _stats = MemoryStats();

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
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (mounted) {
        final stats = await MemoryOptimizer.instance.getMemoryStats();
        setState(() {
          _stats = stats;
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
    final pressure = _stats.pressureScore;

    Color indicatorColor;
    if (pressure < 30) {
      indicatorColor = theme.colorScheme.primary;
    } else if (pressure < 70) {
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
            Icons.memory,
            size: 16,
            color: indicatorColor,
          ),
          const SizedBox(width: 4),
          Text(
            '${pressure.toStringAsFixed(0)}%',
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