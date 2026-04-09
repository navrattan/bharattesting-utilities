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
        final config = const ResizeConfig(
          width: 100,
          height: 100,
          aspectRatioMode: AspectRatioMode.stretch,
        );

        final result = await ImageResizer.resize(testPNG, config);

        expect(result.newWidth, equals(100));
        expect(result.newHeight, equals(100));
        expect(result.imageData, isNotEmpty);
      });

      test('resizes by percentage', () async {
        final config = ResizeConfig.percentage(200);
        final result = await ImageResizer.resize(testPNG, config);

        expect(result.newWidth, equals(2));
        expect(result.newHeight, equals(2));
      });

      test('maintains aspect ratio in fit mode', () async {
        final config = const ResizeConfig(
          width: 500,
          height: 1000,
          aspectRatioMode: AspectRatioMode.fit,
        );

        final result = await ImageResizer.resize(testPNG, config);

        // For 1x1 image, it should fit within 500x1000
        // Fit will scale up to 500x500
        expect(result.newWidth, equals(500));
        expect(result.newHeight, equals(500));
      });

      test('applies sharpening filter', () async {
        final config = const ResizeConfig(
          width: 10,
          height: 10,
          sharpening: true,
          sharpeningStrength: 1.0,
        );

        final result = await ImageResizer.resize(testPNG, config);
        expect(result.operations, contains(contains('Applied sharpening')));
      });

      test('fails gracefully with invalid data', () async {
        final invalidData = Uint8List.fromList([1, 2, 3, 4]);
        final config = const ResizeConfig(width: 100);

        expect(
          () => ImageResizer.resize(invalidData, config),
          throwsA(isA<ImageResizeException>()),
        );
      });
    });

    group('suggestPreset', () {
      test('suggests appropriate preset', () {
        final preset = ImageResizer.suggestPreset(100, 100, useCase: 'thumbnail');
        expect(preset, equals(ResizePreset.thumbnail));
      });
    });

    group('batch resize', () {
      test('processes multiple images', () async {
        final images = [testPNG, testPNG];
        final config = const ResizeConfig(width: 10);

        final results = await ImageResizer.resizeBatch(images, config).toList();

        expect(results, hasLength(2));
        for (final result in results) {
          expect(result.newWidth, equals(10));
        }
      });
    });
  });
}
