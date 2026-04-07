import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_utilities/features/image_reducer/screens/image_reducer_screen.dart';
import 'golden_test_config.dart';

void main() {
  group('Image Reducer Golden Tests', () {
    goldenTest(
      'image reducer screen layouts',
      fileName: 'image_reducer_layouts',
      builder: () {
        return GoldenTestConfig.responsiveScenarios(
          'image_reducer',
          (theme, device) => const ImageReducerScreen(),
        );
      },
    );

    goldenTest(
      'compression quality controls',
      fileName: 'compression_controls',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Quality slider at different values
          final qualities = [10, 50, 80, 100];

          for (final quality in qualities) {
            scenarios.add(
              GoldenTestScenario(
                name: 'quality_${quality}_$theme',
                child: GoldenTestConfig.themedWrapper(
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quality: $quality%',
                          style: GoldenTestConfig.themes[theme]!.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: quality.toDouble(),
                          min: 1,
                          max: 100,
                          divisions: 99,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Smaller',
                              style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                            Text('Better Quality',
                              style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  theme,
                ),
                constraints: const BoxConstraints.tight(Size(332, 100)),
              ),
            );
          }
        }

        return scenarios;
      },
    );

    goldenTest(
      'format selection options',
      fileName: 'format_selection',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final formats = ['JPEG', 'PNG', 'WebP', 'AVIF'];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'format_chips_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 350,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Output Format',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: formats.map((format) => ChoiceChip(
                          selected: format == 'JPEG',
                          label: Text(format),
                          onSelected: (selected) {},
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(382, 120)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'resize presets',
      fileName: 'resize_presets',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final presets = [
          {'name': 'Thumbnail', 'size': '150px'},
          {'name': 'Small', 'size': '640px'},
          {'name': 'HD', 'size': '1280px'},
          {'name': 'Full HD', 'size': '1920px'},
          {'name': '4K', 'size': '3840px'},
          {'name': 'Custom', 'size': 'Custom'},
        ];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'presets_grid_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resize Presets',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: presets.length,
                        itemBuilder: (context, index) {
                          final preset = presets[index];
                          return OutlinedButton(
                            onPressed: () {},
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(preset['name']!,
                                  style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                                Text(preset['size']!,
                                  style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 200)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'before after comparison',
      fileName: 'before_after_comparison',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'comparison_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 400,
                  height: 300,
                  child: Column(
                    children: [
                      Text('Before vs After',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Original (2.5 MB)',
                                    style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.image, size: 48),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Compressed (650 KB)',
                                    style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.image, size: 48),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.compress, color: Colors.green),
                            SizedBox(width: 8),
                            Text('74% size reduction'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 300)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'batch processing interface',
      fileName: 'batch_processing',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Empty batch state
          scenarios.add(
            GoldenTestScenario(
              name: 'batch_empty_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 400,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library_outlined, size: 48,
                        color: GoldenTestConfig.themes[theme]!.colorScheme.outline),
                      const SizedBox(height: 16),
                      Text('No images selected',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Add up to 50 images for batch processing',
                        style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Select Images'),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 200)),
            ),
          );

          // Batch with files
          scenarios.add(
            GoldenTestScenario(
              name: 'batch_with_files_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 400,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Batch Processing (5 files)',
                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.image, size: 20),
                              ),
                              title: Text('image_${index + 1}.jpg'),
                              subtitle: Text('2.${index + 1} MB'),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {},
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.compress),
                          label: const Text('Compress All'),
                        ),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 300)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'image reducer error states',
      fileName: 'image_reducer_errors',
      builder: () {
        return GoldenTestConfig.errorScenarios(
          'image_reducer',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64,
                  color: GoldenTestConfig.themes[theme]!.colorScheme.error),
                const SizedBox(height: 16),
                Text('Unsupported Image Format',
                  style: GoldenTestConfig.themes[theme]!.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Please select JPEG, PNG, WebP, or BMP images',
                  style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium,
                  textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      },
    );

    goldenTest(
      'image reducer loading states',
      fileName: 'image_reducer_loading',
      builder: () {
        return GoldenTestConfig.loadingScenarios(
          'image_reducer',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Compressing images...'),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.6),
                SizedBox(height: 8),
                Text('3 of 5 images processed'),
              ],
            ),
          ),
        );
      },
    );
  });
}