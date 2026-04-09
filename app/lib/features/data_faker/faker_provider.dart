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
    return const FakerState(
      selectedIdentifiers: {'name', 'phone', 'email', 'pan', 'aadhaar'},
    );
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

  Future<void> generateRecords() async {
    state = state.copyWith(isGenerating: true, errorMessage: null);
    try {
      final seed = state.useRandomSeed ? null : state.customSeed;
      final records = await compute(_generateRecordsInIsolate, {
        'template': state.selectedTemplate.name,
        'count': state.recordCount,
        'seed': seed,
        'preferredState': state.preferredState,
        'identifiers': state.selectedIdentifiers.toList(),
      });

      state = state.copyWith(
        generatedRecords: records,
        lastGeneratedAt: DateTime.now(),
        isGenerating: false,
      );
    } catch (e) {
      state = state.copyWith(isGenerating: false, errorMessage: e.toString());
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
  
  List<Map<String, dynamic>> rawRecords;
  
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
  
  return rawRecords.map((record) {
    final filtered = <String, dynamic>{};
    for (final id in identifiers) {
      if (record.containsKey(id)) {
        filtered[id] = record[id];
      }
    }
    // Always include a name if available
    if (record.containsKey('name')) {
      filtered['name'] = record['name'];
    }
    return filtered;
  }).toList();
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
