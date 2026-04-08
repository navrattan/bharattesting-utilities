import 'package:test/test.dart';
import 'package:bharattesting_core/src/image_reducer/resizer.dart';
import 'dart:typed_data';

void main() {
  group('ImageResizer', () {
    // Create a simple test image (1x1 PNG)
    final testPNG = Uint8List.fromList([
      137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1,
      0, 0, 0, 1, 8, 2, 0, 0, 0, 144, 119, 83, 222, 0, 0, 0, 12, 73, 68, 65,
      84, 8, 215, 99, 248, 15, 0, 1, 1, 1, 0, 24, 221, 141, 176, 0, 0, 0, 0,
      73, 69, 78, 68, 174, 66, 96, 130
    ]);

    group('resize', () {
      test('resizes image to specific dimensions', () async {
        final config = ResizeConfig(
          width: 100,
          height: 100,
          algorithm: ResizeAlgorithm.cubic,
        );

        final result = await ImageResizer.resize(testPNG, config);

        expect(result.newWidth, equals(100));
        expect(result.newHeight, equals(100));
        expect(result.imageData, isNotEmpty);
      });

      test('resizes by percentage', () async {
        final config = ResizeConfig.percentage(50);

        final result = await ImageResizer.resize(testPNG, config);

        expect(result.averageScaleFactor, closeTo(0.5, 0.1));
        expect(result.isDownscaling, isTrue);
      });

      test('maintains aspect ratio in fit mode', () async {
        final config = ResizeConfig(
          width: 200,
          height: 100,
          aspectRatioMode: AspectRatioMode.fit,
        );

        final result = await ImageResizer.resize(testPNG, config);

        // Should fit within bounds while maintaining aspect ratio
        expect(result.newWidth, lessThanOrEqualTo(200));
        expect(result.newHeight, lessThanOrEqualTo(100));
      });

      test('handles different aspect ratio modes', () async {
        for (final mode in AspectRatioMode.values) {
          final config = ResizeConfig(
            width: 100,
            height: 50,
            aspectRatioMode: mode,
          );

          final result = await ImageResizer.resize(testPNG, config);
          expect(result.imageData, isNotEmpty);
          expect(result.operations, isNotEmpty);
        }
      });

      test('applies different algorithms', () async {
        for (final algorithm in ResizeAlgorithm.values) {
          final config = ResizeConfig(
            width: 50,
            height: 50,
            algorithm: algorithm,
          );

          final result = await ImageResizer.resize(testPNG, config);
          expect(result.algorithmUsed, equals(algorithm));
          expect(result.imageData, isNotEmpty);
        }
      });

      test('prevents upscaling when disabled', () async {
        final config = ResizeConfig(
          width: 1000,
          height: 1000,
          allowUpscaling: false,
        );

        expect(
          () => ImageResizer.resize(testPNG, config),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('applies sharpening filter', () async {
        final config = ResizeConfig(
          width: 100,
          height: 100,
          sharpening: true,
          sharpeningStrength: 1.5,
        );

        final result = await ImageResizer.resize(testPNG, config);
        expect(result.operations, anyElement(contains('sharpening')));
      });
    });

    group('resize presets', () {
      test('thumbnail preset creates small images', () {
        expect(ResizePreset.thumbnail.width, equals(150));
        expect(ResizePreset.thumbnail.height, equals(150));
        expect(ResizePreset.thumbnail.aspectRatioMode, equals(AspectRatioMode.crop));
      });

      test('large preset maintains quality', () {
        expect(ResizePreset.large.algorithm, equals(ResizeAlgorithm.lanczos));
        expect(ResizePreset.large.width, equals(1920));
      });

      test('creates config from preset', () {
        final config = ResizeConfig.fromPreset(ResizePreset.medium);
        expect(config.width, equals(1024));
        expect(config.height, equals(768));
        expect(config.algorithm, equals(ResizeAlgorithm.lanczos));
      });
    });

    group('suggestPreset', () {
      test('suggests thumbnail for large images', () {
        final preset = ImageResizer.suggestPreset(
          4000, 3000,
          useCase: 'thumbnail',
        );

        expect(preset, anyOf([ResizePreset.thumbnail, ResizePreset.small]));
      });

      test('suggests web presets for web use', () {
        final preset = ImageResizer.suggestPreset(
          5000, 4000,
          useCase: 'web',
        );

        expect(preset, anyOf([
          ResizePreset.small,
          ResizePreset.medium,
          ResizePreset.large,
        ]));
      });

      test('considers file size constraints', () {
        final preset = ImageResizer.suggestPreset(
          2000, 2000,
          targetFileSize: 512 * 1024, // 512KB
        );

        expect(preset.megapixels, lessThan(5.0));
      });
    });

    group('batch resize', () {
      test('processes multiple images', () async {
        final images = List.generate(3, (_) => testPNG);
        final config = ResizeConfig(width: 100, height: 100);

        final results = await ImageResizer.resizeBatch(images, config).toList();

        expect(results, hasLength(3));
        for (final result in results) {
          expect(result.newWidth, equals(100));
          expect(result.newHeight, equals(100));
        }
      });

      test('respects concurrency limits', () async {
        final images = List.generate(10, (_) => testPNG);
        final config = ResizeConfig(width: 50, height: 50);

        final stopwatch = Stopwatch()..start();
        await ImageResizer.resizeBatch(images, config, maxConcurrency: 2)
            .toList();
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, greaterThan(0));
      });
    });

    group('resize algorithms', () {
      test('nearest is fastest but lowest quality', () {
        expect(ResizeAlgorithm.nearest.speed, greaterThan(ResizeAlgorithm.lanczos.speed));
        expect(ResizeAlgorithm.nearest.quality, lessThan(ResizeAlgorithm.lanczos.quality));
      });

      test('lanczos provides highest quality', () {
        final qualities = ResizeAlgorithm.values.map((a) => a.quality).toList();
        expect(ResizeAlgorithm.lanczos.quality, equals(qualities.reduce((a, b) => a > b ? a : b)));
      });
    });

    group('configuration validation', () {
      test('validates width and height', () {
        expect(
          () => ResizeConfig(width: -1, height: 100).validate(),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => ResizeConfig(width: 100, height: 0).validate(),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('validates scale factor', () {
        expect(
          () => ResizeConfig(scale: -0.5).validate(),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => ResizeConfig(scale: 0).validate(),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('validates sharpening strength', () {
        expect(
          () => ResizeConfig(
            width: 100,
            height: 100,
            sharpeningStrength: 3.0,
          ).validate(),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('requires at least one dimension or scale', () {
        expect(
          () => ResizeConfig().validate(),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('performance', () {
      test('processes small images quickly', () async {
        final config = ResizeConfig(width: 50, height: 50);

        final result = await ImageResizer.resize(testPNG, config);
        expect(result.processingTime.inMilliseconds, lessThan(1000));
      });

      test('provides quality scores', () async {
        final config = ResizeConfig(
          width: 100,
          height: 100,
          algorithm: ResizeAlgorithm.lanczos,
        );

        final result = await ImageResizer.resize(testPNG, config);
        expect(result.qualityScore, inInclusiveRange(0, 100));
      });

      test('calculates pixels per second', () async {
        final config = ResizeConfig(width: 100, height: 100);

        final result = await ImageResizer.resize(testPNG, config);
        expect(result.pixelsPerSecond, greaterThan(0));
      });
    });

    group('edge cases', () {
      test('handles very small images', () async {
        final config = ResizeConfig(width: 1, height: 1);

        final result = await ImageResizer.resize(testPNG, config);
        expect(result.newWidth, equals(1));
        expect(result.newHeight, equals(1));
      });

      test('handles large scale factors', () async {
        final config = ResizeConfig.percentage(1000); // 10x scale

        final result = await ImageResizer.resize(testPNG, config);
        expect(result.isUpscaling, isTrue);
        expect(result.averageScaleFactor, greaterThan(5));
      });
    });
  });
}