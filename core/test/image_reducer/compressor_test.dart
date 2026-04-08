import 'package:test/test.dart';
import 'package:bharattesting_core/src/image_reducer/compressor.dart';
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
        final config = CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final result = await ImageCompressor.compress(testPNG, config);

        expect(result.isSuccess, isTrue);
        expect(result.compressedData, isNotEmpty);
        expect(result.originalSize, equals(testPNG.length));
        expect(result.outputFormat, equals(ImageFormat.jpeg));
        expect(result.compressionRatio, lessThan(1.0));
      });

      test('applies quality settings correctly', () async {
        final highQuality = CompressionConfig(
          quality: 95,
          format: ImageFormat.jpeg,
        );

        final lowQuality = CompressionConfig(
          quality: 50,
          format: ImageFormat.jpeg,
        );

        final highResult = await ImageCompressor.compress(testPNG, highQuality);
        final lowResult = await ImageCompressor.compress(testPNG, lowQuality);

        expect(highResult.compressedSize, greaterThan(lowResult.compressedSize));
      });

      test('handles different image formats', () async {
        for (final format in ImageFormat.values) {
          final config = CompressionConfig(
            quality: format.supportsQuality ? 80 : 100,
            format: format,
          );

          final result = await ImageCompressor.compress(testPNG, config);
          expect(result.isSuccess, isTrue);
          expect(result.outputFormat, equals(format));
        }
      });

      test('applies optimizations', () async {
        final config = CompressionConfig(
          quality: 60,
          format: ImageFormat.jpeg,
          optimizeForSize: true,
        );

        final result = await ImageCompressor.compress(testPNG, config);
        expect(result.optimizations, isNotEmpty);
      });

      test('fails gracefully with invalid data', () async {
        final invalidData = Uint8List.fromList([1, 2, 3, 4]);
        final config = CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        expect(
          () => ImageCompressor.compress(invalidData, config),
          throwsA(isA<ImageCompressionException>()),
        );
      });
    });

    group('estimateCompressedSize', () {
      test('provides reasonable estimates', () {
        final originalSize = 1024 * 1024; // 1MB

        for (final quality in [30, 60, 90]) {
          final config = CompressionConfig(
            quality: quality,
            format: ImageFormat.jpeg,
          );

          final estimate = ImageCompressor.estimateCompressedSize(
            originalSize,
            config,
          );

          expect(estimate, lessThan(originalSize));
          expect(estimate, greaterThan(0));
        }
      });

      test('higher quality produces larger estimates', () {
        final originalSize = 1024 * 1024;

        final lowQualityEstimate = ImageCompressor.estimateCompressedSize(
          originalSize,
          CompressionConfig(quality: 30, format: ImageFormat.jpeg),
        );

        final highQualityEstimate = ImageCompressor.estimateCompressedSize(
          originalSize,
          CompressionConfig(quality: 90, format: ImageFormat.jpeg),
        );

        expect(highQualityEstimate, greaterThan(lowQualityEstimate));
      });
    });

    group('compression levels', () {
      test('provides correct quality values', () {
        expect(CompressionLevel.maximum.quality, lessThan(30));
        expect(CompressionLevel.minimal.quality, greaterThan(90));
        expect(CompressionLevel.medium.quality, inInclusiveRange(50, 70));
      });

      test('creates configs from levels', () {
        for (final level in CompressionLevel.values) {
          final config = CompressionConfig.fromLevel(level, ImageFormat.jpeg);
          expect(config.quality, equals(level.quality));
        }
      });
    });

    group('batch compression', () {
      test('processes multiple images', () async {
        final images = List.generate(3, (_) => testPNG);
        final config = CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final results = await ImageCompressor.compressBatch(images, config)
            .toList();

        expect(results, hasLength(3));
        for (final result in results) {
          expect(result.isSuccess, isTrue);
        }
      });

      test('respects concurrency limits', () async {
        final images = List.generate(10, (_) => testPNG);
        final config = CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final stopwatch = Stopwatch()..start();
        await ImageCompressor.compressBatch(images, config, maxConcurrency: 2)
            .toList();
        stopwatch.stop();

        // Should process in batches, so not all at once
        expect(stopwatch.elapsedMilliseconds, greaterThan(0));
      });
    });

    group('getSupportedFormats', () {
      test('returns supported formats for PNG', () {
        final formats = ImageCompressor.getSupportedFormats(testPNG);

        expect(formats, contains(ImageFormat.jpeg));
        expect(formats, contains(ImageFormat.png));
        expect(formats, contains(ImageFormat.webp));
      });
    });

    group('performance', () {
      test('compresses small images quickly', () async {
        final config = CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final result = await ImageCompressor.compress(testPNG, config);
        expect(result.processingTime.inMilliseconds, lessThan(1000));
      });

      test('provides efficiency scores', () async {
        final config = CompressionConfig(
          quality: 80,
          format: ImageFormat.jpeg,
        );

        final result = await ImageCompressor.compress(testPNG, config);
        expect(result.efficiencyScore, inInclusiveRange(0, 100));
      });
    });

    group('configuration presets', () {
      test('thumbnail preset has appropriate settings', () {
        expect(CompressionConfig.thumbnail.quality, lessThan(80));
        expect(CompressionConfig.thumbnail.maxWidth, equals(300));
        expect(CompressionConfig.thumbnail.maxHeight, equals(300));
      });

      test('web preset optimizes for web usage', () {
        expect(CompressionConfig.web.progressive, isTrue);
        expect(CompressionConfig.web.optimizeForSize, isTrue);
        expect(CompressionConfig.web.maxWidth, equals(1920));
      });

      test('print preset preserves quality', () {
        expect(CompressionConfig.print.quality, greaterThan(90));
        expect(CompressionConfig.print.preserveMetadata, isTrue);
      });
    });
  });
}