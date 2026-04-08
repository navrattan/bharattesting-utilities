/// Image Reducer Service - Compress, resize, and process images
///
/// Provides core functionality for image size reduction

import 'dart:typed_data';

/// Image format types
enum ImageFormat {
  jpeg('JPEG', 'image/jpeg', '.jpg'),
  png('PNG', 'image/png', '.png'),
  webp('WebP', 'image/webp', '.webp');

  const ImageFormat(this.displayName, this.mimeType, this.extension);
  final String displayName;
  final String mimeType;
  final String extension;
}

/// Image resize presets
enum ResizePreset {
  thumbnail(150, 'Thumbnail'),
  small(640, 'Small'),
  hd(1280, 'HD'),
  fullHd(1920, 'Full HD'),
  fourK(3840, '4K'),
  custom(0, 'Custom');

  const ResizePreset(this.maxDimension, this.displayName);
  final int maxDimension;
  final String displayName;
}

/// Image processing result
class ImageProcessResult {
  const ImageProcessResult({
    required this.data,
    required this.originalSize,
    required this.processedSize,
    required this.format,
    required this.dimensions,
    this.metadata,
  });

  final Uint8List data;
  final int originalSize;
  final int processedSize;
  final ImageFormat format;
  final ImageDimensions dimensions;
  final Map<String, dynamic>? metadata;

  double get compressionRatio => 1.0 - (processedSize / originalSize);
  double get sizeSavedMB => (originalSize - processedSize) / (1024 * 1024);
}

/// Image dimensions
class ImageDimensions {
  const ImageDimensions({required this.width, required this.height});

  final int width;
  final int height;

  double get aspectRatio => width / height;
  int get totalPixels => width * height;
}

/// Image processing options
class ImageProcessOptions {
  const ImageProcessOptions({
    this.quality = 85,
    this.format,
    this.resizePreset,
    this.customWidth,
    this.customHeight,
    this.stripMetadata = true,
    this.maintainAspectRatio = true,
  });

  final int quality;
  final ImageFormat? format;
  final ResizePreset? resizePreset;
  final int? customWidth;
  final int? customHeight;
  final bool stripMetadata;
  final bool maintainAspectRatio;
}

/// Main Image Reducer Service
class ImageReducerService {
  /// Process a single image
  static Future<ImageProcessResult> processImage({
    required Uint8List imageData,
    required ImageProcessOptions options,
  }) async {
    // For MVP - return mock data
    // In real implementation, this would use the image package for processing

    final originalSize = imageData.length;
    final mockProcessedSize = (originalSize * (options.quality / 100)).round();

    return ImageProcessResult(
      data: imageData, // Mock - would be processed data
      originalSize: originalSize,
      processedSize: mockProcessedSize,
      format: options.format ?? ImageFormat.jpeg,
      dimensions: const ImageDimensions(width: 800, height: 600), // Mock
    );
  }

  /// Process multiple images
  static Future<List<ImageProcessResult>> processImageBatch({
    required List<Uint8List> images,
    required ImageProcessOptions options,
  }) async {
    final results = <ImageProcessResult>[];

    for (final imageData in images) {
      final result = await processImage(imageData: imageData, options: options);
      results.add(result);
    }

    return results;
  }

  /// Estimate output size
  static int estimateOutputSize({
    required int originalSize,
    required int quality,
  }) {
    return (originalSize * (quality / 100)).round();
  }

  /// Get supported formats for web platform
  static List<ImageFormat> getSupportedFormats() {
    return ImageFormat.values;
  }

  /// Validate image data
  static bool isValidImageData(Uint8List data) {
    if (data.length < 10) return false;

    // Check for common image headers
    final header = data.take(10).toList();

    // JPEG
    if (header[0] == 0xFF && header[1] == 0xD8) return true;

    // PNG
    if (header[0] == 0x89 && header[1] == 0x50 && header[2] == 0x4E && header[3] == 0x47) return true;

    // WebP
    if (header.length >= 12) {
      final riff = String.fromCharCodes(header.take(4));
      final webp = String.fromCharCodes(header.skip(8).take(4));
      if (riff == 'RIFF' && webp == 'WEBP') return true;
    }

    return false;
  }
}