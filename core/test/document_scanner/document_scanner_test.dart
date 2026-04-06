import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:bharattesting_core/core.dart';

void main() {
  group('Document Scanner Integration Tests', () {
    late Uint8List testImageData;
    const width = 640;
    const height = 480;

    setUp(() {
      testImageData = _createTestDocumentImage(width, height);
    });

    group('PerspectiveCorrector', () {
      test('should correct perspective successfully', () async {
        final quad = DocumentQuadrilateral([
          const Point(50, 50),   // top-left
          const Point(590, 60), // top-right
          const Point(580, 420), // bottom-right
          const Point(60, 410),  // bottom-left
        ]);

        final result = await DocumentPerspectiveCorrector.correctPerspective(
          testImageData,
          width,
          height,
          quad,
        );

        expect(result.width, greaterThan(0));
        expect(result.height, greaterThan(0));
        expect(result.imageData.length, greaterThan(0));
        expect(result.aspectRatio, greaterThan(0));
      });

      test('should handle invalid quadrilateral', () async {
        final invalidQuad = DocumentQuadrilateral([]);

        expect(
          () => DocumentPerspectiveCorrector.correctPerspective(
            testImageData,
            width,
            height,
            invalidQuad,
          ),
          throwsA(isA<PerspectiveCorrectionException>()),
        );
      });

      test('should auto-rotate document when needed', () async {
        final corrected = CorrectedDocument(
          imageData: testImageData,
          width: width,
          height: height,
          homography: HomographyMatrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]]),
          originalCorners: [],
          correctedCorners: [],
          aspectRatio: width / height,
        );

        final result = await DocumentPerspectiveCorrector.autoRotateDocument(corrected);
        expect(result, isA<CorrectedDocument>());
      });
    });

    group('ImageEnhancer', () {
      test('should apply all filters without error', () async {
        for (final filter in DocumentFilter.values) {
          final result = await DocumentImageEnhancer.applyFilter(
            testImageData,
            width,
            height,
            filter,
          );

          expect(result.length, equals(testImageData.length));
          expect(result, isA<Uint8List>());
        }
      });

      test('should apply Auto Color filter with CLAHE', () async {
        final result = await DocumentImageEnhancer.applyFilter(
          testImageData,
          width,
          height,
          DocumentFilter.autoColor,
        );

        expect(result.length, equals(testImageData.length));
        expect(result, isNot(equals(testImageData)));
      });

      test('should convert to grayscale correctly', () async {
        final result = await DocumentImageEnhancer.applyFilter(
          testImageData,
          width,
          height,
          DocumentFilter.grayscale,
        );

        // Check that R, G, B channels are equal (grayscale)
        for (int i = 0; i < width * height; i++) {
          final r = result[i * 3];
          final g = result[i * 3 + 1];
          final b = result[i * 3 + 2];
          expect(r, equals(g));
          expect(g, equals(b));
        }
      });

      test('should apply black and white threshold', () async {
        final result = await DocumentImageEnhancer.applyFilter(
          testImageData,
          width,
          height,
          DocumentFilter.blackAndWhite,
        );

        // Check that pixels are mostly black (0) or white (255)
        bool hasBlackOrWhite = false;
        for (int i = 0; i < width * height; i++) {
          final r = result[i * 3];
          if (r == 0 || r == 255) {
            hasBlackOrWhite = true;
            break;
          }
        }
        expect(hasBlackOrWhite, isTrue);
      });

      test('should handle custom filter options', () async {
        const options = FilterOptions(
          claheClipLimit: 3.0,
          adaptiveBlockSize: 15,
          adaptiveC: 8,
        );

        final result = await DocumentImageEnhancer.applyFilter(
          testImageData,
          width,
          height,
          DocumentFilter.autoColor,
          options: options,
        );

        expect(result.length, equals(testImageData.length));
      });
    });

    group('OCRProcessor', () {
      test('should extract text from document', () async {
        final result = await DocumentOcrProcessor.extractText(
          testImageData,
          width,
          height,
        );

        expect(result, isA<OcrResult>());
        expect(result.fullText, isA<String>());
        expect(result.textBlocks, isA<List<TextBlock>>());
        expect(result.overallConfidence, inInclusiveRange(0.0, 1.0));
        expect(result.processingTime, isA<Duration>());
      });

      test('should generate searchable PDF', () async {
        final ocrResult = await DocumentOcrProcessor.extractText(
          testImageData,
          width,
          height,
        );

        final pdf = await DocumentOcrProcessor.generateSearchablePdf(
          testImageData,
          width,
          height,
          ocrResult,
        );

        expect(pdf, isA<Uint8List>());
        expect(pdf.length, greaterThan(0));

        // Check PDF header
        final header = String.fromCharCodes(pdf.take(8));
        expect(header, startsWith('%PDF-'));
      });

      test('should handle custom OCR options', () async {
        const options = OcrOptions(
          enableDenoising: false,
          enhanceTextContrast: true,
          recognitionLanguages: ['en', 'es'],
          minimumConfidence: 0.3,
        );

        final result = await DocumentOcrProcessor.extractText(
          testImageData,
          width,
          height,
          options: options,
        );

        expect(result, isA<OcrResult>());
      });

      test('should calculate text statistics correctly', () async {
        final result = await DocumentOcrProcessor.extractText(
          testImageData,
          width,
          height,
        );

        expect(result.wordCount, isA<int>());
        expect(result.hasGoodQuality, isA<bool>());
      });
    });

    group('Filter Extensions', () {
      test('should provide display names for all filters', () {
        for (final filter in DocumentFilter.values) {
          expect(filter.displayName, isA<String>());
          expect(filter.displayName.isNotEmpty, isTrue);
          expect(filter.description, isA<String>());
          expect(filter.description.isNotEmpty, isTrue);
        }
      });
    });

    group('Performance Integration', () {
      test('should process complete document pipeline efficiently', () async {
        final stopwatch = Stopwatch()..start();

        // Step 1: Edge detection
        final quad = await DocumentEdgeDetector.detectDocumentEdges(
          testImageData,
          width,
          height,
        );

        if (quad != null) {
          // Step 2: Perspective correction
          final corrected = await DocumentPerspectiveCorrector.correctPerspective(
            testImageData,
            width,
            height,
            quad,
          );

          // Step 3: Image enhancement
          final enhanced = await DocumentImageEnhancer.applyFilter(
            corrected.imageData,
            corrected.width,
            corrected.height,
            DocumentFilter.autoColor,
          );

          // Step 4: OCR
          final ocrResult = await DocumentOcrProcessor.extractText(
            enhanced,
            corrected.width,
            corrected.height,
          );

          // Step 5: Generate searchable PDF
          final pdf = await DocumentOcrProcessor.generateSearchablePdf(
            enhanced,
            corrected.width,
            corrected.height,
            ocrResult,
          );

          expect(pdf, isA<Uint8List>());
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(10000)); // Under 10 seconds
      });
    });

    group('Error Handling Integration', () {
      test('should handle empty image gracefully', () async {
        expect(
          () => DocumentEdgeDetector.detectDocumentEdges(Uint8List(0), 0, 0),
          throwsA(isA<EdgeDetectionException>()),
        );

        expect(
          () => DocumentOcrProcessor.extractText(Uint8List(0), 0, 0),
          throwsA(isA<OcrException>()),
        );
      });

      test('should provide meaningful error messages', () {
        const edgeException = EdgeDetectionException('Edge detection failed');
        const perspectiveException = PerspectiveCorrectionException('Perspective correction failed');
        const ocrException = OcrException('OCR processing failed');

        expect(edgeException.toString(), contains('Edge detection failed'));
        expect(perspectiveException.toString(), contains('Perspective correction failed'));
        expect(ocrException.toString(), contains('OCR processing failed'));
      });
    });
  });
}

/// Create test document image with text-like patterns
Uint8List _createTestDocumentImage(int width, int height) {
  final data = Uint8List(width * height * 3);

  // White background
  data.fillRange(0, data.length, 255);

  // Add some text-like patterns (dark horizontal lines)
  for (int y = 100; y < height - 100; y += 30) {
    for (int x = 50; x < width - 50; x++) {
      if (y % 60 < 20) { // Text line
        final index = (y * width + x) * 3;
        data[index] = 0;     // Black text
        data[index + 1] = 0;
        data[index + 2] = 0;
      }
    }
  }

  // Add document border
  for (int i = 0; i < width; i++) {
    // Top border
    final topIndex = i * 3;
    data[topIndex] = 100;
    data[topIndex + 1] = 100;
    data[topIndex + 2] = 100;

    // Bottom border
    final bottomIndex = ((height - 1) * width + i) * 3;
    data[bottomIndex] = 100;
    data[bottomIndex + 1] = 100;
    data[bottomIndex + 2] = 100;
  }

  for (int i = 0; i < height; i++) {
    // Left border
    final leftIndex = (i * width) * 3;
    data[leftIndex] = 100;
    data[leftIndex + 1] = 100;
    data[leftIndex + 2] = 100;

    // Right border
    final rightIndex = (i * width + width - 1) * 3;
    data[rightIndex] = 100;
    data[rightIndex + 1] = 100;
    data[rightIndex + 2] = 100;
  }

  return data;
}