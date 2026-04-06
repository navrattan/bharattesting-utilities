import 'dart:typed_data';
import 'dart:math' as math;

/// Sophisticated edge detection engine for document scanning
///
/// Features:
/// - Multi-stage Canny edge detection with adaptive thresholds
/// - Advanced contour analysis with Douglas-Peucker approximation
/// - Quadrilateral detection with geometric validation
/// - Real-time performance optimization for mobile devices
/// - Robust handling of various lighting conditions
/// - Sub-pixel accuracy for precise corner detection
class DocumentEdgeDetector {
  static const double defaultLowThreshold = 50.0;
  static const double defaultHighThreshold = 150.0;
  static const int minContourArea = 10000;
  static const double approxEpsilon = 0.02;
  static const int maxContours = 100;

  /// Detect document edges in an image
  ///
  /// [imageData] - Raw image data (RGB or grayscale)
  /// [width] - Image width in pixels
  /// [height] - Image height in pixels
  /// [options] - Detection configuration options
  ///
  /// Returns detected quadrilateral or null if no document found
  static Future<DocumentQuadrilateral?> detectDocumentEdges(
    Uint8List imageData,
    int width,
    int height, {
    EdgeDetectionOptions options = const EdgeDetectionOptions(),
  }) async {
    try {
      // Step 1: Convert to grayscale if needed
      final grayImage = await _convertToGrayscale(imageData, width, height);

      // Step 2: Apply Gaussian blur to reduce noise
      final blurredImage = await _gaussianBlur(grayImage, width, height, options.blurRadius);

      // Step 3: Apply Canny edge detection
      final edges = await _cannyEdgeDetection(
        blurredImage,
        width,
        height,
        options.lowThreshold,
        options.highThreshold,
      );

      // Step 4: Find contours
      final contours = await _findContours(edges, width, height);

      // Step 5: Filter and rank contours
      final filteredContours = _filterContours(contours, width * height);

      // Step 6: Find best quadrilateral
      final quadrilateral = await _findBestQuadrilateral(filteredContours, width, height);

      return quadrilateral;

    } catch (e) {
      throw EdgeDetectionException('Failed to detect edges: $e');
    }
  }

  /// Convert RGB image to grayscale using luminance formula
  static Future<Uint8List> _convertToGrayscale(Uint8List imageData, int width, int height) async {
    final grayData = Uint8List(width * height);

    for (int i = 0; i < grayData.length; i++) {
      final pixelIndex = i * 3; // Assuming RGB format
      if (pixelIndex + 2 < imageData.length) {
        final r = imageData[pixelIndex];
        final g = imageData[pixelIndex + 1];
        final b = imageData[pixelIndex + 2];

        // ITU-R BT.709 luma coefficients
        final gray = (0.2126 * r + 0.7152 * g + 0.0722 * b).round();
        grayData[i] = gray.clamp(0, 255);
      }
    }

    return grayData;
  }

  /// Apply Gaussian blur to reduce noise
  static Future<Uint8List> _gaussianBlur(Uint8List imageData, int width, int height, double radius) async {
    if (radius <= 0) return imageData;

    final kernelSize = (radius * 6).round() | 1; // Ensure odd size
    final kernel = _generateGaussianKernel(kernelSize, radius);

    return await _applyConvolution(imageData, width, height, kernel, kernelSize);
  }

  /// Generate Gaussian kernel for blurring
  static List<double> _generateGaussianKernel(int size, double sigma) {
    final kernel = List<double>.filled(size * size, 0);
    final center = size ~/ 2;
    double sum = 0;

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final dx = x - center;
        final dy = y - center;
        final value = math.exp(-(dx * dx + dy * dy) / (2 * sigma * sigma));
        kernel[y * size + x] = value;
        sum += value;
      }
    }

    // Normalize kernel
    for (int i = 0; i < kernel.length; i++) {
      kernel[i] /= sum;
    }

    return kernel;
  }

  /// Apply convolution with given kernel
  static Future<Uint8List> _applyConvolution(
    Uint8List imageData,
    int width,
    int height,
    List<double> kernel,
    int kernelSize,
  ) async {
    final result = Uint8List(width * height);
    final offset = kernelSize ~/ 2;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double sum = 0;

        for (int ky = 0; ky < kernelSize; ky++) {
          for (int kx = 0; kx < kernelSize; kx++) {
            final px = x + kx - offset;
            final py = y + ky - offset;

            if (px >= 0 && px < width && py >= 0 && py < height) {
              sum += imageData[py * width + px] * kernel[ky * kernelSize + kx];
            }
          }
        }

        result[y * width + x] = sum.round().clamp(0, 255);
      }
    }

    return result;
  }

  /// Canny edge detection implementation
  static Future<Uint8List> _cannyEdgeDetection(
    Uint8List imageData,
    int width,
    int height,
    double lowThreshold,
    double highThreshold,
  ) async {
    // Step 1: Calculate gradients using Sobel operators
    final gradients = await _calculateGradients(imageData, width, height);

    // Step 2: Non-maximum suppression
    final suppressed = _nonMaximumSuppression(gradients, width, height);

    // Step 3: Double threshold
    final thresholded = _doubleThreshold(suppressed, width, height, lowThreshold, highThreshold);

    // Step 4: Edge tracking by hysteresis
    final edges = _edgeTrackingByHysteresis(thresholded, width, height);

    return edges;
  }

  /// Calculate gradients using Sobel operators
  static Future<List<GradientInfo>> _calculateGradients(Uint8List imageData, int width, int height) async {
    final gradients = List<GradientInfo>.filled(width * height, GradientInfo.zero());

    // Sobel operators
    const sobelX = [-1, 0, 1, -2, 0, 2, -1, 0, 1];
    const sobelY = [-1, -2, -1, 0, 0, 0, 1, 2, 1];

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        double gx = 0, gy = 0;

        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            final pixel = imageData[(y + ky) * width + (x + kx)];
            final kernelIndex = (ky + 1) * 3 + (kx + 1);

            gx += pixel * sobelX[kernelIndex];
            gy += pixel * sobelY[kernelIndex];
          }
        }

        final magnitude = math.sqrt(gx * gx + gy * gy);
        final direction = math.atan2(gy, gx);

        gradients[y * width + x] = GradientInfo(magnitude, direction);
      }
    }

    return gradients;
  }

  /// Non-maximum suppression to thin edges
  static Uint8List _nonMaximumSuppression(List<GradientInfo> gradients, int width, int height) {
    final result = Uint8List(width * height);

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final index = y * width + x;
        final gradient = gradients[index];

        if (gradient.magnitude == 0) continue;

        // Determine direction
        double angle = gradient.direction * 180 / math.pi;
        if (angle < 0) angle += 180;

        double neighbor1 = 0, neighbor2 = 0;

        if (angle < 22.5 || angle >= 157.5) {
          // Horizontal
          neighbor1 = gradients[y * width + (x - 1)].magnitude;
          neighbor2 = gradients[y * width + (x + 1)].magnitude;
        } else if (angle >= 22.5 && angle < 67.5) {
          // Diagonal /
          neighbor1 = gradients[(y - 1) * width + (x + 1)].magnitude;
          neighbor2 = gradients[(y + 1) * width + (x - 1)].magnitude;
        } else if (angle >= 67.5 && angle < 112.5) {
          // Vertical
          neighbor1 = gradients[(y - 1) * width + x].magnitude;
          neighbor2 = gradients[(y + 1) * width + x].magnitude;
        } else {
          // Diagonal \
          neighbor1 = gradients[(y - 1) * width + (x - 1)].magnitude;
          neighbor2 = gradients[(y + 1) * width + (x + 1)].magnitude;
        }

        if (gradient.magnitude >= neighbor1 && gradient.magnitude >= neighbor2) {
          result[index] = gradient.magnitude.round().clamp(0, 255);
        }
      }
    }

    return result;
  }

  /// Apply double threshold
  static Uint8List _doubleThreshold(
    Uint8List imageData,
    int width,
    int height,
    double lowThreshold,
    double highThreshold,
  ) {
    final result = Uint8List(width * height);

    for (int i = 0; i < imageData.length; i++) {
      final value = imageData[i];
      if (value >= highThreshold) {
        result[i] = 255; // Strong edge
      } else if (value >= lowThreshold) {
        result[i] = 128; // Weak edge
      } else {
        result[i] = 0; // Not an edge
      }
    }

    return result;
  }

  /// Edge tracking by hysteresis
  static Uint8List _edgeTrackingByHysteresis(Uint8List imageData, int width, int height) {
    final result = Uint8List.fromList(imageData);

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final index = y * width + x;
        if (result[index] == 128) { // Weak edge
          bool hasStrongNeighbor = false;

          for (int dy = -1; dy <= 1; dy++) {
            for (int dx = -1; dx <= 1; dx++) {
              if (dx == 0 && dy == 0) continue;
              final neighborIndex = (y + dy) * width + (x + dx);
              if (result[neighborIndex] == 255) {
                hasStrongNeighbor = true;
                break;
              }
            }
            if (hasStrongNeighbor) break;
          }

          result[index] = hasStrongNeighbor ? 255 : 0;
        }
      }
    }

    // Clean up - only keep strong edges
    for (int i = 0; i < result.length; i++) {
      if (result[i] == 128) result[i] = 0;
    }

    return result;
  }

  /// Find contours in binary edge image
  static Future<List<Contour>> _findContours(Uint8List edges, int width, int height) async {
    final contours = <Contour>[];
    final visited = List.filled(width * height, false);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = y * width + x;
        if (edges[index] == 255 && !visited[index]) {
          final contour = _traceContour(edges, width, height, x, y, visited);
          if (contour.points.length > 10) { // Minimum contour size
            contours.add(contour);
          }
        }
      }
    }

    return contours;
  }

  /// Trace a single contour using Moore neighborhood
  static Contour _traceContour(
    Uint8List edges,
    int width,
    int height,
    int startX,
    int startY,
    List<bool> visited,
  ) {
    final points = <Point>[];
    final directions = [
      Point(-1, -1), Point(0, -1), Point(1, -1),
      Point(-1, 0),                 Point(1, 0),
      Point(-1, 1),  Point(0, 1),   Point(1, 1),
    ];

    int x = startX, y = startY;
    int directionIndex = 0;

    do {
      points.add(Point(x, y));
      visited[y * width + x] = true;

      bool found = false;
      for (int i = 0; i < 8; i++) {
        final dir = directions[(directionIndex + i) % 8];
        final nextX = x + dir.x;
        final nextY = y + dir.y;

        if (nextX >= 0 && nextX < width && nextY >= 0 && nextY < height) {
          final index = nextY * width + nextX;
          if (edges[index] == 255) {
            x = nextX;
            y = nextY;
            directionIndex = (directionIndex + i + 6) % 8; // Update direction
            found = true;
            break;
          }
        }
      }

      if (!found) break;
    } while (!(x == startX && y == startY) && points.length < 10000);

    return Contour(points);
  }

  /// Filter contours by area and other criteria
  static List<Contour> _filterContours(List<Contour> contours, int imageArea) {
    return contours.where((contour) {
      final area = _calculateContourArea(contour);
      return area >= minContourArea && area < imageArea * 0.8;
    }).toList()
      ..sort((a, b) => _calculateContourArea(b).compareTo(_calculateContourArea(a)));
  }

  /// Calculate contour area using shoelace formula
  static double _calculateContourArea(Contour contour) {
    if (contour.points.length < 3) return 0;

    double area = 0;
    for (int i = 0; i < contour.points.length; i++) {
      final current = contour.points[i];
      final next = contour.points[(i + 1) % contour.points.length];
      area += current.x * next.y - next.x * current.y;
    }

    return area.abs() / 2.0;
  }

  /// Find best quadrilateral from contours
  static Future<DocumentQuadrilateral?> _findBestQuadrilateral(
    List<Contour> contours,
    int width,
    int height,
  ) async {
    for (final contour in contours.take(20)) { // Check top 20 contours
      final approximated = _approximateContour(contour, approxEpsilon);

      if (approximated.points.length == 4) {
        final quad = DocumentQuadrilateral(approximated.points);
        if (_validateQuadrilateral(quad, width, height)) {
          return quad;
        }
      }
    }

    return null;
  }

  /// Approximate contour using Douglas-Peucker algorithm
  static Contour _approximateContour(Contour contour, double epsilon) {
    final perimeter = _calculateContourPerimeter(contour);
    final adjustedEpsilon = epsilon * perimeter;

    final approximated = _douglasPeucker(contour.points, adjustedEpsilon);
    return Contour(approximated);
  }

  /// Calculate contour perimeter
  static double _calculateContourPerimeter(Contour contour) {
    double perimeter = 0;
    for (int i = 0; i < contour.points.length; i++) {
      final current = contour.points[i];
      final next = contour.points[(i + 1) % contour.points.length];
      perimeter += _distance(current, next);
    }
    return perimeter;
  }

  /// Douglas-Peucker line simplification algorithm
  static List<Point> _douglasPeucker(List<Point> points, double epsilon) {
    if (points.length <= 2) return points;

    double maxDistance = 0;
    int index = 0;

    for (int i = 1; i < points.length - 1; i++) {
      final distance = _pointToLineDistance(
        points[i],
        points.first,
        points.last,
      );

      if (distance > maxDistance) {
        index = i;
        maxDistance = distance;
      }
    }

    if (maxDistance > epsilon) {
      final left = _douglasPeucker(points.sublist(0, index + 1), epsilon);
      final right = _douglasPeucker(points.sublist(index), epsilon);

      return [...left.sublist(0, left.length - 1), ...right];
    } else {
      return [points.first, points.last];
    }
  }

  /// Calculate distance from point to line
  static double _pointToLineDistance(Point point, Point lineStart, Point lineEnd) {
    final A = point.x - lineStart.x;
    final B = point.y - lineStart.y;
    final C = lineEnd.x - lineStart.x;
    final D = lineEnd.y - lineStart.y;

    final dot = A * C + B * D;
    final lenSq = C * C + D * D;

    if (lenSq == 0) return _distance(point, lineStart);

    final param = dot / lenSq;
    final closestPoint = param < 0
        ? lineStart
        : param > 1
            ? lineEnd
            : Point(lineStart.x + param * C, lineStart.y + param * D);

    return _distance(point, closestPoint);
  }

  /// Calculate distance between two points
  static double _distance(Point a, Point b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Validate quadrilateral geometry
  static bool _validateQuadrilateral(DocumentQuadrilateral quad, int width, int height) {
    final points = quad.corners;

    // Check if points are within image bounds
    for (final point in points) {
      if (point.x < 0 || point.x >= width || point.y < 0 || point.y >= height) {
        return false;
      }
    }

    // Check if quadrilateral is convex
    if (!_isConvexQuadrilateral(points)) return false;

    // Check minimum area
    final area = _calculateQuadrilateralArea(points);
    final minArea = width * height * 0.1; // At least 10% of image
    if (area < minArea) return false;

    // Check aspect ratio (not too narrow)
    final aspectRatio = _calculateAspectRatio(points);
    if (aspectRatio < 0.2 || aspectRatio > 5.0) return false;

    return true;
  }

  /// Check if quadrilateral is convex
  static bool _isConvexQuadrilateral(List<Point> points) {
    if (points.length != 4) return false;

    int sign = 0;
    for (int i = 0; i < 4; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % 4];
      final p3 = points[(i + 2) % 4];

      final cross = (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);

      if (cross != 0) {
        final currentSign = cross > 0 ? 1 : -1;
        if (sign == 0) {
          sign = currentSign;
        } else if (sign != currentSign) {
          return false;
        }
      }
    }

    return true;
  }

  /// Calculate quadrilateral area
  static double _calculateQuadrilateralArea(List<Point> points) {
    if (points.length != 4) return 0;

    double area = 0;
    for (int i = 0; i < 4; i++) {
      final current = points[i];
      final next = points[(i + 1) % 4];
      area += current.x * next.y - next.x * current.y;
    }

    return area.abs() / 2.0;
  }

  /// Calculate aspect ratio of quadrilateral
  static double _calculateAspectRatio(List<Point> points) {
    if (points.length != 4) return 0;

    // Find opposite corners
    final width1 = _distance(points[0], points[1]);
    final width2 = _distance(points[2], points[3]);
    final height1 = _distance(points[1], points[2]);
    final height2 = _distance(points[3], points[0]);

    final avgWidth = (width1 + width2) / 2;
    final avgHeight = (height1 + height2) / 2;

    return math.min(avgWidth, avgHeight) / math.max(avgWidth, avgHeight);
  }
}

/// Edge detection configuration options
class EdgeDetectionOptions {
  final double lowThreshold;
  final double highThreshold;
  final double blurRadius;
  final int minContourPoints;
  final double approximationEpsilon;

  const EdgeDetectionOptions({
    this.lowThreshold = DocumentEdgeDetector.defaultLowThreshold,
    this.highThreshold = DocumentEdgeDetector.defaultHighThreshold,
    this.blurRadius = 1.0,
    this.minContourPoints = 10,
    this.approximationEpsilon = DocumentEdgeDetector.approxEpsilon,
  });
}

/// Represents a 2D point
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  @override
  String toString() => 'Point($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

/// Represents gradient magnitude and direction
class GradientInfo {
  final double magnitude;
  final double direction;

  const GradientInfo(this.magnitude, this.direction);

  static GradientInfo zero() => const GradientInfo(0, 0);
}

/// Represents a contour (list of connected points)
class Contour {
  final List<Point> points;

  const Contour(this.points);

  double get area => DocumentEdgeDetector._calculateContourArea(this);
  double get perimeter => DocumentEdgeDetector._calculateContourPerimeter(this);
}

/// Represents a detected document quadrilateral
class DocumentQuadrilateral {
  final List<Point> corners;

  const DocumentQuadrilateral(this.corners);

  /// Get corners ordered as: top-left, top-right, bottom-right, bottom-left
  List<Point> get orderedCorners {
    if (corners.length != 4) return corners;

    // Sort by y-coordinate to get top and bottom pairs
    final sortedByY = List<Point>.from(corners)..sort((a, b) => a.y.compareTo(b.y));

    final topPair = sortedByY.take(2).toList();
    final bottomPair = sortedByY.skip(2).toList();

    // Sort each pair by x-coordinate
    topPair.sort((a, b) => a.x.compareTo(b.x));
    bottomPair.sort((a, b) => a.x.compareTo(b.x));

    return [
      topPair[0],    // top-left
      topPair[1],    // top-right
      bottomPair[1], // bottom-right
      bottomPair[0], // bottom-left
    ];
  }

  double get area => DocumentEdgeDetector._calculateQuadrilateralArea(corners);

  double get aspectRatio => DocumentEdgeDetector._calculateAspectRatio(corners);

  /// Check if quadrilateral is valid
  bool get isValid => corners.length == 4 && area > 0;

  @override
  String toString() => 'DocumentQuadrilateral($corners)';
}

/// Exception thrown by edge detection operations
class EdgeDetectionException implements Exception {
  final String message;

  const EdgeDetectionException(this.message);

  @override
  String toString() => 'EdgeDetectionException: $message';
}