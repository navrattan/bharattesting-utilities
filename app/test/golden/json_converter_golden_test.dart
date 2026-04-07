import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_utilities/features/json_converter/screens/json_converter_screen.dart';
import 'golden_test_config.dart';

void main() {
  group('JSON Converter Golden Tests', () {
    goldenTest(
      'json converter screen layouts',
      fileName: 'json_converter_layouts',
      builder: () {
        return GoldenTestConfig.responsiveScenarios(
          'json_converter',
          (theme, device) => const JsonConverterScreen(),
        );
      },
    );

    goldenTest(
      'input editor states',
      fileName: 'input_editor',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Empty input
          scenarios.add(
            GoldenTestScenario(
              name: 'input_empty_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Input',
                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                          Row(
                            children: [
                              Chip(
                                label: const Text('Auto-Detect'),
                                backgroundColor: GoldenTestConfig.themes[theme]!.colorScheme.primaryContainer,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.content_paste),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GoldenTestConfig.themes[theme]!.colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Paste your string, CSV, YAML, XML, or broken JSON here...',
                            style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium?.copyWith(
                              color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface.withOpacity(0.5),
                            )),
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

          // With broken JSON content
          scenarios.add(
            GoldenTestScenario(
              name: 'input_broken_json_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Input',
                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                          Row(
                            children: [
                              Chip(
                                label: const Text('Broken JSON'),
                                backgroundColor: GoldenTestConfig.themes[theme]!.colorScheme.errorContainer,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GoldenTestConfig.themes[theme]!.colorScheme.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            GoldenTestData.brokenJson,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface,
                            ),
                          ),
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

          // With CSV content
          scenarios.add(
            GoldenTestScenario(
              name: 'input_csv_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Input',
                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                          Row(
                            children: [
                              Chip(
                                label: const Text('CSV'),
                                backgroundColor: GoldenTestConfig.themes[theme]!.colorScheme.secondaryContainer,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GoldenTestConfig.themes[theme]!.colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            GoldenTestData.sampleCsv,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface,
                            ),
                          ),
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
      'output editor with syntax highlighting',
      fileName: 'output_editor',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          // Valid JSON output
          scenarios.add(
            GoldenTestScenario(
              name: 'output_valid_json_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  height: 350,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Output',
                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle, size: 16, color: Colors.green),
                                    SizedBox(width: 4),
                                    Text('Valid JSON', style: TextStyle(color: Colors.green, fontSize: 12)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                            color: GoldenTestConfig.themes[theme]!.colorScheme.surface,
                          ),
                          child: SingleChildScrollView(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface,
                                ),
                                children: [
                                  TextSpan(text: '{\n  ', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                  TextSpan(text: '"name"', style: TextStyle(color: Colors.blue[300])),
                                  TextSpan(text: ': ', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                  TextSpan(text: '"BharatTesting"', style: TextStyle(color: Colors.green[300])),
                                  TextSpan(text: ',\n  ', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                  TextSpan(text: '"version"', style: TextStyle(color: Colors.blue[300])),
                                  TextSpan(text: ': ', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                  TextSpan(text: '"1.0.0"', style: TextStyle(color: Colors.green[300])),
                                  TextSpan(text: ',\n  ', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                  TextSpan(text: '"tools"', style: TextStyle(color: Colors.blue[300])),
                                  TextSpan(text: ': [\n    ', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                  TextSpan(text: '"Scanner"', style: TextStyle(color: Colors.green[300])),
                                  TextSpan(text: ',\n    ', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                  TextSpan(text: '"Reducer"', style: TextStyle(color: Colors.green[300])),
                                  TextSpan(text: '\n  ]\n}', style: TextStyle(color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Pretty'),
                            selected: true,
                            onSelected: (selected) {},
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Minified'),
                            selected: false,
                            onSelected: (selected) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 350)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'error highlighting and suggestions',
      fileName: 'error_highlighting',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'error_panel_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 450,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('JSON Errors & Suggestions',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GoldenTestConfig.themes[theme]!.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.error_outline,
                                  color: GoldenTestConfig.themes[theme]!.colorScheme.error),
                                const SizedBox(width: 8),
                                Text('3 errors found',
                                  style: GoldenTestConfig.themes[theme]!.textTheme.titleSmall),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildErrorItem(theme, 'Line 5: Trailing comma after "Faker"', 'Remove trailing comma'),
                            _buildErrorItem(theme, 'Line 8: Missing quotes around key "opensource"', 'Add quotes around key'),
                            _buildErrorItem(theme, 'Line 10: Extra comma at end', 'Remove trailing comma'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.auto_fix_high),
                              label: const Text('Auto-Repair'),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text('Validate'),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(482, 250)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'format detection chips',
      fileName: 'format_detection',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final formats = ['JSON', 'CSV', 'YAML', 'XML', 'URL-Encoded', 'INI'];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'format_chips_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 400,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Detected Formats',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: formats.asMap().entries.map((entry) {
                          final index = entry.key;
                          final format = entry.value;
                          final isSelected = index == 1; // CSV selected
                          return FilterChip(
                            selected: isSelected,
                            label: Text(format),
                            onSelected: (selected) {},
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GoldenTestConfig.themes[theme]!.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                              color: GoldenTestConfig.themes[theme]!.colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('Auto-detected as CSV format. Converting to JSON array of objects.',
                                style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(432, 150)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'json converter error states',
      fileName: 'json_converter_errors',
      builder: () {
        return GoldenTestConfig.errorScenarios(
          'json_converter',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.code_off, size: 64,
                  color: GoldenTestConfig.themes[theme]!.colorScheme.error),
                const SizedBox(height: 16),
                Text('Invalid JSON Syntax',
                  style: GoldenTestConfig.themes[theme]!.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Unable to parse input. Try using auto-repair or fix manually.',
                  style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium,
                  textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.auto_fix_high),
                      label: const Text('Auto-Repair'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Clear Input'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}

/// Helper function to build error item widget
Widget _buildErrorItem(String theme, String error, String suggestion) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          error,
          style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall?.copyWith(
            color: GoldenTestConfig.themes[theme]!.colorScheme.onErrorContainer,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '💡 $suggestion',
          style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall?.copyWith(
            color: GoldenTestConfig.themes[theme]!.colorScheme.onErrorContainer.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}