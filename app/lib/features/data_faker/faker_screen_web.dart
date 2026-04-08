/// Indian Data Faker - Web Compatible Version
import 'package:flutter/material.dart';
import 'package:bharattesting_core/bharattesting_core.dart';

class FakerScreen extends StatefulWidget {
  const FakerScreen({super.key});

  @override
  State<FakerScreen> createState() => _FakerScreenState();
}

class _FakerScreenState extends State<FakerScreen> {
  TemplateType selectedTemplate = TemplateType.individual;
  Set<IdentifierType> selectedIdentifiers = {IdentifierType.pan};
  List<GeneratedRecord> generatedRecords = [];
  int bulkCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indian Data Faker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Disclaimer
            _buildDisclaimerCard(),
            const SizedBox(height: 24),

            // Controls
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left panel - Controls
                  Expanded(
                    flex: 1,
                    child: _buildControlsPanel(),
                  ),
                  const SizedBox(width: 24),

                  // Right panel - Results
                  Expanded(
                    flex: 2,
                    child: _buildResultsPanel(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '⚠️ DISCLAIMER: All generated data is synthetic and for testing only. Do not use for fraud or illegal activities.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Template Selection
            Text(
              'Template Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...TemplateType.values.map((template) => RadioListTile(
                  title: Text(template.displayName),
                  subtitle: Text(template.description),
                  value: template,
                  groupValue: selectedTemplate,
                  onChanged: (value) {
                    setState(() {
                      selectedTemplate = value!;
                    });
                  },
                )),

            const SizedBox(height: 24),

            // Identifier Selection
            Text(
              'Identifiers to Generate',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...IdentifierType.values.map((identifier) => CheckboxListTile(
                  title: Text(identifier.displayName),
                  subtitle: Text(identifier.description),
                  value: selectedIdentifiers.contains(identifier),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedIdentifiers.add(identifier);
                      } else {
                        selectedIdentifiers.remove(identifier);
                      }
                    });
                  },
                )),

            const SizedBox(height: 24),

            // Bulk Count
            Text(
              'Number of Records: $bulkCount',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: bulkCount.toDouble(),
              min: 1,
              max: 100,
              divisions: 99,
              onChanged: (value) {
                setState(() {
                  bulkCount = value.round();
                });
              },
            ),

            const SizedBox(height: 24),

            // Generate Button
            ElevatedButton.icon(
              onPressed: _generateData,
              icon: const Icon(Icons.casino),
              label: const Text('Generate Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Generated Records (${generatedRecords.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (generatedRecords.isNotEmpty) ...[
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _copyAsJson,
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy JSON'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _downloadCsv,
                        icon: const Icon(Icons.download),
                        label: const Text('Download CSV'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: generatedRecords.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.data_object,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No data generated yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select a template and identifiers, then click Generate',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : _buildRecordsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsList() {
    return ListView.separated(
      itemCount: generatedRecords.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final record = generatedRecords[index];
        return ExpansionTile(
          title: Text('Record ${index + 1} (${record.template.displayName})'),
          subtitle: Text('${record.identifiers.length} identifiers'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...record.identifiers.entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                '${entry.key.displayName}:',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                entry.value,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (record.metadata.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Additional Data:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    ...record.metadata.entries.map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  '${entry.key}:',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: SelectableText(
                                  entry.value.toString(),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _generateData() {
    if (selectedIdentifiers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one identifier type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final service = DataFakerService();
    final newRecords = service.generateBulk(
      template: selectedTemplate,
      identifiers: selectedIdentifiers,
      count: bulkCount,
    );

    setState(() {
      generatedRecords = newRecords;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generated $bulkCount ${selectedTemplate.displayName} records'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _copyAsJson() {
    // TODO: Implement clipboard copy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON copied to clipboard!')),
    );
  }

  void _downloadCsv() {
    // TODO: Implement CSV download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV download started!')),
    );
  }
}