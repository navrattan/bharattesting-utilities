/// Riverpod provider for Indian Data Faker
///
/// Manages state and business logic for data generation and export

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import 'faker_state.dart';

part 'faker_provider.g.dart';

@riverpod
class FakerNotifier extends _$FakerNotifier {
  @override
  FakerState build() {
    return const FakerState();
  }

  /// Update selected template type
  void setTemplate(TemplateType template) {
    state = state.copyWith(
      selectedTemplate: template,
      // Reset identifier selection when template changes
      selectedIdentifiers: _getDefaultIdentifiers(template),
      errorMessage: null,
    );
  }

  /// Toggle an identifier type in custom selection
  void toggleIdentifier(String id) {
    final current = Set<String>.from(state.selectedIdentifiers);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }

    state = state.copyWith(
      selectedIdentifiers: current,
      errorMessage: null,
    );
  }

  /// Set bulk generation size
  void setBulkSize(BulkSize size) {
    state = state.copyWith(
      bulkSize: size,
      errorMessage: null,
    );
  }

  /// Toggle between random and custom seed
  void setUseRandomSeed(bool useRandom) {
    state = state.copyWith(
      useRandomSeed: useRandom,
      errorMessage: null,
    );
  }

  /// Set custom integer seed
  void setCustomSeed(int? seed) {
    state = state.copyWith(
      customSeed: seed,
      errorMessage: null,
    );
  }

  /// Set preferred state for regional identifiers
  void setPreferredState(String? stateName) {
    state = state.copyWith(
      preferredState: stateName,
      errorMessage: null,
    );
  }

  /// Generate records based on current state
  Future<void> generateRecords() async {
    state = state.copyWith(isGenerating: true, errorMessage: null);

    final stopwatch = Stopwatch()..start();

    try {
      final seed = state.useRandomSeed ? null : state.customSeed;

      // Generate records in isolate for performance
      final records = await compute(_generateRecordsInIsolate, {
        'template': state.selectedTemplate.name,
        'count': state.bulkSize.count,
        'seed': seed,
        'preferredState': state.preferredState,
      });

      state = state.copyWith(
        generatedRecords: records,
        lastGeneratedAt: DateTime.now(),
        lastGenerationTimeMs: stopwatch.elapsedMilliseconds,
        isGenerating: false,
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Generation failed: ${e.toString()}',
      );
    }
  }

  /// Export generated records to a file and share
  Future<void> exportRecords(ExportFormat format) async {
    if (state.generatedRecords.isEmpty) return;

    state = state.copyWith(isExporting: true, selectedExportFormat: format);

    final stopwatch = Stopwatch()..start();

    try {
      // Export records in isolate for performance
      final exportData = await compute(_exportRecordsInIsolate, {
        'records': state.generatedRecords,
        'format': format.name,
        'template': state.selectedTemplate.name,
        'prettify': state.prettifyOutput,
        'includeMetadata': state.includeMetadata,
      });

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final fileName = 'bharattesting_export_${DateTime.now().millisecondsSinceEpoch}.${format.name}';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(exportData);

      // Share the file
      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'BharatTesting Export - ${state.selectedTemplate.name}',
      );

      state = state.copyWith(
        isExporting: false,
        lastExportPath: file.path,
        lastExportTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'Export failed: ${e.toString()}',
      );
    }
  }

  /// Copy all generated records to clipboard
  Future<void> copyToClipboard() async {
    if (state.generatedRecords.isEmpty) return;

    final jsonString = const JsonEncoder.withIndent('  ').convert(state.generatedRecords);
    await Clipboard.setData(ClipboardData(text: jsonString));
  }

  /// Copy single record to clipboard
  Future<void> copySingleToClipboard(Map<String, dynamic> record) async {
    final jsonString = const JsonEncoder.withIndent('  ').convert(record);
    await Clipboard.setData(ClipboardData(text: jsonString));
  }

  Set<String> _getDefaultIdentifiers(TemplateType template) {
    switch (template) {
      case TemplateType.individual:
        return {'pan', 'aadhaar', 'address', 'phone', 'email', 'upi', 'bank'};
      case TemplateType.company:
        return {'pan', 'gstin', 'cin', 'tan', 'address', 'bank'};
      case TemplateType.proprietorship:
        return {'pan', 'gstin', 'udyam', 'address', 'bank'};
      case TemplateType.partnership:
        return {'pan', 'gstin', 'tan', 'address', 'bank'};
      case TemplateType.trust:
        return {'pan', 'tan', 'registration', 'address'};
    }
  }
}

/// Isolate function for record generation
List<Map<String, dynamic>> _generateRecordsInIsolate(Map<String, dynamic> params) {
  final template = params['template'] as String;
  final count = params['count'] as int;
  final seed = params['seed'] as int?;
  final preferredState = params['preferredState'] as String?;

  // ignore: unused_local_variable
  final random = seed != null ? math.Random(seed) : math.Random();

  // Mock implementation for now
  return List.generate(count, (index) {
    final record = <String, dynamic>{
      'id': index + 1,
      'generated_at': DateTime.now().toIso8601String(),
    };

    if (template == 'individual') {
      record.addAll({
        'name': 'Person ${index + 1}',
        'pan': 'ABCDE${1000 + index}F',
        'aadhaar': '1234 5678 ${1000 + index}',
      });
    } else {
      record.addAll({
        'entity_name': 'Entity ${index + 1}',
        'pan': 'ABCDE${1000 + index}C',
        'gstin': '29ABCDE${1000 + index}C1Z5',
      });
    }

    if (preferredState != null) {
      record['state'] = preferredState;
    }

    return record;
  });
}

/// Isolate function for data export
Uint8List _exportRecordsInIsolate(Map<String, dynamic> params) {
  final records = params['records'] as List<Map<String, dynamic>>;
  final format = params['format'] as String;
  final prettify = params['prettify'] as bool;

  String output;

  if (format == 'json') {
    output = prettify
        ? const JsonEncoder.withIndent('  ').convert(records)
        : jsonEncode(records);
  } else {
    // Basic CSV implementation
    if (records.isEmpty) return Uint8List(0);
    
    final buffer = StringBuffer();
    final headers = records.first.keys.toList();
    buffer.writeln(headers.join(','));

    for (final record in records) {
      final values = headers.map((h) => '"${record[h]}"').toList();
      buffer.writeln(values.join(','));
    }
    output = buffer.toString();
  }

  return Uint8List.fromList(utf8.encode(output));
}

/// Provider for available Indian states
@riverpod
List<String> availableStates(Ref ref) {
  return [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
    'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
    'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
    'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Delhi', 'Jammu and Kashmir', 'Ladakh', 'Puducherry'
  ];
}
