import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_utilities/features/data_faker/faker_screen.dart';
import 'golden_test_config.dart';

void main() {
  group('Indian Data Faker Golden Tests', () {
    goldenTest(
      'data faker screen layouts',
      fileName: 'data_faker_layouts',
      builder: () {
        return GoldenTestConfig.responsiveScenarios(
          'data_faker',
          (theme, device) => const FakerScreen(),
        );
      },
    );

    goldenTest(
      'identifier selection grid',
      fileName: 'identifier_grid',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final identifiers = [
          {'name': 'PAN', 'desc': 'Permanent Account Number', 'example': 'ABCDE1234F'},
          {'name': 'GSTIN', 'desc': 'GST Identification Number', 'example': '12ABCDE1234F1Z5'},
          {'name': 'Aadhaar', 'desc': 'Unique Identification Number', 'example': '1234 5678 9012'},
          {'name': 'CIN', 'desc': 'Corporate Identification Number', 'example': 'L12345MH2023PLC123456'},
          {'name': 'TAN', 'desc': 'Tax Deduction Account Number', 'example': 'ABCD12345E'},
          {'name': 'IFSC', 'desc': 'Indian Financial System Code', 'example': 'SBIN0001234'},
          {'name': 'UPI', 'desc': 'Unified Payments Interface ID', 'example': 'user@bharatpe'},
          {'name': 'Udyam', 'desc': 'MSME Registration Number', 'example': 'UDYAM-MH-12-1234567'},
          {'name': 'PIN Code', 'desc': 'Postal Index Number', 'example': '400001'},
        ];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'identifier_grid_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 600,
                  height: 500,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Indian Identifiers (9 types)',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: identifiers.length,
                          itemBuilder: (context, index) {
                            final identifier = identifiers[index];
                            final isSelected = index == 0; // PAN selected
                            return Card(
                              color: isSelected
                                ? GoldenTestConfig.themes[theme]!.colorScheme.primaryContainer
                                : null,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            identifier['name']!,
                                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium?.copyWith(
                                              color: isSelected
                                                ? GoldenTestConfig.themes[theme]!.colorScheme.primary
                                                : null,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle,
                                              size: 20,
                                              color: GoldenTestConfig.themes[theme]!.colorScheme.primary,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        identifier['desc']!,
                                        style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: GoldenTestConfig.themes[theme]!.colorScheme.surfaceVariant,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          identifier['example']!,
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
              constraints: const BoxConstraints.tight(Size(632, 500)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'template selection',
      fileName: 'template_selection',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final templates = [
          {'name': 'Individual', 'desc': 'Personal data for individuals', 'fields': '5 fields'},
          {'name': 'Company', 'desc': 'Corporate entity information', 'fields': '8 fields'},
          {'name': 'Proprietorship', 'desc': 'Sole proprietorship business', 'fields': '6 fields'},
          {'name': 'Partnership', 'desc': 'Partnership firm details', 'fields': '7 fields'},
          {'name': 'Trust', 'desc': 'Trust organization data', 'fields': '6 fields'},
        ];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'template_cards_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 500,
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data Templates (5 types)',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: templates.length,
                          itemBuilder: (context, index) {
                            final template = templates[index];
                            final isSelected = index == 1; // Company selected
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: isSelected
                                ? GoldenTestConfig.themes[theme]!.colorScheme.primaryContainer
                                : null,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isSelected
                                    ? GoldenTestConfig.themes[theme]!.colorScheme.primary
                                    : GoldenTestConfig.themes[theme]!.colorScheme.surfaceVariant,
                                  child: Icon(
                                    _getTemplateIcon(template['name']!),
                                    color: isSelected
                                      ? Colors.white
                                      : GoldenTestConfig.themes[theme]!.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                title: Text(
                                  template['name']!,
                                  style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(template['desc']!),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: GoldenTestConfig.themes[theme]!.colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        template['fields']!,
                                        style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: GoldenTestConfig.themes[theme]!.colorScheme.primary,
                                      ),
                                  ],
                                ),
                                onTap: () {},
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
      'generation controls',
      fileName: 'generation_controls',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'controls_panel_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 350,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Generation Settings',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // Record count selection
                      Text('Number of Records',
                        style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton<int>(
                              segments: const [
                                ButtonSegment(value: 100, label: Text('100')),
                                ButtonSegment(value: 1000, label: Text('1K')),
                                ButtonSegment(value: 10000, label: Text('10K')),
                              ],
                              selected: {1000},
                              onSelectionChanged: (selection) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Seed input
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Seed (Optional)',
                          hintText: 'For reproducible data',
                          border: OutlineInputBorder(),
                          helperText: 'Same seed = identical results',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cross-field consistency toggle
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Cross-field Consistency'),
                        subtitle: const Text('Ensure GSTIN matches PAN, etc.'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),

                      // Generate button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.generating_tokens),
                          label: const Text('Generate Data'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(382, 350)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'data preview table',
      fileName: 'data_preview',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final sampleData = [
          ['ABCDE1234F', '12ABCDE1234F1Z5', '1234 5678 9012', 'John Doe', 'Mumbai'],
          ['FGHIJ5678K', '27FGHIJ5678K1Z9', '5678 9012 3456', 'Jane Smith', 'Delhi'],
          ['KLMNO9012P', '19KLMNO9012P1Z3', '9012 3456 7890', 'Bob Johnson', 'Bangalore'],
          ['QRSTU3456V', '36QRSTU3456V1Z7', '3456 7890 1234', 'Alice Brown', 'Chennai'],
          ['WXYZ7890A', '09WXYZ7890A1Z1', '7890 1234 5678', 'Charlie Wilson', 'Hyderabad'],
        ];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'preview_table_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 700,
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Generated Data (1,000 records)',
                            style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text('Regenerate'),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                icon: const Icon(Icons.download),
                                label: const Text('Export'),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GoldenTestConfig.themes[theme]!.colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: GoldenTestConfig.themes[theme]!.colorScheme.surfaceVariant,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                                ),
                                child: Row(
                                  children: [
                                    _buildHeaderCell('PAN', 100, theme),
                                    _buildHeaderCell('GSTIN', 140, theme),
                                    _buildHeaderCell('Aadhaar', 120, theme),
                                    _buildHeaderCell('Name', 120, theme),
                                    _buildHeaderCell('City', 100, theme),
                                  ],
                                ),
                              ),
                              // Data rows
                              Expanded(
                                child: ListView.builder(
                                  itemCount: sampleData.length,
                                  itemBuilder: (context, index) {
                                    final row = sampleData[index];
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: GoldenTestConfig.themes[theme]!.colorScheme.outline.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          _buildDataCell(row[0], 100, theme),
                                          _buildDataCell(row[1], 140, theme),
                                          _buildDataCell(row[2], 120, theme),
                                          _buildDataCell(row[3], 120, theme),
                                          _buildDataCell(row[4], 100, theme),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Showing 5 of 1,000 records',
                            style: GoldenTestConfig.themes[theme]!.textTheme.bodySmall),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.first_page),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: () {},
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: GoldenTestConfig.themes[theme]!.colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('1 / 200'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.last_page),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                theme,
              ),
              constraints: const BoxConstraints.tight(Size(732, 400)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'export format options',
      fileName: 'export_formats',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestScenario(
              name: 'export_panel_$theme',
              child: GoldenTestConfig.themedWrapper(
                Container(
                  width: 350,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Export Options',
                        style: GoldenTestConfig.themes[theme]!.textTheme.titleMedium),
                      const SizedBox(height: 16),

                      Text('File Format',
                        style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium),
                      const SizedBox(height: 8),

                      // Format selection chips
                      Wrap(
                        spacing: 8,
                        children: ['CSV', 'JSON', 'XLSX'].map((format) {
                          final isSelected = format == 'CSV';
                          return ChoiceChip(
                            selected: isSelected,
                            label: Text(format),
                            onSelected: (selected) {},
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // File name input
                      TextFormField(
                        initialValue: 'indian_test_data_${DateTime.now().millisecondsSinceEpoch}',
                        decoration: const InputDecoration(
                          labelText: 'File Name',
                          border: OutlineInputBorder(),
                          suffixText: '.csv',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Include headers toggle
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Include Headers'),
                        subtitle: const Text('Add column names to first row'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),

                      // Export buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy'),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.download),
                              label: const Text('Download'),
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
              constraints: const BoxConstraints.tight(Size(382, 350)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'data faker error states',
      fileName: 'data_faker_errors',
      builder: () {
        return GoldenTestConfig.errorScenarios(
          'data_faker',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_outlined, size: 64,
                  color: GoldenTestConfig.themes[theme]!.colorScheme.error),
                const SizedBox(height: 16),
                Text('Generation Failed',
                  style: GoldenTestConfig.themes[theme]!.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Unable to generate 10,000 records. Try reducing the count.',
                  style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium,
                  textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('⚠️ All generated data is synthetic. Do not use for fraud.',
                          style: TextStyle(color: Colors.orange, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
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
      'data faker loading states',
      fileName: 'data_faker_loading',
      builder: () {
        return GoldenTestConfig.loadingScenarios(
          'data_faker',
          (theme) => Container(
            padding: const EdgeInsets.all(32),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generating Indian test data...'),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.7),
                SizedBox(height: 8),
                Text('7,000 of 10,000 records generated'),
              ],
            ),
          ),
        );
      },
    );
  });
}

/// Helper functions for data table widgets
Widget _buildHeaderCell(String text, double width, String theme) {
  return SizedBox(
    width: width,
    child: Text(
      text,
      style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _buildDataCell(String text, double width, String theme) {
  return SizedBox(
    width: width,
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: GoldenTestConfig.themes[theme]!.colorScheme.onSurface,
      ),
    ),
  );
}

/// Helper function to get template icon
IconData _getTemplateIcon(String templateName) {
  switch (templateName) {
    case 'Individual':
      return Icons.person;
    case 'Company':
      return Icons.business;
    case 'Proprietorship':
      return Icons.store;
    case 'Partnership':
      return Icons.handshake;
    case 'Trust':
      return Icons.account_balance;
    default:
      return Icons.description;
  }
}