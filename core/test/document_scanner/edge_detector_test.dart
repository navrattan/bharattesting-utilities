import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:bharattesting_core/core.dart';

void main() {
  group('DocumentEdgeDetector', () {
    late Uint8List testImageData;
    const width = 640;
    const height = 480;

    setUp(() {
      // Create test image data (RGB format)
      testImageData = _createTestImage(width, height);
    });

    group('detectDocumentEdges', () {
      test('should detect edges in test image', () async {
        final result = await DocumentEdgeDetector.detectDocumentEdges(
          testImageData,
          width,
          height,
        );

        expect(result, isA<DocumentQuadrilateral?>());
        // Result may be null for simple test image
      });

      test('should handle custom detection options', () async {
        const options = EdgeDetectionOptions(
          lowThreshold: 30.0,
          highThreshold: 100.0,
          blurRadius: 2.0,
        );

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          testImageData,
          width,
          height,
          options: options,
        );

        expect(result, isA<DocumentQuadrilateral?>());
      });

      test('should handle empty image data', () async {
        expect(
          () => DocumentEdgeDetector.detectDocumentEdges(
            Uint8List(0),
            width,
            height,
          ),
          throwsA(isA<EdgeDetectionException>()),
        );
      });

      test('should handle invalid dimensions', () async {
        expect(
          () => DocumentEdgeDetector.detectDocumentEdges(
            testImageData,
            0,
            0,
          ),
          throwsA(isA<EdgeDetectionException>()),
        );
      });

      test('should detect quadrilateral in synthetic document', () async {
        final docImage = _createSyntheticDocumentImage(width, height);

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          docImage,
          width,
          height,
        );

        expect(result, isNotNull);
        if (result != null) {
          expect(result.corners, hasLength(4));
          expect(result.isValid, isTrue);
          expect(result.area, greaterThan(0));
        }
      });

      test('should handle very small images', () async {
        const smallWidth = 50;
        const smallHeight = 50;
        final smallImage = _createTestImage(smallWidth, smallHeight);

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          smallImage,
          smallWidth,
          smallHeight,
        );

        expect(result, isA<DocumentQuadrilateral?>());
      });

      test('should handle very large images efficiently', () async {
        const largeWidth = 2000;
        const largeHeight = 1500;
        final largeImage = _createTestImage(largeWidth, largeHeight);

        final stopwatch = Stopwatch()..start();

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          largeImage,
          largeWidth,
          largeHeight,
        );

        stopwatch.stop();

        expect(result, isA<DocumentQuadrilateral?>());
        expect(stopwatch.elapsedMilliseconds, lessThan(30000)); // Under 30 seconds
      });
    });

    group('Point', () {
      test('should create point correctly', () {
        const point = Point(10.5, 20.3);
        expect(point.x, equals(10.5));
        expect(point.y, equals(20.3));
      });

      test('should handle equality correctly', () {
        const point1 = Point(10.0, 20.0);
        const point2 = Point(10.0, 20.0);
        const point3 = Point(15.0, 25.0);

        expect(point1, equals(point2));
        expect(point1, isNot(equals(point3)));
      });

      test('should convert to string', () {
        const point = Point(10.5, 20.3);
        expect(point.toString(), equals('Point(10.5, 20.3)'));
      });
    });

    group('DocumentQuadrilateral', () {
      test('should create valid quadrilateral', () {
        final corners = [
          const Point(0, 0),
          const Point(100, 0),
          const Point(100, 100),
          const Point(0, 100),
        ];

        final quad = DocumentQuadrilateral(corners);
        expect(quad.corners, equals(corners));
        expect(quad.isValid, isTrue);
        expect(quad.area, greaterThan(0));
      });

      test('should order corners correctly', () {
        final unorderedCorners = [
          const Point(100, 100), // bottom-right
          const Point(0, 0),     // top-left
          const Point(0, 100),   // bottom-left
          const Point(100, 0),   // top-right
        ];

        final quad = DocumentQuadrilateral(unorderedCorners);
        final ordered = quad.orderedCorners;

        expect(ordered[0], equals(const Point(0, 0)));     // top-left
        expect(ordered[1], equals(const Point(100, 0)));   // top-right
        expect(ordered[2], equals(const Point(100, 100))); // bottom-right
        expect(ordered[3], equals(const Point(0, 100)));   // bottom-left
      });

      test('should calculate aspect ratio correctly', () {
        final square = DocumentQuadrilateral([
          const Point(0, 0),
          const Point(100, 0),
          const Point(100, 100),
          const Point(0, 100),
        ]);

        expect(square.aspectRatio, closeTo(1.0, 0.1));

        final rectangle = DocumentQuadrilateral([
          const Point(0, 0),
          const Point(200, 0),
          const Point(200, 100),
          const Point(0, 100),
        ]);

        expect(rectangle.aspectRatio, closeTo(0.5, 0.1));
      });

      test('should handle invalid quadrilateral', () {
        final invalidCorners = [
          const Point(0, 0),
          const Point(10, 0),
        ]; // Only 2 points

        final quad = DocumentQuadrilateral(invalidCorners);
        expect(quad.isValid, isFalse);
      });

      test('should calculate area correctly', () {
        final square = DocumentQuadrilateral([
          const Point(0, 0),
          const Point(10, 0),
          const Point(10, 10),
          const Point(0, 10),
        ]);

        expect(square.area, equals(100));
      });
    });

    group('Contour', () {
      test('should create contour correctly', () {
        final points = [
          const Point(0, 0),
          const Point(10, 0),
          const Point(10, 10),
          const Point(0, 10),
        ];

        final contour = Contour(points);
        expect(contour.points, equals(points));
        expect(contour.area, greaterThan(0));
        expect(contour.perimeter, greaterThan(0));
      });

      test('should calculate perimeter correctly', () {
        final square = Contour([
          const Point(0, 0),
          const Point(10, 0),
          const Point(10, 10),
          const Point(0, 10),
        ]);

        expect(square.perimeter, equals(40));
      });
    });

    group('EdgeDetectionOptions', () {
      test('should use default values', () {
        const options = EdgeDetectionOptions();
        expect(options.lowThreshold, equals(DocumentEdgeDetector.defaultLowThreshold));
        expect(options.highThreshold, equals(DocumentEdgeDetector.defaultHighThreshold));
        expect(options.blurRadius, equals(1.0));
      });

      test('should accept custom values', () {
        const options = EdgeDetectionOptions(
          lowThreshold: 25.0,
          highThreshold: 75.0,
          blurRadius: 2.5,
        );

        expect(options.lowThreshold, equals(25.0));
        expect(options.highThreshold, equals(75.0));
        expect(options.blurRadius, equals(2.5));
      });
    });

    group('Error Handling', () {
      test('EdgeDetectionException should provide useful information', () {
        const exception = EdgeDetectionException('Test error message');
        expect(exception.message, equals('Test error message'));
        expect(exception.toString(), contains('Test error message'));
      });
    });

    group('Performance Tests', () {
      test('should process typical document size efficiently', () async {
        const docWidth = 1200;
        const docHeight = 1600;
        final docImage = _createSyntheticDocumentImage(docWidth, docHeight);

        final stopwatch = Stopwatch()..start();

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          docImage,
          docWidth,
          docHeight,
        );

        stopwatch.stop();

        expect(result, isA<DocumentQuadrilateral?>());
        expect(stopwatch.elapsedMilliseconds, lessThan(15000)); // Under 15 seconds
      });

      test('should handle multiple consecutive detections', () async {
        const iterations = 5;
        final times = <int>[];

        for (int i = 0; i < iterations; i++) {
          final stopwatch = Stopwatch()..start();

          await DocumentEdgeDetector.detectDocumentEdges(
            testImageData,
            width,
            height,
          );

          stopwatch.stop();
          times.add(stopwatch.elapsedMilliseconds);
        }

        // All iterations should complete reasonably quickly
        expect(times.every((time) => time < 10000), isTrue); // Under 10s per iteration
      });
    });

    group('Edge Cases', () {
      test('should handle uniform color image', () async {
        final uniformImage = _createUniformColorImage(width, height, 128);

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          uniformImage,
          width,
          height,
        );

        // Should not crash, but likely no edges detected
        expect(result, isA<DocumentQuadrilateral?>());
      });

      test('should handle high contrast image', () async {
        final highContrastImage = _createHighContrastImage(width, height);

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          highContrastImage,
          width,
          height,
        );

        expect(result, isA<DocumentQuadrilateral?>());
      });

      test('should handle image with noise', () async {
        final noisyImage = _createNoisyImage(width, height);

        final result = await DocumentEdgeDetector.detectDocumentEdges(
          noisyImage,
          width,
          height,
        );

        expect(result, isA<DocumentQuadrilateral?>());
      });
    });
  });
}

/// Create test image data (RGB format)
Uint8List _createTestImage(int width, int height) {
  final data = Uint8List(width * height * 3);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final index = (y * width + x) * 3;
      data[index] = ((x + y) % 256); // R
      data[index + 1] = ((x * y) % 256); // G
      data[index + 2] = ((x - y) % 256).abs(); // B
    }
  }

  return data;
}

/// Create synthetic document image with clear edges
Uint8List _createSyntheticDocumentImage(int width, int height) {
  final data = Uint8List(width * height * 3);

  // Fill with white background
  data.fillRange(0, data.length, 255);

  // Create a dark rectangle (document)
  final docLeft = (width * 0.2).round();
  final docRight = (width * 0.8).round();
  final docTop = (height * 0.1).round();
  final docBottom = (height * 0.9).round();

  for (int y = docTop; y < docBottom; y++) {
    for (int x = docLeft; x < docRight; x++) {
      final index = (y * width + x) * 3;
      data[index] = 50;     // Dark gray
      data[index + 1] = 50;
      data[index + 2] = 50;
    }
  }

  // Add border for clearer edge detection
  for (int y = docTop; y < docBottom; y++) {
    for (int x = docLeft; x < docLeft + 2; x++) { // Left border
      final index = (y * width + x) * 3;
      data[index] = 0;
      data[index + 1] = 0;
      data[index + 2] = 0;
    }
    for (int x = docRight - 2; x < docRight; x++) { // Right border
      final index = (y * width + x) * 3;
      data[index] = 0;
      data[index + 1] = 0;
      data[index + 2] = 0;
    }
  }

  for (int x = docLeft; x < docRight; x++) {
    for (int y = docTop; y < docTop + 2; y++) { // Top border
      final index = (y * width + x) * 3;
      data[index] = 0;
      data[index + 1] = 0;
      data[index + 2] = 0;
    }
    for (int y = docBottom - 2; y < docBottom; y++) { // Bottom border
      final index = (y * width + x) * 3;
      data[index] = 0;
      data[index + 1] = 0;
      data[index + 2] = 0;
    }
  }

  return data;
}

/// Create uniform color image
Uint8List _createUniformColorImage(int width, int height, int grayValue) {
  final data = Uint8List(width * height * 3);
  data.fillRange(0, data.length, grayValue);
  return data;
}

/// Create high contrast image
Uint8List _createHighContrastImage(int width, int height) {
  final data = Uint8List(width * height * 3);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final index = (y * width + x) * 3;
      final value = ((x + y) % 2 == 0) ? 0 : 255; // Checkerboard pattern

      data[index] = value;
      data[index + 1] = value;
      data[index + 2] = value;
    }
  }

  return data;
}

/// Create noisy image
Uint8List _createNoisyImage(int width, int height) {
  final data = _createTestImage(width, height);
  final random = List.generate(1000, (i) => (i * 17) % 256);

  // Add random noise
  for (int i = 0; i < data.length; i += 10) {
    final noise = random[i % random.length] - 128;
    data[i] = (data[i] + noise).clamp(0, 255);
  }

  return data;
}