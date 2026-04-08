/// Advanced image format converter with optimization
///
/// Converts between JPEG, PNG, WebP, BMP, GIF with smart quality settings
library image_format_converter;

import 'dart:typed_data';
import 'dart:math' as math;
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
        ),
      ConversionStrategy.preserveAlpha => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 85 : null,
          preserveAlpha: true,
          preserveMetadata: false,
        ),
      ConversionStrategy.stripMetadata => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 80 : null,
          preserveAlpha: true,
          preserveMetadata: false,
        ),
      ConversionStrategy.webOptimized => ConversionConfig(
          targetFormat: format,
          strategy: strategy,
          quality: format.supportsQuality ? 75 : null,
          preserveAlpha: true,
          preserveMetadata: false,
          progressiveEncoding: true,
        ),
    };
  }
}

/// Result of a format conversion operation
class ConversionResult {
  final Uint8List convertedData;
  final int originalSize;
  final int convertedSize;
  final ConvertibleFormat originalFormat;
  final ConvertibleFormat targetFormat;
  final Duration processingTime;
  final List<String> optimizations;
  final List<String> warnings;

  const ConversionResult({
    required this.convertedData,
    required this.originalSize,
    required this.convertedSize,
    required this.originalFormat,
    required this.targetFormat,
    required this.processingTime,
    this.optimizations = const [],
    this.warnings = const [],
  });

  /// Compression ratio (processed size / original size)
  double get compressionRatio => convertedSize / originalSize;

  /// Percentage change in size
  double get sizeChangePercent => ((convertedSize - originalSize) / originalSize) * 100;

  /// Conversion efficiency score (0-100)
  double get efficiencyScore {
    // Better score for smaller files and appropriate format choices
    final sizeScore = sizeChangePercent < 0 ?
        math.min((-sizeChangePercent / 50) * 60, 60) :
        math.max(0, 40 - (sizeChangePercent / 10));

    final speedScore = math.max(0, 40 - (processingTime.inMilliseconds / 50));

    return (sizeScore + speedScore).toDouble();
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

/// Advanced image format converter service
class ImageFormatConverter {
  const ImageFormatConverter._();

  /// Convert image data to target format with options
  static Future<ConversionResult> convert({
    required Uint8List imageData,
    required ConversionConfig config,
  }) async {
    final stopwatch = Stopwatch()..start();
    final optimizations = <String>[];
    final warnings = <String>[];

    try {
      // Decode image
      final image = img.decodeImage(imageData);
      if (image == null) {
        throw const FormatConversionException('Could not decode original image data');
      }

      final originalFormat = _detectFormat(imageData) ?? ConvertibleFormat.png;
      
      // Handle same format conversion if needed for optimization
      if (originalFormat == config.targetFormat && !config.autoOptimize) {
        optimizations.add('No conversion needed - formats match');
      }

      // Apply pre-conversion optimizations
      var processed = _applyPreConversionOptimizations(
        image,
        originalFormat,
        config,
        optimizations,
        warnings,
      );

      // Encode to target format
      final Uint8List convertedData;
      switch (config.targetFormat) {
        case ConvertibleFormat.jpeg:
          convertedData = Uint8List.fromList(img.encodeJpg(
            processed,
            quality: config.quality ?? 85,
          ));
          break;
        case ConvertibleFormat.png:
          convertedData = Uint8List.fromList(img.encodePng(processed));
          break;
        case ConvertibleFormat.webp:
          // Fallback to PNG for WebP as image package doesn't have WebP encoder yet
          warnings.add('WebP encoding not supported by current engine, falling back to PNG');
          convertedData = Uint8List.fromList(img.encodePng(processed));
          break;
        case ConvertibleFormat.bmp:
          convertedData = Uint8List.fromList(img.encodeBmp(processed));
          break;
        case ConvertibleFormat.gif:
          convertedData = Uint8List.fromList(img.encodeGif(processed));
          break;
        case ConvertibleFormat.tiff:
          convertedData = Uint8List.fromList(img.encodeTiff(processed));
          break;
      }

      stopwatch.stop();

      return ConversionResult(
        convertedData: convertedData,
        originalSize: imageData.length,
        convertedSize: convertedData.length,
        originalFormat: originalFormat,
        targetFormat: config.targetFormat,
        processingTime: stopwatch.elapsed,
        optimizations: optimizations,
        warnings: warnings,
      );
    } catch (e) {
      stopwatch.stop();
      if (e is FormatConversionException) rethrow;
      throw FormatConversionException(
        'Format conversion failed: $e',
        processingTime: stopwatch.elapsed,
        originalError: e,
      );
    }
  }

  /// Detect original image format from bytes
  static ConvertibleFormat? _detectFormat(Uint8List data) {
    if (data.length < 12) return null;

    // JPEG: FF D8 FF
    if (data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF) {
      return ConvertibleFormat.jpeg;
    }

    // PNG: 89 50 4E 47
    if (data[0] == 0x89 && data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47) {
      return ConvertibleFormat.png;
    }

    // GIF: 47 49 46 38
    if (data[0] == 0x47 && data[1] == 0x49 && data[2] == 0x46 && data[3] == 0x38) {
      return ConvertibleFormat.gif;
    }

    // BMP: 42 4D
    if (data[0] == 0x42 && data[1] == 0x4D) {
      return ConvertibleFormat.bmp;
    }

    // WebP: RIFF .... WEBP
    if (data.length >= 12) {
      final riff = String.fromCharCodes(data.take(4));
      final webp = String.fromCharCodes(data.skip(8).take(4));
      if (riff == 'RIFF' && webp == 'WEBP') {
        return ConvertibleFormat.webp;
      }
    }

    // TIFF: 49 49 2A 00 or 4D 4D 00 2A
    if ((data[0] == 0x49 && data[1] == 0x49 && data[2] == 0x2A) ||
        (data[0] == 0x4D && data[1] == 0x4D && data[3] == 0x2A)) {
      return ConvertibleFormat.tiff;
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
      optimized = img.copyConvert(optimized, numChannels: 3);
      optimizations.add('Removed alpha channel');
    } else if (optimized.hasAlpha && !config.targetFormat.supportsAlpha) {
      optimized = img.copyConvert(optimized, numChannels: 3);
      warnings.add('Alpha channel removed - not supported by ${config.targetFormat.displayName}');
    }

    // Color space optimizations for specific formats
    switch (config.targetFormat) {
      case ConvertibleFormat.jpeg:
        // JPEG works best in RGB color space
        if (optimized.hasAlpha) {
          optimized = img.copyConvert(optimized, numChannels: 3);
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
      
      default:
        break;
    }

    return optimized;
  }

  /// Analyze palette and color distribution
  static Map<String, dynamic> analyzeColors(img.Image image) {
    final colors = <List<int>>[];
    
    // Sample pixels for analysis
    final stepX = math.max(1, image.width ~/ 32);
    final stepY = math.max(1, image.height ~/ 32);
    
    for (int y = 0; y < image.height; y += stepY) {
      for (int x = 0; x < image.width; x += stepX) {
        final pixel = image.getPixel(x, y);
        colors.add([pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()]);
      }
    }

    return {
      'sampleSize': colors.length,
      'isGrayscale': _checkIfGrayscale(colors),
      'hasHighContrast': _checkContrast(colors),
    };
  }

  static bool _checkIfGrayscale(List<List<int>> colors) {
    for (final c in colors) {
      if ((c[0] - c[1]).abs() > 5 || (c[0] - c[2]).abs() > 5 || (c[1] - c[2]).abs() > 5) {
        return false;
      }
    }
    return true;
  }

  static bool _checkContrast(List<List<int>> colors) {
    int minBrightness = 255;
    int maxBrightness = 0;
    
    for (final c in colors) {
      final b = (c[0] + c[1] + c[2]) ~/ 3;
      if (b < minBrightness) minBrightness = b;
      if (b > maxBrightness) maxBrightness = b;
    }
    
    return (maxBrightness - minBrightness) > 128;
  }
}

/// Exception during format conversion
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
