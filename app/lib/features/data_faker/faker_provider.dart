import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bharattesting_core/core.dart' as core;

import 'faker_state.dart';

part 'faker_provider.g.dart';

@riverpod
class FakerNotifier extends _$FakerNotifier {
  @override
  FakerState build() {
    // Return initial state with sensible defaults for Individual template
    return const FakerState(
      selectedIdentifiers: {'name', 'phone', 'email', 'pan', 'aadhaar'},
    );
  }

  void updateTemplate(core.TemplateType template) {
    if (state.selectedTemplate == template) return;

    // Update template and reset identifiers while preserving other state
    state = state.copyWith(
      selectedTemplate: template,
      // Clear generated records when switching templates
      generatedRecords: [],
      errorMessage: null,
      // Reset identifiers to defaults for new template
      selectedIdentifiers: _getDefaultIdentifiersForTemplate(template),
    );
  }

  Set<String> _getDefaultIdentifiersForTemplate(core.TemplateType template) {
    switch (template) {
      case core.TemplateType.individual:
        return {'name', 'phone', 'email', 'pan', 'aadhaar'};
      case core.TemplateType.company:
        return {'name', 'pan', 'gstin', 'cin'};
      case core.TemplateType.proprietorship:
        return {'pan', 'gstin', 'udyam'};
      case core.TemplateType.partnership:
        return {'pan', 'gstin', 'tan'};
      case core.TemplateType.trust:
        return {'pan', 'gstin', 'registration'};
    }
  }

  void updateExportFormat(ExportFormat format) {
    state = state.copyWith(selectedExportFormat: format);
  }

  void updateRecordCount(int count) {
    state = state.copyWith(recordCount: count);
  }

  void toggleIdentifier(String id) {
    final current = Set<String>.from(state.selectedIdentifiers);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(selectedIdentifiers: current);
  }

  void setPreferredState(String? indianState) {
    state = state.copyWith(preferredState: indianState);
  }

  Future<void> generateRecords() async {
    if (state.isGenerating) return;

    // Validate that we have selected identifiers
    if (state.selectedIdentifiers.isEmpty) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Please select at least one data type to generate',
      );
      return;
    }

    state = state.copyWith(isGenerating: true, errorMessage: null);
    try {
      final seed = state.useRandomSeed ? null : state.customSeed;

      // Debug logging
      print('Generating records with template: ${state.selectedTemplate.name}');
      print('Selected identifiers: ${state.selectedIdentifiers}');
      print('Record count: ${state.recordCount}');

      final records = await compute(_generateRecordsInIsolate, {
        'template': state.selectedTemplate.name,
        'count': state.recordCount,
        'seed': seed,
        'preferredState': state.preferredState,
        'identifiers': state.selectedIdentifiers.toList(),
      });

      print('Generated ${records.length} records');
      if (records.isNotEmpty) {
        print('First record keys: ${records.first.keys}');
      }

      state = state.copyWith(
        generatedRecords: records,
        lastGeneratedAt: DateTime.now(),
        isGenerating: false,
      );
    } catch (e) {
      print('Error generating records: $e');
      state = state.copyWith(isGenerating: false, errorMessage: 'Failed to generate data: ${e.toString()}');
    }
  }

  Future<void> exportRecords() async {
    if (state.generatedRecords.isEmpty) return;
    state = state.copyWith(isExporting: true);

    try {
      final exportData = await compute(_exportRecordsInIsolate, {
        'records': state.generatedRecords,
        'format': state.selectedExportFormat.name,
        'prettify': state.prettifyOutput,
      });

      final tempDir = await getTemporaryDirectory();
      final ext = state.selectedExportFormat.name == 'js' ? 'js' : 
                  state.selectedExportFormat.name == 'ts' ? 'ts' :
                  state.selectedExportFormat.name == 'php' ? 'php' :
                  state.selectedExportFormat.name == 'python' ? 'py' : 
                  state.selectedExportFormat.name;
                  
      final file = File('${tempDir.path}/bharattesting_data.$ext');
      await file.writeAsBytes(exportData);

      await Share.shareXFiles([XFile(file.path)]);
      state = state.copyWith(isExporting: false);
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
    }
  }
}

List<Map<String, dynamic>> _generateRecordsInIsolate(Map<String, dynamic> params) {
  final count = params['count'] as int;
  final seed = params['seed'] as int?;
  final identifiers = params['identifiers'] as List<String>;
  final templateName = params['template'] as String;

  print('Isolate: Generating $count records for template: $templateName');
  print('Isolate: Requested identifiers: $identifiers');

  List<Map<String, dynamic>> rawRecords;

  try {
    switch (templateName) {
      case 'company':
        rawRecords = core.CompanyTemplate.generateBulk(count: count, baseSeed: seed);
        break;
      case 'proprietorship':
        rawRecords = core.ProprietorshipTemplate.generateBulk(count: count, baseSeed: seed);
        break;
      case 'partnership':
        rawRecords = core.PartnershipTemplate.generateBulk(count: count, baseSeed: seed);
        break;
      case 'trust':
        rawRecords = core.TrustTemplate.generateBulk(count: count, baseSeed: seed);
        break;
      default:
        rawRecords = core.IndividualTemplate.generateBulk(count: count, baseSeed: seed);
    }

    print('Isolate: Generated ${rawRecords.length} raw records');
    if (rawRecords.isNotEmpty) {
      print('Isolate: Raw record keys: ${rawRecords.first.keys}');
    }
  } catch (e) {
    print('Isolate: Error generating raw records: $e');
    throw Exception('Failed to generate records for $templateName template: $e');
  }
  
  final filteredRecords = rawRecords.map((record) {
    final filtered = <String, dynamic>{};

    // Filter based on requested identifiers
    for (final id in identifiers) {
      if (record.containsKey(id)) {
        filtered[id] = record[id];
      }
    }

    // Always include a name field - handle both individual and company names
    if (record.containsKey('name')) {
      filtered['name'] = record['name'];
    } else if (record.containsKey('company_name')) {
      filtered['name'] = record['company_name'];
      filtered['company_name'] = record['company_name'];
    }

    // Include template type for debugging
    if (record.containsKey('template_type')) {
      filtered['template_type'] = record['template_type'];
    }

    // Ensure we always have at least some data
    if (filtered.isEmpty && record.isNotEmpty) {
      // If filtering resulted in empty record, include a few key fields
      final fallbackFields = ['name', 'company_name', 'pan', 'gstin', 'aadhaar'];
      for (final field in fallbackFields) {
        if (record.containsKey(field)) {
          filtered[field] = record[field];
        }
      }
    }

    return filtered;
  }).toList();

  print('Isolate: Filtered to ${filteredRecords.length} records');
  if (filteredRecords.isNotEmpty) {
    print('Isolate: Filtered record keys: ${filteredRecords.first.keys}');
  }

  return filteredRecords;
}

Uint8List _exportRecordsInIsolate(Map<String, dynamic> params) {
  final records = params['records'] as List<Map<String, dynamic>>;
  final format = params['format'] as String;
  final prettify = params['prettify'] as bool;

  String output = '';
  
  switch (format) {
    case 'json':
      output = JsonEncoder.withIndent(prettify ? '  ' : null).convert(records);
      break;
    case 'csv':
      if (records.isNotEmpty) {
        final headers = records.first.keys.join(',');
        final rows = records.map((r) => r.values.join(',')).join('\n');
        output = '$headers\n$rows';
      }
      break;
    case 'sql':
      final table = 'test_data';
      for (final record in records) {
        final keys = record.keys.join(', ');
        final values = record.values.map((v) => "'$v'").join(', ');
        output += 'INSERT INTO $table ($keys) VALUES ($values);\n';
      }
      break;
    case 'html':
      output = '<table border="1">\n  <thead>\n    <tr>';
      if (records.isNotEmpty) {
        for (final key in records.first.keys) {
          output += '<th>$key</th>';
        }
        output += '</tr>\n  </thead>\n  <tbody>\n';
        for (final record in records) {
          output += '    <tr>';
          for (final value in record.values) {
            output += '<td>$value</td>';
          }
          output += '</tr>\n';
        }
      }
      output += '  </tbody>\n</table>';
      break;
    case 'js':
      output = 'const data = ${jsonEncode(records)};';
      break;
    case 'ts':
      output = 'interface Record {\n';
      if (records.isNotEmpty) {
        for (final key in records.first.keys) {
          output += '  $key: string;\n';
        }
      }
      output += '}\n\nconst data: Record[] = ${jsonEncode(records)};';
      break;
    case 'python':
      output = 'data = ${jsonEncode(records)}';
      break;
    case 'php':
      output = '<?php\n\$data = ' + _toPhpArray(records) + ';';
      break;
  }

  return Uint8List.fromList(utf8.encode(output));
}

String _toPhpArray(dynamic data) {
  if (data is List) {
    return '[' + data.map(_toPhpArray).join(', ') + ']';
  } else if (data is Map) {
    return '[' + data.entries.map((e) => "'${e.key}' => ${_toPhpArray(e.value)}").join(', ') + ']';
  } else {
    return "'$data'";
  }
}
