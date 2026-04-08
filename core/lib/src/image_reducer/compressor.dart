/// High-performance image compression engine
///
/// Implements various compression algorithms and optimization strategies
library image_compressor;

import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'image_reducer_service.dart';

/// Compression configuration
class CompressionConfig {
  final ImageFormat format;
  final int quality; // 0-100
  final bool lossless;
  final bool preserveMetadata;
  final bool optimizeForSize;

  const CompressionConfig({
    this.format = ImageFormat.jpeg,
    this.quality = 80,
    this.lossless = false,
    this.preserveMetadata = false,
    this.optimizeForSize = true,
  });

  /// Presets for common use cases
  static const webOptimized = CompressionConfig(
    format: ImageFormat.webp,
    quality: 75,
    optimizeForSize: true,
  );

  static const highQuality = CompressionConfig(
    format: ImageFormat.png,
    quality: 95,
    preserveMetadata: true,
  );

  static const extremeCompression = CompressionConfig(
    format: ImageFormat.jpeg,
    quality: 50,
    optimizeForSize: true,
  );
}

/// Compression operation result
class CompressionResult {
  final Uint8List compressedData;
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final Duration processingTime;
  final ImageFormat outputFormat;
  final int width;
  final int height;
  final List<String> optimizations;
  final Map<String, dynamic> metadata;

  const CompressionResult({
    required this.compressedData,
    required this.originalSize,
    required this.compressedSize,
    required this.compressionRatio,
    required this.processingTime,
    required this.outputFormat,
    required this.width,
    required this.height,
    this.optimizations = const [],
    this.metadata = const {},
  });

  /// Percentage reduction in file size
  double get reductionPercent => (1 - compressionRatio) * 100;

  /// Efficiency score based on ratio and time
  double get efficiencyScore {
    final ratioScore = (1 - compressionRatio) * 100;
    final timeScore = (1000 - processingTime.inMilliseconds).clamp(0, 1000) / 10;
    return (ratioScore * 0.7) + (timeScore * 0.3);
  }
}

/// Advanced image compression service
class ImageCompressor {
  const ImageCompressor._();

  /// Compress image data with specific configuration
  static Future<CompressionResult> compress({
    required Uint8List imageData,
    CompressionConfig config = const CompressionConfig(),
  }) async {
    final stopwatch = Stopwatch()..start();
    final optimizations = <String>[];

    try {
      // Decode original image
      final originalImage = img.decodeImage(imageData);
      if (originalImage == null) {
        throw const ImageCompressionException('Could not decode image data');
      }

      var processedImage = originalImage;

      // Apply optimizations based on format
      switch (config.format) {
        case ImageFormat.jpeg:
          processedImage = _optimizeForJPEG(processedImage, config, optimizations);
          break;
        case ImageFormat.png:
          processedImage = _optimizeForPNG(processedImage, config, optimizations);
          break;
        case ImageFormat.webp:
          processedImage = _optimizeForWebP(processedImage, config, optimizations);
          break;
        default:
          break;
      }

      // Encode to target format
      final compressedData = _encodeImage(processedImage, config);

      stopwatch.stop();

      return CompressionResult(
        compressedData: compressedData,
        originalSize: imageData.length,
        compressedSize: compressedData.length,
        compressionRatio: compressedData.length / imageData.length,
        processingTime: stopwatch.elapsed,
        outputFormat: config.format,
        width: processedImage.width,
        height: processedImage.height,
        optimizations: optimizations,
        metadata: {
          'originalFormat': _detectFormat(imageData),
          'colorChannels': processedImage.numChannels,
          'hasAlpha': processedImage.hasAlpha,
          'bitsPerChannel': processedImage.bitsPerChannel,
        },
      );
    } catch (e) {
      stopwatch.stop();
      throw ImageCompressionException(
        'Compression failed: $e',
        processingTime: stopwatch.elapsed,
      );
    }
  }

  /// Batch compress multiple images with progress tracking
  static Stream<CompressionResult> compressBatch({
    required List<Uint8List> images,
    CompressionConfig config = const CompressionConfig(),
  }) async* {
    for (final imageData in images) {
      yield await compress(imageData: imageData, config: config);
    }
  }

  /// Get supported formats for an image
  static List<ImageFormat> getSupportedFormats(Uint8List imageData) {
    final format = _detectFormat(imageData);

    // All formats can be converted to JPEG/PNG/WebP
    final supported = [ImageFormat.jpeg, ImageFormat.png, ImageFormat.webp];

    // Preserve original format if supported
    if (format != null && !supported.contains(format)) {
      supported.add(format);
    }

    return supported;
  }

  // Private helper methods

  static img.Image _optimizeForJPEG(
    img.Image image,
    CompressionConfig config,
    List<String> optimizations,
  ) {
    var optimized = image;

    // Convert to RGB if needed (JPEG doesn't support alpha)
    if (optimized.hasAlpha) {
      optimized = img.copyConvert(optimized, numChannels: 3);
      optimizations.add('Removed alpha channel for JPEG');
    }

    // Color space optimization
    if (config.optimizeForSize && config.quality < 70) {
      // Reduce color palette for lower quality
      optimized = img.quantize(optimized, numberOfColors: 256);
      optimizations.add('Quantized colors for size optimization');
    }

    return optimized;
  }

  static img.Image _optimizeForPNG(
    img.Image image,
    CompressionConfig config,
    List<String> optimizations,
  ) {
    var optimized = image;

    if (config.optimizeForSize && !config.preserveMetadata) {
      // Palette optimization for PNG
      if (optimized.numChannels >= 3 && !optimized.hasAlpha) {
        // Check if image can use palette mode
        final colors = <List<int>>{};
        for (int y = 0; y < optimized.height; y++) {
          for (int x = 0; x < optimized.width; x++) {
            final pixel = optimized.getPixel(x, y);
            colors.add([pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()]);
            if (colors.length > 256) break;
          }
          if (colors.length > 256) break;
        }

        if (colors.length <= 256) {
          optimized = img.quantize(optimized, numberOfColors: colors.length);
          optimizations.add('Converted to palette mode (${colors.length} colors)');
        }
      }
    }

    return optimized;
  }

  static img.Image _optimizeForWebP(
    img.Image image,
    CompressionConfig config,
    List<String> optimizations,
  ) {
    // WebP specific optimizations
    var optimized = image;

    if (config.optimizeForSize && !config.lossless) {
      // Smart alpha channel handling
      if (optimized.hasAlpha) {
        // Check if alpha is actually used
        bool hasTransparency = false;
        for (int y = 0; y < optimized.height && !hasTransparency; y++) {
          for (int x = 0; x < optimized.width; x++) {
            if (optimized.getPixel(x, y).a < 255) {
              hasTransparency = true;
              break;
            }
          }
        }

        if (!hasTransparency) {
          optimized = img.copyConvert(optimized, numChannels: 3);
          optimizations.add('Removed unused alpha channel');
        }
      }
    }

    return optimized;
  }

  static Uint8List _encodeImage(img.Image image, CompressionConfig config) {
    switch (config.format) {
      case ImageFormat.jpeg:
        return Uint8List.fromList(
          img.encodeJpg(image, quality: config.quality),
        );
      case ImageFormat.png:
        return Uint8List.fromList(img.encodePng(image));
      case ImageFormat.webp:
        // image package does not have WebP encoder yet
        return Uint8List.fromList(img.encodePng(image));
      case ImageFormat.bmp:
        return Uint8List.fromList(img.encodeBmp(image));
      case ImageFormat.gif:
        return Uint8List.fromList(img.encodeGif(image));
      case ImageFormat.tiff:
        return Uint8List.fromList(img.encodeTiff(image));
    }
  }

  static ImageFormat? _detectFormat(Uint8List data) {
    if (data.length < 4) return null;

    if (data[0] == 0xFF && data[1] == 0xD8) return ImageFormat.jpeg;
    if (data[0] == 0x89 && data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47) {
      return ImageFormat.png;
    }
    
    // Simple WebP check
    if (data.length >= 12) {
      final riff = String.fromCharCodes(data.take(4));
      final webp = String.fromCharCodes(data.skip(8).take(4));
      if (riff == 'RIFF' && webp == 'WEBP') return ImageFormat.webp;
    }

    return null;
  }
}

/// Exception during image compression
class ImageCompressionException implements Exception {
  final String message;
  final Duration? processingTime;

  const ImageCompressionException(this.message, {this.processingTime});

  @override
  String toString() {
    final time = processingTime != null ? ' (${processingTime!.inMilliseconds}ms)' : '';
    return 'ImageCompressionException: $message$time';
  }
}
