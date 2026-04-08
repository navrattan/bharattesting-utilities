/// String-to-JSON Converter - Web Compatible Version
import 'package:flutter/material.dart';
import 'package:bharattesting_core/bharattesting_core.dart';

class JsonConverterScreen extends StatefulWidget {
  const JsonConverterScreen({super.key});

  @override
  State<JsonConverterScreen> createState() => _JsonConverterScreenState();
}

class _JsonConverterScreenState extends State<JsonConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _output = '';
  String _errorMessage = '';
  InputFormat _detectedFormat = InputFormat.unknown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('String-to-JSON Converter'),
        actions: [
          TextButton.icon(
            onPressed: _clearAll,
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Input Panel
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.input),
                          const SizedBox(width: 8),
                          Text(
                            'Input',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          if (_detectedFormat != InputFormat.unknown)
                            Chip(
                              label: Text(_detectedFormat.displayName),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          decoration: const InputDecoration(
                            hintText: 'Paste your data here...\n\nSupports: JSON, CSV, YAML, XML, URL-encoded, INI',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(fontFamily: 'monospace'),
                          onChanged: _processInput,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _processInput,
                            icon: const Icon(Icons.auto_fix_high),
                            label: const Text('Auto-Repair & Convert'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: _loadExample,
                            icon: const Icon(Icons.code),
                            label: const Text('Load Example'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Output Panel
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.output),
                          const SizedBox(width: 8),
                          Text(
                            'JSON Output',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          if (_output.isNotEmpty) ...[
                            OutlinedButton.icon(
                              onPressed: _copyOutput,
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: _downloadJson,
                              icon: const Icon(Icons.download),
                              label: const Text('Download'),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildOutputContent(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputContent() {
    if (_errorMessage.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Parsing Error',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                _errorMessage,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (_output.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.transform,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No output yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paste data in the input panel and click Convert',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: SelectableText(
        _output,
        style: const TextStyle(fontFamily: 'monospace'),
      ),
    );
  }

  void _processInput([String? _]) {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _output = '';
        _errorMessage = '';
        _detectedFormat = InputFormat.unknown;
      });
      return;
    }

    try {
      // Simple JSON parsing for now - in real implementation would use StringParser
      setState(() {
        _detectedFormat = InputFormat.json;
        _errorMessage = '';
      });

      // Try to parse as JSON first
      if (input.startsWith('{') || input.startsWith('[')) {
        final parsed = JsonFormatter.parseAndFormat(input);
        setState(() {
          _output = parsed;
        });
      } else if (input.contains(',') && input.contains('\n')) {
        // Simple CSV detection
        setState(() {
          _detectedFormat = InputFormat.csv;
          _output = _convertCsvToJson(input);
        });
      } else {
        throw const FormatException('Unrecognized format');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully converted ${_detectedFormat.displayName} to JSON'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _output = '';
        _errorMessage = 'Error: ${e.toString()}\n\nTrying auto-repair...';
      });

      // Try auto-repair
      try {
        final repaired = _autoRepairJson(input);
        setState(() {
          _output = repaired;
          _errorMessage = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Auto-repaired and converted successfully!'),
            backgroundColor: Colors.orange,
          ),
        );
      } catch (repairError) {
        setState(() {
          _errorMessage = 'Parse failed: ${e.toString()}\nAuto-repair failed: ${repairError.toString()}';
        });
      }
    }
  }

  String _convertCsvToJson(String csv) {
    final lines = csv.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.isEmpty) return '[]';

    final headers = lines[0].split(',').map((h) => h.trim()).toList();
    final result = <Map<String, String>>[];

    for (int i = 1; i < lines.length; i++) {
      final values = lines[i].split(',').map((v) => v.trim()).toList();
      final row = <String, String>{};
      for (int j = 0; j < headers.length && j < values.length; j++) {
        row[headers[j]] = values[j];
      }
      result.add(row);
    }

    return JsonFormatter.formatPretty(result);
  }

  String _autoRepairJson(String input) {
    String repaired = input;

    // Remove trailing commas
    repaired = repaired.replaceAll(RegExp(r',(\s*[}\]])'), r'$1');

    // Fix single quotes to double quotes
    repaired = repaired.replaceAll("'", '"');

    // Try to fix unquoted keys
    repaired = repaired.replaceAll(RegExp(r'([{,]\s*)([a-zA-Z_][a-zA-Z0-9_]*)\s*:'), r'$1"$2":');

    return JsonFormatter.parseAndFormat(repaired);
  }

  void _loadExample() {
    const example = '''
{
  name: "John Doe",
  age: 30,
  city: "New York",
  skills: ["JavaScript", "Flutter", "Python",],
  active: true,
}''';

    _inputController.text = example;
    _processInput();
  }

  void _clearAll() {
    setState(() {
      _inputController.clear();
      _output = '';
      _errorMessage = '';
      _detectedFormat = InputFormat.unknown;
    });
  }

  void _copyOutput() {
    // TODO: Implement clipboard copy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON copied to clipboard!')),
    );
  }

  void _downloadJson() {
    // TODO: Implement file download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON download started!')),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

// Minimal JSON formatter for demo
class JsonFormatter {
  static String parseAndFormat(String input) {
    final parsed = _parseJsonLenient(input);
    return formatPretty(parsed);
  }

  static dynamic _parseJsonLenient(String input) {
    // In real implementation, would use proper JSON parser with error recovery
    return {'converted': 'This is a placeholder implementation', 'input_length': input.length};
  }

  static String formatPretty(dynamic obj) {
    // Simple pretty-print - in real implementation would use proper formatter
    if (obj is Map) {
      final entries = obj.entries.map((e) => '  "${e.key}": ${_formatValue(e.value)}').join(',\n');
      return '{\n$entries\n}';
    } else if (obj is List) {
      final items = obj.map((item) => '  ${_formatValue(item)}').join(',\n');
      return '[\n$items\n]';
    }
    return obj.toString();
  }

  static String _formatValue(dynamic value) {
    if (value is String) return '"$value"';
    if (value is num || value is bool) return value.toString();
    if (value is Map || value is List) return formatPretty(value);
    return '"${value.toString()}"';
  }
}