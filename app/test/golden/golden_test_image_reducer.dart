import 'package:alchemist/alchemist.dart';
import 'package:bharattesting_utilities/features/image_reducer/image_reducer_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'golden_test_config.dart';

/// Golden tests for the Image Size Reducer
///
/// Tests the compression interface, quality controls,
/// batch processing, and before/after comparisons.
void main() {
  group('Image Reducer Golden Tests', () {
    goldenTest(
      'image reducer initial state',
      fileName: 'image_reducer_initial',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final themeName in GoldenTestConfig.themes.keys)
            for (final device in GoldenTestConfig.devices)
              GoldenTestConfig.createScenario(
                name: 'initial_${themeName}_${device.name}',
                theme: themeName,
                device: device,
                child: const ImageReducerScreen(),
              ),
        ],
      ),
    );

    goldenTest(
      'image reducer with image loaded',
      fileName: 'image_reducer_loaded',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'loaded_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withImageLoaded(
              const ImageReducerScreen(),
              originalSize: '2.4 MB',
              dimensions: '1920×1080',
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'loaded_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withImageLoaded(
              const ImageReducerScreen(),
              originalSize: '2.4 MB',
              dimensions: '1920×1080',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'image reducer quality controls',
      fileName: 'image_reducer_quality',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final quality in [25, 50, 75, 90])
            GoldenTestConfig.createScenario(
              name: 'quality_${quality}_dark_tablet',
              theme: 'dark',
              device: GoldenTestConfig.tabletDevice,
              child: GoldenTestConfig.withQualitySetting(
                const ImageReducerScreen(),
                quality: quality,
                estimatedSize: '${(2.4 * quality / 100).toStringAsFixed(1)} MB',
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'image reducer before after comparison',
      fileName: 'image_reducer_comparison',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'comparison_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withBeforeAfterComparison(
              const ImageReducerScreen(),
              beforeSize: '2.4 MB',
              afterSize: '845 KB',
              compressionRatio: '65%',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'image reducer batch processing',
      fileName: 'image_reducer_batch',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'batch_list_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withBatchImages(
              const ImageReducerScreen(),
              imageCount: 5,
              totalOriginalSize: '12.8 MB',
              totalCompressedSize: '4.2 MB',
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'batch_progress_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withBatchProgress(
              const ImageReducerScreen(),
              processed: 3,
              total: 7,
              currentFile: 'image_004.jpg',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'image reducer format selection',
      fileName: 'image_reducer_formats',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final format in ['JPEG', 'PNG', 'WebP'])
            GoldenTestConfig.createScenario(
              name: '${format.toLowerCase()}_format_dark_desktop',
              theme: 'dark',
              device: GoldenTestConfig.desktopDevice,
              child: GoldenTestConfig.withOutputFormat(
                const ImageReducerScreen(),
                format: format,
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'image reducer resize presets',
      fileName: 'image_reducer_presets',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'presets_dark_tablet',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withResizePresets(
              const ImageReducerScreen(),
              selectedPreset: 'HD (1280px)',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'image reducer metadata options',
      fileName: 'image_reducer_metadata',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'metadata_options_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withMetadataOptions(
              const ImageReducerScreen(),
              stripExif: true,
              stripGps: true,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'image reducer error states',
      fileName: 'image_reducer_errors',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'unsupported_format_error_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withError(
              const ImageReducerScreen(),
              'Unsupported image format. Please use JPEG, PNG, or WebP.',
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'file_too_large_error_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withError(
              const ImageReducerScreen(),
              'File too large. Maximum size is 50 MB per image.',
            ),
          ),
        ],
      ),
    );
  });
}