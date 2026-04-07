import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_utilities/features/pdf_merger/screens/pdf_merger_screen.dart';
import 'golden_test_config.dart';

void main() {
  group('PDF Merger Golden Tests', () {
    goldenTest(
      'pdf merger screen layouts',
      fileName: 'pdf_merger_layouts',
      builder: () {
        return GoldenTestConfig.responsiveScenarios(
          'pdf_merger',
          (theme, device) => const PdfMergerScreen(),
        );
      },
    );

    goldenTest(
      'pdf upload zone states',
      fileName: 'pdf_upload_zone',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Empty upload zone
          scenarios.add(
            GoldenTestScenario(
              name: 'upload_empty_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  height: 200,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GoldenTestConfig.themes[theme]!.colorScheme.outline,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 48,
                        color: GoldenTestConfig.themes[theme]!.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text('Drop PDF files here',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('or click to browse files',
                        style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GoldenTestConfig.themes[theme]!.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('Up to 20 PDFs, 100MB max',
                          style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 232)),
            ),
          );

          // Drag over state
          scenarios.add(
            GoldenTestScenario(
              name: 'upload_drag_over_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  height: 200,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GoldenTestConfig.themes[theme]!.colorScheme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: GoldenTestConfig.themes[theme]!.colorScheme.primaryContainer.withOpacity(0.2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, size: 48,
                        color: GoldenTestConfig.themes[theme]!.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text('Drop PDF files here',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium?.copyWith(
                          color: GoldenTestConfig.themes[theme]!.colorScheme.primary)),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 232)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'pdf page thumbnails',
      fileName: 'pdf_page_thumbnails',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Grid with PDF pages
          scenarios.add(
            GoldenTestScenario(
              name: 'thumbnails_grid_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 500,
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pages (12)',
                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.grid_view),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.list),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: index == 2
                                    ? GoldenTestConfig.themes[theme]!.colorScheme.primary
                                    : GoldenTestConfig.themes[theme]!.colorScheme.outline,
                                  width: index == 2 ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.picture_as_pdf, size: 24),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text('${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  if (index == 2)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: GoldenTestConfig.themes[theme]!.colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check, size: 12, color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(532, 400)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'pdf manipulation controls',
      fileName: 'pdf_controls',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'controls_panel_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Page Operations',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.rotate_90_degrees_ccw),
                              label: const Text('Rotate'),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete'),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.content_copy),
                              label: const Text('Duplicate'),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.swap_vert),
                              label: const Text('Reorder'),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Export Options',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Add Bookmarks'),
                        subtitle: const Text('Auto-generate from filenames'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Password Protection'),
                        subtitle: const Text('Encrypt merged PDF'),
                        value: false,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.merge),
                          label: const Text('Merge PDFs'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(332, 400)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'pdf merger error states',
      fileName: 'pdf_merger_errors',
      builder: () {
        return GoldenTestConfig.errorScenarios(
          'pdf_merger',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64,
                  color: GoldenTestConfig.themes[theme]!.colorScheme.error),
                const SizedBox(height: 16),
                Text('File Too Large',
                  style: GoldenTestConfig.themes[theme]!.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('PDF files cannot exceed 100MB total',
                  style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium,
                  textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Select Smaller Files'),
                ),
              ],
            ),
          ),
        );
      },
    );

    goldenTest(
      'pdf merger loading states',
      fileName: 'pdf_merger_loading',
      builder: () {
        return GoldenTestConfig.loadingScenarios(
          'pdf_merger',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Merging PDFs...'),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.8),
                SizedBox(height: 8),
                Text('Processing page 8 of 10'),
              ],
            ),
          ),
        );
      },
    );
  });
}