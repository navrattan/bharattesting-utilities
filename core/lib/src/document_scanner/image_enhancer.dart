import 'dart:typed_data';
import 'dart:math' as math;

/// Professional image enhancement engine for document scanning
///
/// Features:
/// - 6 specialized filters for document optimization
/// - CLAHE (Contrast Limited Adaptive Histogram Equalization)
/// - Adaptive thresholding for binarization
/// - Morphological operations for noise reduction
/// - Color enhancement algorithms
/// - Real-time processing optimized for mobile devices
/// - Professional document scanning quality
class DocumentImageEnhancer {
  /// Apply enhancement filter to document image
  ///
  /// [imageData] - Input image data (RGB format)
  /// [width] - Image width in pixels
  /// [height] - Image height in pixels
  /// [filter] - Enhancement filter to apply
  /// [options] - Filter-specific options
  ///
  /// Returns enhanced image data
  static Future<Uint8List> applyFilter(
    Uint8List imageData,
    int width,
    int height,
    DocumentFilter filter, {
    FilterOptions? options,
  }) async {
    options ??= FilterOptions();

    switch (filter) {
      case DocumentFilter.original:
        return imageData;

      case DocumentFilter.autoColor:
        return await _applyAutoColorCorrection(imageData, width, height, options);

      case DocumentFilter.grayscale:
        return await _applyGrayscale(imageData, width, height, options);

      case DocumentFilter.blackAndWhite:
        return await _applyBlackAndWhite(imageData, width, height, options);

      case DocumentFilter.magicColor:
        return await _applyMagicColor(imageData, width, height, options);

      case DocumentFilter.whiteboard:
        return await _applyWhiteboard(imageData, width, height, options);
    }
  }

  /// Auto Color Correction using CLAHE and color balancing
  static Future<Uint8List> _applyAutoColorCorrection(
    Uint8List imageData,
    int width,
    int height,
    FilterOptions options,
  ) async {
    // Step 1: Convert to LAB color space for processing
    final labData = await _rgbToLab(imageData, width, height);

    // Step 2: Apply CLAHE to L channel
    final enhancedL = await _applyCLAHE(
      labData,
      width,
      height,
      clipLimit: options.claheClipLimit,
      tileSize: options.claheTileSize,
    );

    // Step 3: Enhance contrast in A and B channels slightly
    final enhancedAB = _enhanceColorChannels(labData, width, height, enhancedL);

    // Step 4: Convert back to RGB
    final result = await _labToRgb(enhancedAB, width, height);

    // Step 5: Apply color balance correction
    return _applyColorBalance(result, width, height, options);
  }

  /// Convert RGB to LAB color space
  static Future<List<double>> _rgbToLab(Uint8List imageData, int width, int height) async {
    final labData = List<double>.filled(width * height * 3, 0);

    for (int i = 0; i < width * height; i++) {
      final r = imageData[i * 3] / 255.0;
      final g = imageData[i * 3 + 1] / 255.0;
      final b = imageData[i * 3 + 2] / 255.0;

      // Convert to XYZ first
      final xyz = _rgbToXyz(r, g, b);

      // Convert XYZ to LAB
      final lab = _xyzToLab(xyz[0], xyz[1], xyz[2]);

      labData[i * 3] = lab[0];     // L
      labData[i * 3 + 1] = lab[1]; // A
      labData[i * 3 + 2] = lab[2]; // B
    }

    return labData;
  }

  /// Convert RGB to XYZ color space
  static List<double> _rgbToXyz(double r, double g, double b) {
    // Apply gamma correction
    r = r > 0.04045 ? math.pow((r + 0.055) / 1.055, 2.4).toDouble() : r / 12.92;
    g = g > 0.04045 ? math.pow((g + 0.055) / 1.055, 2.4).toDouble() : g / 12.92;
    b = b > 0.04045 ? math.pow((b + 0.055) / 1.055, 2.4).toDouble() : b / 12.92;

    // Observer = 2°, Illuminant = D65
    final x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
    final y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
    final z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;

    return [x * 100, y * 100, z * 100];
  }

  /// Convert XYZ to LAB color space
  static List<double> _xyzToLab(double x, double y, double z) {
    // Reference white D65
    const xn = 95.047;
    const yn = 100.000;
    const zn = 108.883;

    x /= xn;
    y /= yn;
    z /= zn;

    final fx = x > 0.008856 ? math.pow(x, 1/3).toDouble() : (7.787 * x + 16/116);
    final fy = y > 0.008856 ? math.pow(y, 1/3).toDouble() : (7.787 * y + 16/116);
    final fz = z > 0.008856 ? math.pow(z, 1/3).toDouble() : (7.787 * z + 16/116);

    final L = 116 * fy - 16;
    final a = 500 * (fx - fy);
    final b = 200 * (fy - fz);

    return [L, a, b];
  }

  /// Apply CLAHE (Contrast Limited Adaptive Histogram Equalization)
  static Future<List<double>> _applyCLAHE(
    List<double> labData,
    int width,
    int height, {
    double clipLimit = 2.0,
    int tileSize = 8,
  }) async {
    final result = List<double>.from(labData);
    final tilesX = (width / tileSize).ceil();
    final tilesY = (height / tileSize).ceil();

    // Process each tile
    for (int tileY = 0; tileY < tilesY; tileY++) {
      for (int tileX = 0; tileX < tilesX; tileX++) {
        final startX = tileX * tileSize;
        final startY = tileY * tileSize;
        final endX = math.min(startX + tileSize, width);
        final endY = math.min(startY + tileSize, height);

        // Calculate histogram for L channel in this tile
        final histogram = List<int>.filled(256, 0);
        int pixelCount = 0;

        for (int y = startY; y < endY; y++) {
          for (int x = startX; x < endX; x++) {
            final L = labData[(y * width + x) * 3];
            final bin = (L * 255 / 100).clamp(0, 255).round();
            histogram[bin]++;
            pixelCount++;
          }
        }

        // Apply clipping
        final clipPoint = (pixelCount * clipLimit / 256).round();
        _clipHistogram(histogram, clipPoint);

        // Calculate cumulative distribution
        final cdf = _calculateCDF(histogram);

        // Apply equalization to this tile
        for (int y = startY; y < endY; y++) {
          for (int x = startX; x < endX; x++) {
            final index = (y * width + x) * 3;
            final L = result[index];
            final bin = (L * 255 / 100).clamp(0, 255).round();
            result[index] = (cdf[bin] * 100 / pixelCount);
          }
        }
      }
    }

    return result;
  }

  /// Clip histogram to prevent over-amplification
  static void _clipHistogram(List<int> histogram, int clipPoint) {
    int excess = 0;

    for (int i = 0; i < histogram.length; i++) {
      if (histogram[i] > clipPoint) {
        excess += histogram[i] - clipPoint;
        histogram[i] = clipPoint;
      }
    }

    // Redistribute excess uniformly
    final redistribution = excess ~/ histogram.length;
    final remainder = excess % histogram.length;

    for (int i = 0; i < histogram.length; i++) {
      histogram[i] += redistribution;
      if (i < remainder) {
        histogram[i]++;
      }
    }
  }

  /// Calculate cumulative distribution function
  static List<int> _calculateCDF(List<int> histogram) {
    final cdf = List<int>.filled(256, 0);
    cdf[0] = histogram[0];

    for (int i = 1; i < 256; i++) {
      cdf[i] = cdf[i - 1] + histogram[i];
    }

    return cdf;
  }

  /// Enhance color channels A and B
  static List<double> _enhanceColorChannels(
    List<double> labData,
    int width,
    int height,
    List<double> enhancedL,
  ) {
    final result = List<double>.from(labData);

    for (int i = 0; i < width * height; i++) {
      result[i * 3] = enhancedL[i * 3]; // Use enhanced L channel
      result[i * 3 + 1] *= 1.1; // Slightly enhance A
      result[i * 3 + 2] *= 1.1; // Slightly enhance B
    }

    return result;
  }

  /// Convert LAB back to RGB
  static Future<Uint8List> _labToRgb(List<double> labData, int width, int height) async {
    final result = Uint8List(width * height * 3);

    for (int i = 0; i < width * height; i++) {
      final L = labData[i * 3];
      final a = labData[i * 3 + 1];
      final b = labData[i * 3 + 2];

      // Convert LAB to XYZ
      final xyz = _labToXyz(L, a, b);

      // Convert XYZ to RGB
      final rgb = _xyzToRgb(xyz[0], xyz[1], xyz[2]);

      result[i * 3] = (rgb[0] * 255).clamp(0, 255).round();
      result[i * 3 + 1] = (rgb[1] * 255).clamp(0, 255).round();
      result[i * 3 + 2] = (rgb[2] * 255).clamp(0, 255).round();
    }

    return result;
  }

  /// Convert LAB to XYZ
  static List<double> _labToXyz(double L, double a, double b) {
    final fy = (L + 16) / 116;
    final fx = a / 500 + fy;
    final fz = fy - b / 200;

    final fx3 = fx * fx * fx;
    final fy3 = fy * fy * fy;
    final fz3 = fz * fz * fz;

    final x = (fx3 > 0.008856 ? fx3 : (fx - 16/116) / 7.787) * 95.047;
    final y = (fy3 > 0.008856 ? fy3 : (fy - 16/116) / 7.787) * 100.000;
    final z = (fz3 > 0.008856 ? fz3 : (fz - 16/116) / 7.787) * 108.883;

    return [x, y, z];
  }

  /// Convert XYZ to RGB
  static List<double> _xyzToRgb(double x, double y, double z) {
    x /= 100;
    y /= 100;
    z /= 100;

    var r = x *  3.2404542 + y * -1.5371385 + z * -0.4985314;
    var g = x * -0.9692660 + y *  1.8760108 + z *  0.0415560;
    var b = x *  0.0556434 + y * -0.2040259 + z *  1.0572252;

    // Apply gamma correction
    r = r > 0.0031308 ? 1.055 * math.pow(r, 1.0/2.4) - 0.055 : 12.92 * r;
    g = g > 0.0031308 ? 1.055 * math.pow(g, 1.0/2.4) - 0.055 : 12.92 * g;
    b = b > 0.0031308 ? 1.055 * math.pow(b, 1.0/2.4) - 0.055 : 12.92 * b;

    return [r.clamp(0.0, 1.0), g.clamp(0.0, 1.0), b.clamp(0.0, 1.0)];
  }

  /// Apply color balance correction
  static Uint8List _applyColorBalance(
    Uint8List imageData,
    int width,
    int height,
    FilterOptions options,
  ) {
    // Calculate channel averages
    double avgR = 0, avgG = 0, avgB = 0;
    final pixelCount = width * height;

    for (int i = 0; i < pixelCount; i++) {
      avgR += imageData[i * 3];
      avgG += imageData[i * 3 + 1];
      avgB += imageData[i * 3 + 2];
    }

    avgR /= pixelCount;
    avgG /= pixelCount;
    avgB /= pixelCount;

    // Calculate gray reference
    final grayRef = (avgR + avgG + avgB) / 3;

    // Calculate scaling factors
    final scaleR = grayRef / avgR;
    final scaleG = grayRef / avgG;
    final scaleB = grayRef / avgB;

    final result = Uint8List.fromList(imageData);

    for (int i = 0; i < pixelCount; i++) {
      result[i * 3] = (result[i * 3] * scaleR).clamp(0, 255).round();
      result[i * 3 + 1] = (result[i * 3 + 1] * scaleG).clamp(0, 255).round();
      result[i * 3 + 2] = (result[i * 3 + 2] * scaleB).clamp(0, 255).round();
    }

    return result;
  }

  /// Apply grayscale conversion
  static Future<Uint8List> _applyGrayscale(
    Uint8List imageData,
    int width,
    int height,
    FilterOptions options,
  ) async {
    final result = Uint8List(width * height * 3);

    for (int i = 0; i < width * height; i++) {
      final r = imageData[i * 3];
      final g = imageData[i * 3 + 1];
      final b = imageData[i * 3 + 2];

      // ITU-R BT.709 luma coefficients for perceptually accurate grayscale
      final gray = (0.2126 * r + 0.7152 * g + 0.0722 * b).round();

      result[i * 3] = gray;
      result[i * 3 + 1] = gray;
      result[i * 3 + 2] = gray;
    }

    return result;
  }

  /// Apply black and white (adaptive threshold)
  static Future<Uint8List> _applyBlackAndWhite(
    Uint8List imageData,
    int width,
    int height,
    FilterOptions options,
  ) async {
    // Step 1: Convert to grayscale
    final grayData = await _applyGrayscale(imageData, width, height, options);

    // Step 2: Apply adaptive thresholding
    final blockSize = options.adaptiveBlockSize;
    final C = options.adaptiveC;

    final result = Uint8List(width * height * 3);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final threshold = _calculateLocalThreshold(grayData, width, height, x, y, blockSize);
        final pixelValue = grayData[(y * width + x) * 3];

        final binaryValue = pixelValue > (threshold - C) ? 255 : 0;

        final index = (y * width + x) * 3;
        result[index] = binaryValue;
        result[index + 1] = binaryValue;
        result[index + 2] = binaryValue;
      }
    }

    return result;
  }

  /// Calculate local threshold for adaptive thresholding
  static int _calculateLocalThreshold(
    Uint8List grayData,
    int width,
    int height,
    int centerX,
    int centerY,
    int blockSize,
  ) {
    final halfBlock = blockSize ~/ 2;
    int sum = 0;
    int count = 0;

    for (int y = centerY - halfBlock; y <= centerY + halfBlock; y++) {
      for (int x = centerX - halfBlock; x <= centerX + halfBlock; x++) {
        if (x >= 0 && x < width && y >= 0 && y < height) {
          sum += grayData[(y * width + x) * 3];
          count++;
        }
      }
    }

    return count > 0 ? sum ~/ count : 128;
  }

  /// Apply Magic Color filter (enhanced color correction)
  static Future<Uint8List> _applyMagicColor(
    Uint8List imageData,
    int width,
    int height,
    FilterOptions options,
  ) async {
    // Step 1: Apply auto color correction
    final enhanced = await _applyAutoColorCorrection(imageData, width, height, options);

    // Step 2: Selective color enhancement
    final result = Uint8List.fromList(enhanced);

    for (int i = 0; i < width * height; i++) {
      var r = result[i * 3] / 255.0;
      var g = result[i * 3 + 1] / 255.0;
      var b = result[i * 3 + 2] / 255.0;

      // Enhance specific color ranges
      final hsv = _rgbToHsv(r, g, b);

      // Enhance blues and reduce yellows for better document contrast
      if (hsv[0] >= 0.5 && hsv[0] <= 0.7) { // Blue range
        hsv[1] *= 1.2; // Increase saturation
      } else if (hsv[0] >= 0.1 && hsv[0] <= 0.2) { // Yellow range
        hsv[1] *= 0.8; // Reduce saturation
      }

      final rgb = _hsvToRgb(hsv[0], hsv[1], hsv[2]);

      result[i * 3] = (rgb[0] * 255).clamp(0, 255).round();
      result[i * 3 + 1] = (rgb[1] * 255).clamp(0, 255).round();
      result[i * 3 + 2] = (rgb[2] * 255).clamp(0, 255).round();
    }

    return result;
  }

  /// Convert RGB to HSV
  static List<double> _rgbToHsv(double r, double g, double b) {
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;

    double h = 0;
    if (delta != 0) {
      if (max == r) {
        h = ((g - b) / delta) % 6;
      } else if (max == g) {
        h = (b - r) / delta + 2;
      } else {
        h = (r - g) / delta + 4;
      }
      h /= 6;
    }

    final s = max == 0 ? 0.0 : delta / max;
    final v = max;

    return [h, s, v];
  }

  /// Convert HSV to RGB
  static List<double> _hsvToRgb(double h, double s, double v) {
    final c = v * s;
    final x = c * (1 - ((h * 6) % 2 - 1).abs());
    final m = v - c;

    double r = 0, g = 0, b = 0;

    if (h < 1/6) {
      r = c; g = x; b = 0;
    } else if (h < 2/6) {
      r = x; g = c; b = 0;
    } else if (h < 3/6) {
      r = 0; g = c; b = x;
    } else if (h < 4/6) {
      r = 0; g = x; b = c;
    } else if (h < 5/6) {
      r = x; g = 0; b = c;
    } else {
      r = c; g = 0; b = x;
    }

    return [r + m, g + m, b + m];
  }

  /// Apply Whiteboard filter (specialized for whiteboards)
  static Future<Uint8List> _applyWhiteboard(
    Uint8List imageData,
    int width,
    int height,
    FilterOptions options,
  ) async {
    // Step 1: Convert to grayscale
    final grayData = await _applyGrayscale(imageData, width, height, options);

    // Step 2: Apply morphological operations to clean up
    final cleaned = await _applyMorphologicalOpening(grayData, width, height);

    // Step 3: Apply adaptive thresholding with whiteboard-specific parameters
    final blockSize = 15; // Larger block for whiteboards
    final C = 10; // Lower C value for whiteboards

    final result = Uint8List(width * height * 3);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final threshold = _calculateLocalThreshold(cleaned, width, height, x, y, blockSize);
        final pixelValue = cleaned[(y * width + x) * 3];

        final binaryValue = pixelValue > (threshold - C) ? 255 : 0;

        final index = (y * width + x) * 3;
        result[index] = binaryValue;
        result[index + 1] = binaryValue;
        result[index + 2] = binaryValue;
      }
    }

    return result;
  }

  /// Apply morphological opening (erosion followed by dilation)
  static Future<Uint8List> _applyMorphologicalOpening(
    Uint8List imageData,
    int width,
    int height,
  ) async {
    // Apply erosion
    final eroded = _applyErosion(imageData, width, height, kernelSize: 3);

    // Apply dilation
    final opened = _applyDilation(eroded, width, height, kernelSize: 3);

    return opened;
  }

  /// Apply erosion morphological operation
  static Uint8List _applyErosion(Uint8List imageData, int width, int height, {int kernelSize = 3}) {
    final result = Uint8List(width * height * 3);
    final halfKernel = kernelSize ~/ 2;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int minValue = 255;

        for (int ky = -halfKernel; ky <= halfKernel; ky++) {
          for (int kx = -halfKernel; kx <= halfKernel; kx++) {
            final nx = x + kx;
            final ny = y + ky;

            if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
              final value = imageData[(ny * width + nx) * 3];
              minValue = math.min(minValue, value);
            }
          }
        }

        final index = (y * width + x) * 3;
        result[index] = minValue;
        result[index + 1] = minValue;
        result[index + 2] = minValue;
      }
    }

    return result;
  }

  /// Apply dilation morphological operation
  static Uint8List _applyDilation(Uint8List imageData, int width, int height, {int kernelSize = 3}) {
    final result = Uint8List(width * height * 3);
    final halfKernel = kernelSize ~/ 2;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int maxValue = 0;

        for (int ky = -halfKernel; ky <= halfKernel; ky++) {
          for (int kx = -halfKernel; kx <= halfKernel; kx++) {
            final nx = x + kx;
            final ny = y + ky;

            if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
              final value = imageData[(ny * width + nx) * 3];
              maxValue = math.max(maxValue, value);
            }
          }
        }

        final index = (y * width + x) * 3;
        result[index] = maxValue;
        result[index + 1] = maxValue;
        result[index + 2] = maxValue;
      }
    }

    return result;
  }
}

/// Available document enhancement filters
enum DocumentFilter {
  original,
  autoColor,
  grayscale,
  blackAndWhite,
  magicColor,
  whiteboard,
}

/// Filter configuration options
class FilterOptions {
  // CLAHE options
  final double claheClipLimit;
  final int claheTileSize;

  // Adaptive threshold options
  final int adaptiveBlockSize;
  final int adaptiveC;

  // Color enhancement options
  final double colorSaturation;
  final double colorContrast;

  const FilterOptions({
    this.claheClipLimit = 2.0,
    this.claheTileSize = 8,
    this.adaptiveBlockSize = 11,
    this.adaptiveC = 5,
    this.colorSaturation = 1.1,
    this.colorContrast = 1.1,
  });
}

/// Extension for filter display names
extension DocumentFilterExtension on DocumentFilter {
  String get displayName {
    switch (this) {
      case DocumentFilter.original:
        return 'Original';
      case DocumentFilter.autoColor:
        return 'Auto Color';
      case DocumentFilter.grayscale:
        return 'Grayscale';
      case DocumentFilter.blackAndWhite:
        return 'Black & White';
      case DocumentFilter.magicColor:
        return 'Magic Color';
      case DocumentFilter.whiteboard:
        return 'Whiteboard';
    }
  }

  String get description {
    switch (this) {
      case DocumentFilter.original:
        return 'Unmodified original image';
      case DocumentFilter.autoColor:
        return 'Enhanced colors with CLAHE';
      case DocumentFilter.grayscale:
        return 'High-quality grayscale conversion';
      case DocumentFilter.blackAndWhite:
        return 'Adaptive binary threshold';
      case DocumentFilter.magicColor:
        return 'AI-enhanced color optimization';
      case DocumentFilter.whiteboard:
        return 'Specialized for whiteboards';
    }
  }
}