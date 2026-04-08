/// Advanced image resizing engine with smart algorithms
///
/// Supports multiple resize modes, aspect ratio handling, and quality algorithms
library image_resizer;

import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

/// Resize algorithms optimized for different use cases
enum ResizeAlgorithm {
  nearest(
    'Nearest Neighbor',
    'Fastest, pixelated result. Good for pixel art.',
    speed: 5,
    quality: 1,
  ),
  linear(
    'Linear',
    'Fast with decent quality. Good for thumbnails.',
    speed: 4,
    quality: 3,
  ),
  cubic(
    'Cubic',
    'Balanced speed and quality. Good for general use.',
    speed: 3,
    quality: 4,
  ),
  lanczos(
    'Lanczos',
    'High quality, slower. Best for photo resizing.',
    speed: 2,
    quality: 5,
  ),
  mitchell(
    'Mitchell',
    'Sharp detail preservation. Good for text/graphics.',
    speed: 2,
    quality: 5,
  );

  const ResizeAlgorithm(
    this.displayName,
    this.description, {
    required this.speed,
    required this.quality,
  });

  final String displayName;
  final String description;
  final int speed; // 1-5, higher = faster
  final int quality; // 1-5, higher = better quality
}

/// Aspect ratio handling modes
enum AspectRatioMode {
  fit('Fit', 'Scale to fit within dimensions, preserving aspect ratio'),
  fill('Fill', 'Scale to fill dimensions exactly, may crop image'),
  stretch('Stretch', 'Stretch to exact dimensions, ignoring aspect ratio'),
  pad('Pad', 'Scale to fit and pad with background color'),
  crop('Crop', 'Scale and crop from center to fill dimensions');

  const AspectRatioMode(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Common resize presets for quick selection
enum ResizePreset {
  thumbnail(
    'Thumbnail',
    150, 150,
    ResizeAlgorithm.cubic,
    AspectRatioMode.crop,
  ),
  small(
    'Small',
    640, 480,
    ResizeAlgorithm.cubic,
    AspectRatioMode.fit,
  ),
  medium(
    'Medium',
    1024, 768,
    ResizeAlgorithm.lanczos,
    AspectRatioMode.fit,
  ),
  large(
    'Large',
    1920, 1080,
    ResizeAlgorithm.lanczos,
    AspectRatioMode.fit,
  ),
  ultraHD(
    'Ultra HD',
    3840, 2160,
    ResizeAlgorithm.lanczos,
    AspectRatioMode.fit,
  ),
  square512(
    'Square 512px',
    512, 512,
    ResizeAlgorithm.lanczos,
    AspectRatioMode.crop,
  ),
  square1024(
    'Square 1024px',
    1024, 1024,
    ResizeAlgorithm.lanczos,
    AspectRatioMode.crop,
  );

  const ResizePreset(
    this.displayName,
    this.width,
    this.height,
    this.algorithm,
    this.aspectRatioMode,
  );

  final String displayName;
  final int width;
  final int height;
  final ResizeAlgorithm algorithm;
  final AspectRatioMode aspectRatioMode;

  /// Get dimensions string
  String get dimensions => '${width} × ${height}';

  /// Calculate megapixels
  double get megapixels => (width * height) / 1000000;
}

/// Resize configuration with advanced options
class ResizeConfig {
  final int? width;
  final int? height;
  final double? scale; // Alternative to width/height
  final ResizeAlgorithm algorithm;
  final AspectRatioMode aspectRatioMode;
  final int backgroundColor; // ARGB color for padding
  final bool maintainQuality;
  final bool allowUpscaling;
  final int maxDimension; // Safety limit
  final bool sharpening; // Post-resize sharpening
  final double sharpeningStrength; // 0.0 - 2.0

  const ResizeConfig({
    this.width,
    this.height,
    this.scale,
    this.algorithm = ResizeAlgorithm.lanczos,
    this.aspectRatioMode = AspectRatioMode.fit,
    this.backgroundColor = 0xFFFFFFFF, // White
    this.maintainQuality = true,
    this.allowUpscaling = true,
    this.maxDimension = 8192,
    this.sharpening = false,
    this.sharpeningStrength = 1.0,
  });

  /// Create config from preset
  factory ResizeConfig.fromPreset(ResizePreset preset) {
    return ResizeConfig(
      width: preset.width,
      height: preset.height,
      algorithm: preset.algorithm,
      aspectRatioMode: preset.aspectRatioMode,
    );
  }

  /// Create config for percentage scaling
  factory ResizeConfig.percentage(
    double percentage, {
    ResizeAlgorithm algorithm = ResizeAlgorithm.lanczos,
  }) {
    return ResizeConfig(
      scale: percentage / 100.0,
      algorithm: algorithm,
    );
  }

  /// Validate configuration
  void validate() {
    if (width == null && height == null && scale == null) {
      throw ArgumentError('Must specify width, height, or scale');
    }

    if (width != null && width! <= 0) {
      throw ArgumentError('Width must be positive');
    }

    if (height != null && height! <= 0) {
      throw ArgumentError('Height must be positive');
    }

    if (scale != null && scale! <= 0) {
      throw ArgumentError('Scale must be positive');
    }

    if (sharpeningStrength < 0 || sharpeningStrength > 2) {
      throw ArgumentError('Sharpening strength must be between 0 and 2');
    }
  }
}

/// Resize operation result with metrics
class ResizeResult {
  final Uint8List imageData;
  final int originalWidth;
  final int originalHeight;
  final int newWidth;
  final int newHeight;
  final ResizeAlgorithm algorithmUsed;
  final AspectRatioMode aspectRatioMode;
  final Duration processingTime;
  final List<String> operations;
  final double qualityScore;

  ResizeResult({
    required this.imageData,
    required this.originalWidth,
    required this.originalHeight,
    required this.newWidth,
    required this.newHeight,
    required this.algorithmUsed,
    required this.aspectRatioMode,
    required this.processingTime,
    this.operations = const [],
    this.qualityScore = 0.0,
  });

  /// Calculate scale factor
  double get scaleFactorX => newWidth / originalWidth;
  double get scaleFactorY => newHeight / originalHeight;
  double get averageScaleFactor => (scaleFactorX + scaleFactorY) / 2;

  /// Pixel count change
  int get originalPixels => originalWidth * originalHeight;
  int get newPixels => newWidth * newHeight;
  double get pixelChangeRatio => newPixels / originalPixels;

  /// Determine if this was upscaling or downscaling
  bool get isUpscaling => averageScaleFactor > 1.0;
  bool get isDownscaling => averageScaleFactor < 1.0;

  /// Performance metrics
  double get pixelsPerSecond {
    if (processingTime.inMicroseconds == 0) return 0;
    return (originalPixels + newPixels) / (processingTime.inMicroseconds / 1000000);
  }

  /// Summary string
  String get summary {
    final factor = averageScaleFactor.toStringAsFixed(2);
    final direction = isUpscaling ? '↗' : isDownscaling ? '↘' : '→';
    return '${originalWidth}×${originalHeight} $direction ${newWidth}×${newHeight} (${factor}×)';
  }
}

/// Advanced image resizing engine
class ImageResizer {
  /// Resize image with specified configuration
  static Future<ResizeResult> resize(
    Uint8List imageData,
    ResizeConfig config,
  ) async {
    config.validate();
    final stopwatch = Stopwatch()..start();

    try {
      // Decode image
      final image = img.decodeImage(imageData);
      if (image == null) {
        throw ArgumentError('Invalid image data - unable to decode');
      }

      final operations = <String>[];

      // Calculate target dimensions
      final targetDims = _calculateTargetDimensions(
        image.width,
        image.height,
        config,
      );

      // Validate dimensions
      if (targetDims.width > config.maxDimension || targetDims.height > config.maxDimension) {
        throw ArgumentError(
          'Target dimensions ${targetDims.width}×${targetDims.height} '
          'exceed maximum ${config.maxDimension}',
        );
      }

      // Check upscaling limits
      if (!config.allowUpscaling) {
        if (targetDims.width > image.width || targetDims.height > image.height) {
          throw ArgumentError('Upscaling not allowed');
        }
      }

      var resizedImage = image;

      // Apply resize operation
      switch (config.aspectRatioMode) {
        case AspectRatioMode.fit:
          resizedImage = _resizeFit(resizedImage, targetDims, config, operations);
          break;
        case AspectRatioMode.fill:
          resizedImage = _resizeFill(resizedImage, targetDims, config, operations);
          break;
        case AspectRatioMode.stretch:
          resizedImage = _resizeStretch(resizedImage, targetDims, config, operations);
          break;
        case AspectRatioMode.pad:
          resizedImage = _resizePad(resizedImage, targetDims, config, operations);
          break;
        case AspectRatioMode.crop:
          resizedImage = _resizeCrop(resizedImage, targetDims, config, operations);
          break;
      }

      // Apply post-processing
      if (config.sharpening && config.sharpeningStrength > 0) {
        resizedImage = _applySharpeningFilter(resizedImage, config.sharpeningStrength);
        operations.add('Applied sharpening (${config.sharpeningStrength.toStringAsFixed(1)})');
      }

      // Encode result
      final resultData = Uint8List.fromList(img.encodePng(resizedImage));

      stopwatch.stop();

      return ResizeResult(
        imageData: resultData,
        originalWidth: image.width,
        originalHeight: image.height,
        newWidth: resizedImage.width,
        newHeight: resizedImage.height,
        algorithmUsed: config.algorithm,
        aspectRatioMode: config.aspectRatioMode,
        processingTime: stopwatch.elapsed,
        operations: operations,
        qualityScore: _calculateQualityScore(
          image.width * image.height,
          resizedImage.width * resizedImage.height,
          config.algorithm,
          stopwatch.elapsed,
        ),
      );
    } catch (e) {
      stopwatch.stop();
      throw ImageResizeException(
        'Resize failed: $e',
        processingTime: stopwatch.elapsed,
      );
    }
  }

  /// Calculate optimal preset for given dimensions and use case
  static ResizePreset suggestPreset(
    int originalWidth,
    int originalHeight, {
    int? targetFileSize,
    String useCase = 'general',
  }) {
    final originalPixels = originalWidth * originalHeight;

    // For thumbnails or avatars
    if (useCase == 'thumbnail' || useCase == 'avatar') {
      return originalPixels > 200000 ? ResizePreset.thumbnail : ResizePreset.small;
    }

    // For web display
    if (useCase == 'web') {
      if (originalPixels > 8000000) return ResizePreset.large; // > 8MP
      if (originalPixels > 3000000) return ResizePreset.medium; // > 3MP
      return ResizePreset.small;
    }

    // For social media
    if (useCase == 'social') {
      return originalPixels > 1000000 ? ResizePreset.square1024 : ResizePreset.square512;
    }

    // Based on file size constraints
    if (targetFileSize != null) {
      final mbLimit = targetFileSize / (1024 * 1024);
      if (mbLimit < 0.5) return ResizePreset.thumbnail;
      if (mbLimit < 2) return ResizePreset.small;
      if (mbLimit < 5) return ResizePreset.medium;
      return ResizePreset.large;
    }

    // Default suggestion
    if (originalPixels > 5000000) return ResizePreset.large;
    if (originalPixels > 2000000) return ResizePreset.medium;
    if (originalPixels > 500000) return ResizePreset.small;
    return ResizePreset.thumbnail;
  }

  /// Batch resize with progress tracking
  static Stream<ResizeResult> resizeBatch(
    List<Uint8List> images,
    ResizeConfig config, {
    int maxConcurrency = 3,
  }) async* {
    for (int i = 0; i < images.length; i += maxConcurrency) {
      final batch = images.skip(i).take(maxConcurrency);
      final futures = batch.map((imageData) => resize(imageData, config));

      final results = await Future.wait(futures);
      for (final result in results) {
        yield result;
      }
    }
  }

  // Private helper methods

  static _TargetDimensions _calculateTargetDimensions(
    int originalWidth,
    int originalHeight,
    ResizeConfig config,
  ) {
    if (config.scale != null) {
      return _TargetDimensions(
        (originalWidth * config.scale!).round(),
        (originalHeight * config.scale!).round(),
      );
    }

    if (config.width != null && config.height != null) {
      return _TargetDimensions(config.width!, config.height!);
    }

    if (config.width != null) {
      final aspectRatio = originalHeight / originalWidth;
      return _TargetDimensions(
        config.width!,
        (config.width! * aspectRatio).round(),
      );
    }

    if (config.height != null) {
      final aspectRatio = originalWidth / originalHeight;
      return _TargetDimensions(
        (config.height! * aspectRatio).round(),
        config.height!,
      );
    }

    throw ArgumentError('Invalid resize configuration');
  }

  static img.Image _resizeFit(
    img.Image image,
    _TargetDimensions target,
    ResizeConfig config,
    List<String> operations,
  ) {
    final aspectRatio = image.width / image.height;
    final targetAspectRatio = target.width / target.height;

    int newWidth, newHeight;

    if (aspectRatio > targetAspectRatio) {
      // Image is wider than target
      newWidth = target.width;
      newHeight = (target.width / aspectRatio).round();
    } else {
      // Image is taller than target
      newWidth = (target.height * aspectRatio).round();
      newHeight = target.height;
    }

    operations.add('Fit resize ${image.width}×${image.height} → ${newWidth}×${newHeight}');
    return _performResize(image, newWidth, newHeight, config.algorithm);
  }

  static img.Image _resizeFill(
    img.Image image,
    _TargetDimensions target,
    ResizeConfig config,
    List<String> operations,
  ) {
    final aspectRatio = image.width / image.height;
    final targetAspectRatio = target.width / target.height;

    int newWidth, newHeight;

    if (aspectRatio > targetAspectRatio) {
      // Scale by height
      newHeight = target.height;
      newWidth = (target.height * aspectRatio).round();
    } else {
      // Scale by width
      newWidth = target.width;
      newHeight = (target.width / aspectRatio).round();
    }

    final resized = _performResize(image, newWidth, newHeight, config.algorithm);

    // Crop to exact dimensions
    final cropX = (newWidth - target.width) ~/ 2;
    final cropY = (newHeight - target.height) ~/ 2;

    operations.add('Fill resize with crop (${cropX}, ${cropY})');
    return img.copyCrop(resized, x: cropX, y: cropY, width: target.width, height: target.height);
  }

  static img.Image _resizeStretch(
    img.Image image,
    _TargetDimensions target,
    ResizeConfig config,
    List<String> operations,
  ) {
    operations.add('Stretch resize ${image.width}×${image.height} → ${target.width}×${target.height}');
    return _performResize(image, target.width, target.height, config.algorithm);
  }

  static img.Image _resizePad(
    img.Image image,
    _TargetDimensions target,
    ResizeConfig config,
    List<String> operations,
  ) {
    // First fit the image
    final fitted = _resizeFit(image, target, config, operations);

    // Create canvas with background color
    final canvas = img.Image(width: target.width, height: target.height);
    img.fill(canvas, color: img.ColorRgba8(
      (config.backgroundColor >> 16) & 0xFF,
      (config.backgroundColor >> 8) & 0xFF,
      config.backgroundColor & 0xFF,
      (config.backgroundColor >> 24) & 0xFF,
    ));

    // Center the fitted image
    final offsetX = (target.width - fitted.width) ~/ 2;
    final offsetY = (target.height - fitted.height) ~/ 2;

    img.compositeImage(canvas, fitted, dstX: offsetX, dstY: offsetY);
    operations.add('Added padding with background color');

    return canvas;
  }

  static img.Image _resizeCrop(
    img.Image image,
    _TargetDimensions target,
    ResizeConfig config,
    List<String> operations,
  ) {
    final aspectRatio = image.width / image.height;
    final targetAspectRatio = target.width / target.height;

    img.Image cropped;

    if (aspectRatio > targetAspectRatio) {
      // Crop width
      final newWidth = (image.height * targetAspectRatio).round();
      final cropX = (image.width - newWidth) ~/ 2;
      cropped = img.copyCrop(image, x: cropX, y: 0, width: newWidth, height: image.height);
      operations.add('Pre-crop width: ${cropX} pixels from sides');
    } else if (aspectRatio < targetAspectRatio) {
      // Crop height
      final newHeight = (image.width / targetAspectRatio).round();
      final cropY = (image.height - newHeight) ~/ 2;
      cropped = img.copyCrop(image, x: 0, y: cropY, width: image.width, height: newHeight);
      operations.add('Pre-crop height: ${cropY} pixels from top/bottom');
    } else {
      cropped = image;
    }

    // Now resize to exact dimensions
    operations.add('Resize to exact dimensions');
    return _performResize(cropped, target.width, target.height, config.algorithm);
  }

  static img.Image _performResize(
    img.Image image,
    int width,
    int height,
    ResizeAlgorithm algorithm,
  ) {
    final interpolation = switch (algorithm) {
      ResizeAlgorithm.nearest => img.Interpolation.nearest,
      ResizeAlgorithm.linear => img.Interpolation.linear,
      ResizeAlgorithm.cubic => img.Interpolation.cubic,
      ResizeAlgorithm.lanczos => img.Interpolation.average, // Closest available
      ResizeAlgorithm.mitchell => img.Interpolation.cubic,
    };

    return img.copyResize(
      image,
      width: width,
      height: height,
      interpolation: interpolation,
    );
  }

  static img.Image _applySharpeningFilter(img.Image image, double strength) {
    // Simple sharpening kernel for image v4
    // image 4.x convolution takes a List<num> which represents the kernel
    // It's a flat list for a square kernel
    final kernelList = [
      0.0, -strength, 0.0,
      -strength, 1.0 + (4.0 * strength), -strength,
      0.0, -strength, 0.0,
    ];

    return img.convolution(image, filter: kernelList);
  }

  static double _calculateQualityScore(
    int originalPixels,
    int newPixels,
    ResizeAlgorithm algorithm,
    Duration processingTime,
  ) {
    // Base quality score from algorithm
    final algorithmScore = switch (algorithm) {
      ResizeAlgorithm.nearest => 20.0,
      ResizeAlgorithm.linear => 60.0,
      ResizeAlgorithm.cubic => 80.0,
      ResizeAlgorithm.lanczos => 95.0,
      ResizeAlgorithm.mitchell => 90.0,
    };

    // Penalty for extreme scaling
    final scaleFactor = math.sqrt(newPixels / originalPixels);
    final scalePenalty = scaleFactor > 2.0 || scaleFactor < 0.25 ? 20.0 : 0.0;

    // Performance bonus (faster = small bonus)
    final performanceBonus = processingTime.inMilliseconds < 100 ? 5.0 : 0.0;

    return math.max(0, algorithmScore - scalePenalty + performanceBonus);
  }
}

class _TargetDimensions {
  final int width;
  final int height;

  const _TargetDimensions(this.width, this.height);
}

/// Exception thrown when image resizing fails
class ImageResizeException implements Exception {
  final String message;
  final Duration? processingTime;
  final dynamic originalError;

  const ImageResizeException(
    this.message, {
    this.processingTime,
    this.originalError,
  });

  @override
  String toString() {
    final time = processingTime != null ? ' (${processingTime!.inMilliseconds}ms)' : '';
    return 'ImageResizeException: $message$time';
  }
}