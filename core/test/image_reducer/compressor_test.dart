import 'package:test/test.dart';
import 'package:bharattesting_core/src/image_reducer/compressor.dart';
import 'package:bharattesting_core/src/image_reducer/image_reducer_service.dart';
import 'dart:typed_data';

void main() {
  group('ImageCompressor', () {
    // Create a simple test image (1x1 PNG)
    final testPNG = Uint8List.fromList([
      137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1,
      0, 0, 0, 1, 8, 2, 0, 0, 0, 144, 119, 83, 222, 0, 0, 0, 12, 73, 68, 65,
      84, 8, 215, 99, 248, 15, 0, 1, 1, 1, 0, 24, 221, 141, 176, 0, 0, 0, 0,
      73, 69, 78, 68, 174, 66, 96, 130
    ]);

    group('compress', () {
      test('compresses image successfully', () async {
        final config = const CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final result = await ImageCompressor.compress(
          imageData: testPNG,
          config: config,
        );

        expect(result.compressedData, isNotEmpty);
        expect(result.originalSize, equals(testPNG.length));
        expect(result.outputFormat, equals(ImageFormat.jpeg));
      });

      test('applies quality settings correctly', () async {
        final highQuality = const CompressionConfig(
          quality: 95,
          format: ImageFormat.jpeg,
        );

        final lowQuality = const CompressionConfig(
          quality: 50,
          format: ImageFormat.jpeg,
        );

        final highResult = await ImageCompressor.compress(
          imageData: testPNG,
          config: highQuality,
        );
        final lowResult = await ImageCompressor.compress(
          imageData: testPNG,
          config: lowQuality,
        );

        expect(highResult.compressedSize, greaterThanOrEqualTo(lowResult.compressedSize));
      });

      test('handles different image formats', () async {
        for (final format in [ImageFormat.jpeg, ImageFormat.png, ImageFormat.webp]) {
          final config = CompressionConfig(
            quality: 80,
            format: format,
          );

          final result = await ImageCompressor.compress(
            imageData: testPNG,
            config: config,
          );
          expect(result.outputFormat, equals(format));
        }
      });

      test('applies optimizations', () async {
        final config = const CompressionConfig(
          quality: 60,
          format: ImageFormat.jpeg,
          optimizeForSize: true,
        );

        final result = await ImageCompressor.compress(
          imageData: testPNG,
          config: config,
        );
        // 1x1 image might not have many optimizations, but let's check it doesn't crash
        expect(result.compressedData, isNotEmpty);
      });

      test('fails gracefully with invalid data', () async {
        final invalidData = Uint8List.fromList([1, 2, 3, 4]);
        final config = const CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        expect(
          () => ImageCompressor.compress(imageData: invalidData, config: config),
          throwsA(isA<ImageCompressionException>()),
        );
      });
    });

    group('batch compression', () {
      test('processes multiple images', () async {
        final images = List.generate(3, (_) => testPNG);
        final config = const CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final results = await ImageCompressor.compressBatch(
          images: images,
          config: config,
        ).toList();

        expect(results, hasLength(3));
        for (final result in results) {
          expect(result.compressedData, isNotEmpty);
        }
      });
    });

    group('getSupportedFormats', () {
      test('returns supported formats', () {
        final formats = ImageCompressor.getSupportedFormats(testPNG);

        expect(formats, contains(ImageFormat.jpeg));
        expect(formats, contains(ImageFormat.png));
        expect(formats, contains(ImageFormat.webp));
      });
    });

    group('performance', () {
      test('compresses small images quickly', () async {
        final config = const CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final result = await ImageCompressor.compress(
          imageData: testPNG,
          config: config,
        );
        expect(result.processingTime.inMilliseconds, lessThan(1000));
      });

      test('provides efficiency scores', () async {
        final config = const CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final result = await ImageCompressor.compress(
          imageData: testPNG,
          config: config,
        );
        expect(result.efficiencyScore, isNotNull);
      });
    });

    group('configuration presets', () {
      test('webOptimized preset has appropriate settings', () {
        expect(CompressionConfig.webOptimized.format, equals(ImageFormat.webp));
        expect(CompressionConfig.webOptimized.quality, equals(75));
        expect(CompressionConfig.webOptimized.optimizeForSize, isTrue);
      });

      test('highQuality preset preserves quality', () {
        expect(CompressionConfig.highQuality.format, equals(ImageFormat.png));
        expect(CompressionConfig.highQuality.quality, equals(95));
        expect(CompressionConfig.highQuality.preserveMetadata, isTrue);
      });
    });
  });
}
