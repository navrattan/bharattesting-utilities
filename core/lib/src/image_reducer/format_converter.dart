/// Advanced image format converter with optimization
///
/// Converts between JPEG, PNG, WebP, BMP, GIF with smart quality settings
library image_format_converter;

import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'compressor.dart';

/// Supported conversion formats with characteristics
enum ConvertibleFormat {
  jpeg(
    'JPEG',
    'Joint Photographic Experts Group',
    ['.jpg', '.jpeg'],
    lossy: true,
    supportsAlpha: false,
    supportsAnimation: false,
    bestFor: 'Photographs, complex images',
  ),
  png(
    'PNG',
    'Portable Network Graphics',
    ['.png'],
    lossy: false,
    supportsAlpha: true,
    supportsAnimation: false,
    bestFor: 'Graphics, transparency, screenshots',
  ),
  webp(
    'WebP',
    'Web Picture format',
    ['.webp'],
    lossy: true, // Can be lossless
    supportsAlpha: true,
    supportsAnimation: true,
    bestFor: 'Modern web, balanced quality/size',
  ),
  bmp(
    'BMP',
    'Windows Bitmap',
    ['.bmp'],
    lossy: false,
    supportsAlpha: false,
    supportsAnimation: false,
    bestFor: 'Windows applications, uncompressed',
  ),
  gif(
    'GIF',
    'Graphics Interchange Format',
    ['.gif'],
    lossy: true, // Palette limited
    supportsAlpha: false, // Binary transparency only
    supportsAnimation: true,
    bestFor: 'Simple animations, pixel art',
  ),
  tiff(
    'TIFF',
    'Tagged Image File Format',
    ['.tiff', '.tif'],
    lossy: false,
    supportsAlpha: true,
    supportsAnimation: false,
    bestFor: 'Professional photography, printing',
  );

  const ConvertibleFormat(
    this.displayName,
    this.fullName,
    this.extensions, {
    required this.lossy,
    required this.supportsAlpha,
    required this.supportsAnimation,
    required this.bestFor,
  });

  final String displayName;
  final String fullName;
  final List<String> extensions;
  final bool lossy;
  final bool supportsAlpha;
  final bool supportsAnimation;
  final String bestFor;

  /// Get primary file extension
  String get primaryExtension => extensions.first;

  /// Check if format supports quality settings
  bool get supportsQuality => lossy;
}

/// Conversion optimization strategy
enum ConversionStrategy {
  preserveQuality('Preserve Quality', 'Maintain maximum quality, larger file size'),
  balanceQualitySize('Balance Quality/Size', 'Optimize for web usage'),
  minimizeSize('Minimize Size', 'Smallest file size, some quality loss'),
  preserveAlpha('Preserve Transparency', 'Maintain alpha channel if present'),
  stripMetadata('Strip Metadata', 'Remove all metadata for privacy'),
  webOptimized('Web Optimized', 'Optimize for fast web loading');

  const ConversionStrategy(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Format conversion configuration
class ConversionConfig {
  final ConvertibleFormat targetFormat;
  final ConversionStrategy strategy;
  final int? quality; // 0-100, null for lossless
  final bool preserveAlpha;
  final bool preserveMetadata;
  final bool progressiveEncoding;
  final int? maxWidth;
  final int? maxHeight;
  final bool autoOptimize;

  const ConversionConfig({
    required this.targetFormat,
    this.strategy = ConversionStrategy.balanceQualitySize,
    this.quality,
    this.preserveAlpha = true,
    this.preserveMetadata = false,
    this.progressiveEncoding = true,
    this.maxWidth,
    this.maxHeight,
    this.autoOptimize = true,
  });

  /// Create config with strategy presets
  factory ConversionConfig.withStrategy(
    ConvertibleFormat format,
    ConversionStrategy strategy,
  ) {
    return switch (strategy) {
      ConversionStrategy.preserveQuality => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 95 : null,
          preserveAlpha: true,
          preserveMetadata: true,
        ),
      ConversionStrategy.balanceQualitySize => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 80 : null,
          preserveAlpha: true,
          preserveMetadata: false,
        ),
      ConversionStrategy.minimizeSize => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 60 : null,
          preserveAlpha: false,
          preserveMetadata: false,
          autoOptimize: true,
        ),
      ConversionStrategy.preserveAlpha => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 85 : null,
          preserveAlpha: true,
        ),
      ConversionStrategy.stripMetadata => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          preserveMetadata: false,
        ),
      ConversionStrategy.webOptimized => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 75 : null,
          progressiveEncoding: true,
          maxWidth: 1920,
          maxHeight: 1080,
        ),
    };
  }

  /// Get recommended quality for format and use case
  int getRecommendedQuality() {
    if (!targetFormat.supportsQuality) return 100;

    return quality ?? switch (strategy) {
      ConversionStrategy.preserveQuality => 95,
      ConversionStrategy.balanceQualitySize => 80,
      ConversionStrategy.minimizeSize => 60,
      ConversionStrategy.preserveAlpha => 85,
      ConversionStrategy.stripMetadata => 75,
      ConversionStrategy.webOptimized => 75,
    };
  }
}

/// Format conversion result with analysis
class ConversionResult {
  final Uint8List convertedData;
  final ConvertibleFormat originalFormat;
  final ConvertibleFormat targetFormat;
  final int originalSize;
  final int convertedSize;
  final double compressionRatio;
  final Duration processingTime;
  final List<String> optimizations;
  final Map<String, dynamic> metadata;
  final List<String> warnings;

  ConversionResult({
    required this.convertedData,
    required this.originalFormat,
    required this.targetFormat,
    required this.originalSize,
    required this.convertedSize,
    required this.compressionRatio,
    required this.processingTime,
    this.optimizations = const [],
    this.metadata = const {},
    this.warnings = const [],
  });

  /// Size change percentage (negative = reduction, positive = increase)
  double get sizeChangePercent => ((convertedSize - originalSize) / originalSize) * 100;

  /// Conversion efficiency score (0-100)
  double get efficiencyScore {
    // Better score for smaller files and appropriate format choices
    final sizeScore = sizeChangePercent < 0 ?
        math.min((-sizeChangePercent / 50) * 60, 60) :
        math.max(0, 40 - (sizeChangePercent / 10));

    final speedScore = math.max(0, 40 - (processingTime.inMilliseconds / 50));

    return sizeScore + speedScore;
  }

  /// Summary of conversion
  String get summary {
    final change = sizeChangePercent >= 0 ? '+' : '';
    final percent = sizeChangePercent.toStringAsFixed(1);
    final sizeMB = (convertedSize / 1024 / 1024).toStringAsFixed(2);
    return '${originalFormat.displayName} → ${targetFormat.displayName}: '
           '${change}${percent}% (${sizeMB}MB)';
  }
}

/// Advanced image format converter
class FormatConverter {
  /// Convert image to target format
  static Future<ConversionResult> convert(
    Uint8List imageData,
    ConversionConfig config,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Detect original format
      final originalFormat = _detectImageFormat(imageData);
      if (originalFormat == null) {
        throw ArgumentError('Unknown or unsupported image format');
      }

      // Early return if same format and no optimizations needed
      if (originalFormat == config.targetFormat &&
          !config.autoOptimize &&
          config.preserveMetadata) {
        stopwatch.stop();
        return ConversionResult(
          convertedData: imageData,
          originalFormat: originalFormat,
          targetFormat: config.targetFormat,
          originalSize: imageData.length,
          convertedSize: imageData.length,
          compressionRatio: 1.0,
          processingTime: stopwatch.elapsed,
          warnings: ['No conversion needed - same format'],
        );
      }

      // Decode image
      final image = img.decodeImage(imageData);
      if (image == null) {
        throw ArgumentError('Failed to decode image data');
      }

      final optimizations = <String>[];
      final warnings = <String>[];
      var processedImage = image;

      // Apply pre-conversion optimizations
      processedImage = _applyPreConversionOptimizations(
        processedImage,
        originalFormat,
        config,
        optimizations,
        warnings,
      );

      // Apply size constraints if specified
      if (config.maxWidth != null || config.maxHeight != null) {
        final resized = _applySizeConstraints(
          processedImage,
          config.maxWidth,
          config.maxHeight,
        );
        if (resized != processedImage) {
          processedImage = resized;
          optimizations.add('Resized to fit constraints');
        }
      }

      // Perform format conversion
      final convertedData = _performConversion(
        processedImage,
        config,
        optimizations,
      );

      stopwatch.stop();

      return ConversionResult(
        convertedData: convertedData,
        originalFormat: originalFormat,
        targetFormat: config.targetFormat,
        originalSize: imageData.length,
        convertedSize: convertedData.length,
        compressionRatio: convertedData.length / imageData.length,
        processingTime: stopwatch.elapsed,
        optimizations: optimizations,
        metadata: {
          'width': processedImage.width,
          'height': processedImage.height,
          'channels': processedImage.numChannels,
          'hasAlpha': processedImage.hasAlpha,
          'quality': config.getRecommendedQuality(),
        },
        warnings: warnings,
      );

    } catch (e) {
      stopwatch.stop();
      throw FormatConversionException(
        'Format conversion failed: $e',
        processingTime: stopwatch.elapsed,
      );
    }
  }

  /// Get optimal format recommendation for given image and use case
  static ConvertibleFormat recommendFormat(
    Uint8List imageData, {
    String useCase = 'web',
    bool preserveAlpha = true,
  }) {
    final image = img.decodeImage(imageData);
    if (image == null) return ConvertibleFormat.jpeg;

    final hasAlpha = image.hasAlpha;
    final isSimple = _isSimpleGraphics(image);
    final isPhoto = !isSimple;

    switch (useCase) {
      case 'web':
        if (hasAlpha && preserveAlpha) return ConvertibleFormat.png;
        return isPhoto ? ConvertibleFormat.jpeg : ConvertibleFormat.png;

      case 'print':
        return hasAlpha ? ConvertibleFormat.png : ConvertibleFormat.jpeg;

      case 'archive':
        return ConvertibleFormat.tiff;

      case 'social':
        return ConvertibleFormat.jpeg;

      case 'thumbnail':
        return ConvertibleFormat.jpeg;

      default:
        return hasAlpha ? ConvertibleFormat.png : ConvertibleFormat.jpeg;
    }
  }

  /// Batch convert multiple images
  static Stream<ConversionResult> convertBatch(
    List<Uint8List> images,
    ConversionConfig config, {
    int maxConcurrency = 3,
  }) async* {
    for (int i = 0; i < images.length; i += maxConcurrency) {
      final batch = images.skip(i).take(maxConcurrency);
      final futures = batch.map((imageData) => convert(imageData, config));

      final results = await Future.wait(futures);
      for (final result in results) {
        yield result;
      }
    }
  }

  /// Get conversion compatibility matrix
  static Map<ConvertibleFormat, List<String>> getCompatibilityWarnings(
    ConvertibleFormat source,
    ConvertibleFormat target,
  ) {
    final warnings = <ConvertibleFormat, List<String>>{};

    if (source.supportsAlpha && !target.supportsAlpha) {
      warnings[target] = ['Alpha channel will be lost'];
    }

    if (source.supportsAnimation && !target.supportsAnimation) {
      warnings[target] = [...warnings[target] ?? [], 'Animation will be lost'];
    }

    if (!source.lossy && target.lossy) {
      warnings[target] = [...warnings[target] ?? [], 'Quality loss expected'];
    }

    return warnings;
  }

  // Private helper methods

  static ConvertibleFormat? _detectImageFormat(Uint8List data) {
    if (data.length < 4) return null;

    // JPEG
    if (data[0] == 0xFF && data[1] == 0xD8) {
      return ConvertibleFormat.jpeg;
    }

    // PNG
    if (data[0] == 0x89 && data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47) {
      return ConvertibleFormat.png;
    }

    // WebP
    if (data.length >= 12 &&
        data[0] == 0x52 && data[1] == 0x49 && data[2] == 0x46 && data[3] == 0x46 &&
        data[8] == 0x57 && data[9] == 0x45 && data[10] == 0x42 && data[11] == 0x50) {
      return ConvertibleFormat.webp;
    }

    // BMP
    if (data[0] == 0x42 && data[1] == 0x4D) {
      return ConvertibleFormat.bmp;
    }

    // GIF
    if (data.length >= 6 &&
        data[0] == 0x47 && data[1] == 0x49 && data[2] == 0x46) {
      return ConvertibleFormat.gif;
    }

    // TIFF (II = little endian, MM = big endian)
    if (data.length >= 4) {
      if ((data[0] == 0x49 && data[1] == 0x49 && data[2] == 0x2A && data[3] == 0x00) ||
          (data[0] == 0x4D && data[1] == 0x4D && data[2] == 0x00 && data[3] == 0x2A)) {
        return ConvertibleFormat.tiff;
      }
    }

    return null;
  }

  static img.Image _applyPreConversionOptimizations(
    img.Image image,
    ConvertibleFormat originalFormat,
    ConversionConfig config,
    List<String> optimizations,
    List<String> warnings,
  ) {
    var optimized = image;

    // Handle alpha channel based on target format and config
    if (!config.preserveAlpha && optimized.hasAlpha) {
      optimized = img.removeAlpha(optimized);
      optimizations.add('Removed alpha channel');
    } else if (optimized.hasAlpha && !config.targetFormat.supportsAlpha) {
      optimized = img.removeAlpha(optimized);
      warnings.add('Alpha channel removed - not supported by ${config.targetFormat.displayName}');
    }

    // Color space optimizations for specific formats
    switch (config.targetFormat) {
      case ConvertibleFormat.jpeg:
        // JPEG works best in RGB color space
        if (optimized.hasAlpha) {
          optimized = img.removeAlpha(optimized);
          warnings.add('Alpha channel removed for JPEG compatibility');
        }
        break;

      case ConvertibleFormat.gif:
        // GIF needs palette optimization
        if (config.autoOptimize) {
          optimized = img.quantize(optimized, numberOfColors: 256);
          optimizations.add('Quantized to 256 colors for GIF');
        }
        break;

      case ConvertibleFormat.png:
        // PNG optimization depends on content type
        if (config.autoOptimize && !_isSimpleGraphics(optimized)) {
          // For photos, consider if PNG is the best choice
          warnings.add('PNG may not be optimal for photographic content');
        }
        break;

      default:
        // No specific optimizations
        break;
    }

    return optimized;
  }

  static img.Image _applySizeConstraints(
    img.Image image,
    int? maxWidth,
    int? maxHeight,
  ) {
    if (maxWidth == null && maxHeight == null) return image;

    final currentWidth = image.width;
    final currentHeight = image.height;

    // Calculate scale factor
    double scale = 1.0;

    if (maxWidth != null && currentWidth > maxWidth) {
      scale = math.min(scale, maxWidth / currentWidth);
    }

    if (maxHeight != null && currentHeight > maxHeight) {
      scale = math.min(scale, maxHeight / currentHeight);
    }

    if (scale < 1.0) {
      final newWidth = (currentWidth * scale).round();
      final newHeight = (currentHeight * scale).round();
      return img.copyResize(image, width: newWidth, height: newHeight);
    }

    return image;
  }

  static Uint8List _performConversion(
    img.Image image,
    ConversionConfig config,
    List<String> optimizations,
  ) {
    final quality = config.getRecommendedQuality();

    switch (config.targetFormat) {
      case ConvertibleFormat.jpeg:
        optimizations.add('Encoded as JPEG (quality: $quality)');
        return Uint8List.fromList(img.encodeJpg(image, quality: quality));

      case ConvertibleFormat.png:
        optimizations.add('Encoded as PNG');
        return Uint8List.fromList(img.encodePng(image));

      case ConvertibleFormat.webp:
        // Note: True WebP encoding would require additional library
        // For now, fall back to PNG
        optimizations.add('Encoded as PNG (WebP fallback)');
        return Uint8List.fromList(img.encodePng(image));

      case ConvertibleFormat.bmp:
        optimizations.add('Encoded as BMP');
        return Uint8List.fromList(img.encodeBmp(image));

      case ConvertibleFormat.gif:
        optimizations.add('Encoded as GIF');
        return Uint8List.fromList(img.encodeGif(image));

      case ConvertibleFormat.tiff:
        optimizations.add('Encoded as TIFF');
        return Uint8List.fromList(img.encodeTiff(image));
    }
  }

  static bool _isSimpleGraphics(img.Image image) {
    // Simple heuristic: check color diversity
    final colors = <int>{};
    final sampleSize = math.min(1000, image.width * image.height);
    final step = (image.width * image.height) / sampleSize;

    for (int i = 0; i < sampleSize; i++) {
      final index = (i * step).round();
      final y = index ~/ image.width;
      final x = index % image.width;

      if (y < image.height && x < image.width) {
        colors.add(image.getPixel(x, y).rgb);
        if (colors.length > 256) return false; // Too many colors for simple graphics
      }
    }

    return colors.length <= 64; // Likely simple graphics/artwork
  }
}

/// Exception thrown when format conversion fails
class FormatConversionException implements Exception {
  final String message;
  final Duration? processingTime;
  final dynamic originalError;

  const FormatConversionException(
    this.message, {
    this.processingTime,
    this.originalError,
  });

  @override
  String toString() {
    final time = processingTime != null ? ' (${processingTime!.inMilliseconds}ms)' : '';
    return 'FormatConversionException: $message$time';
  }
}

import 'dart:math' as math;