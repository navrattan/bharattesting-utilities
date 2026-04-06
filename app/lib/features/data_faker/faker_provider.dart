/// Riverpod provider for Indian Data Faker
///
/// Manages state and business logic for data generation and export

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

// Core imports
import 'package:core/core.dart';

import 'faker_state.dart';

part 'faker_provider.g.dart';

/// Provider for Indian Data Faker
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
      selectedIdentifiers: {},
      // Clear previous data
      generatedRecords: [],
      errorMessage: null,
    );
  }

  /// Update bulk size
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

  /// Set custom seed value
  void setCustomSeed(int? seed) {
    state = state.copyWith(
      customSeed: seed,
      errorMessage: null,
    );
  }

  /// Set preferred state for generation
  void setPreferredState(String? stateName) {
    state = state.copyWith(
      preferredState: stateName,
      errorMessage: null,
    );
  }

  /// Toggle include all identifiers
  void setIncludeAllIdentifiers(bool includeAll) {
    state = state.copyWith(
      includeAllIdentifiers: includeAll,
      errorMessage: null,
    );
  }

  /// Toggle specific identifier selection
  void toggleIdentifier(String identifier) {
    final current = Set<String>.from(state.selectedIdentifiers);

    if (current.contains(identifier)) {
      current.remove(identifier);
    } else {
      current.add(identifier);
    }

    state = state.copyWith(
      selectedIdentifiers: current,
      errorMessage: null,
    );
  }

  /// Set export format
  void setExportFormat(ExportFormat format) {
    state = state.copyWith(
      selectedExportFormat: format,
      errorMessage: null,
    );
  }

  /// Toggle export metadata inclusion
  void setIncludeMetadata(bool include) {
    state = state.copyWith(
      includeMetadata: include,
      errorMessage: null,
    );
  }

  /// Toggle output prettification
  void setPrettifyOutput(bool prettify) {
    state = state.copyWith(
      prettifyOutput: prettify,
      errorMessage: null,
    );
  }

  /// Generate data records
  Future<void> generateRecords() async {
    if (!state.canGenerate) return;

    state = state.copyWith(
      isGenerating: true,
      errorMessage: null,
    );

    try {
      final stopwatch = Stopwatch()..start();

      final records = await compute(_generateRecordsInIsolate, {
        'template': state.templateTypeString,
        'count': state.effectiveBulkSize,
        'seed': state.seedToUse,
        'preferredState': state.preferredState,
      });

      stopwatch.stop();

      state = state.copyWith(
        isGenerating: false,
        generatedRecords: records,
        lastGeneratedAt: DateTime.now(),
        lastGenerationTimeMs: stopwatch.elapsedMilliseconds,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Generation failed: ${e.toString()}',
      );
    }
  }

  /// Export generated records
  Future<void> exportRecords() async {
    if (!state.canExport) return;

    state = state.copyWith(
      isExporting: true,
      errorMessage: null,
    );

    try {
      final stopwatch = Stopwatch()..start();

      final exportData = await compute(_exportRecordsInIsolate, {
        'records': state.generatedRecords,
        'format': state.exportFormatString,
        'template': state.templateTypeString,
        'includeMetadata': state.includeMetadata,
        'prettify': state.prettifyOutput,
      });

      stopwatch.stop();

      // Save and share file
      final filePath = await _saveAndShareFile(
        exportData,
        state.templateTypeString,
        state.fileExtension,
      );

      state = state.copyWith(
        isExporting: false,
        lastExportPath: filePath,
        lastExportTimeMs: stopwatch.elapsedMilliseconds,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'Export failed: ${e.toString()}',
      );
    }
  }

  /// Copy single record to clipboard
  Future<void> copySingleRecord(Map<String, dynamic> record) async {
    try {
      final json = JSONExporter.exportSingleRecord(record, prettify: true);
      await Clipboard.setData(ClipboardData(text: json));
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Copy failed: ${e.toString()}',
      );
    }
  }

  /// Copy all records to clipboard as JSON
  Future<void> copyAllRecords() async {
    if (state.generatedRecords.isEmpty) return;

    try {
      final json = JSONExporter.exportToJSONArray(
        state.generatedRecords,
        prettify: state.prettifyOutput,
      );
      await Clipboard.setData(ClipboardData(text: json));
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Copy failed: ${e.toString()}',
      );
    }
  }

  /// Clear generated records
  void clearRecords() {
    state = state.copyWith(
      generatedRecords: [],
      lastGeneratedAt: null,
      lastGenerationTimeMs: null,
      lastExportPath: null,
      lastExportTimeMs: null,
      errorMessage: null,
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset to default state
  void reset() {
    state = const FakerState();
  }
}

/// Generate records in isolate for performance
Future<List<Map<String, dynamic>>> _generateRecordsInIsolate(
  Map<String, dynamic> params,
) async {
  final template = params['template'] as String;
  final count = params['count'] as int;
  final seed = params['seed'] as int?;
  final preferredState = params['preferredState'] as String?;

  switch (template) {
    case 'individual':
      return IndividualTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'company':
      return CompanyTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'proprietorship':
      return ProprietorshipTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'partnership':
      return PartnershipTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'trust':
      return TrustTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    default:
      throw ArgumentError('Unknown template: $template');
  }
}

/// Export records in isolate for performance
Future<dynamic> _exportRecordsInIsolate(
  Map<String, dynamic> params,
) async {
  final records = (params['records'] as List).cast<Map<String, dynamic>>();
  final format = params['format'] as String;
  final template = params['template'] as String;
  final includeMetadata = params['includeMetadata'] as bool;
  final prettify = params['prettify'] as bool;

  switch (format) {
    case 'csv':
      return CSVExporter.exportTemplateToCSV(records, template);

    case 'json':
      if (includeMetadata) {
        return JSONExporter.exportTemplateToJSON(
          records,
          template,
          prettify: prettify,
        );
      } else {
        return JSONExporter.exportToJSONArray(
          records,
          prettify: prettify,
        );
      }

    case 'xlsx':
      return XLSXExporter.exportTemplateToXLSX(
        records,
        template,
        includeMetadataSheet: includeMetadata,
      );

    default:
      throw ArgumentError('Unknown format: $format');
  }
}

/// Save file and share it
Future<String> _saveAndShareFile(
  dynamic data,
  String template,
  String extension,
) async {
  final timestamp = DateTime.now().toIso8601String().split('T')[0];
  final filename = 'bharattesting_faker_${template}_$timestamp.$extension';

  if (kIsWeb) {
    // Web: Download directly
    final bytes = data is String
        ? Uint8List.fromList(data.codeUnits)
        : data as Uint8List;

    // Use web download (would need platform-specific implementation)
    // For now, copy to clipboard as fallback
    if (data is String && extension != 'xlsx') {
      await Clipboard.setData(ClipboardData(text: data));
      return 'Copied to clipboard';
    } else {
      throw UnsupportedError('XLSX download not implemented for web');
    }
  } else {
    // Mobile: Save to documents directory and share
    final documentsDir = await getApplicationDocumentsDirectory();
    final btDir = Directory('${documentsDir.path}/BharatTesting');
    await btDir.create(recursive: true);

    final file = File('${btDir.path}/$filename');

    if (data is String) {
      await file.writeAsString(data);
    } else if (data is Uint8List) {
      await file.writeAsBytes(data);
    } else {
      throw ArgumentError('Unsupported data type for file writing');
    }

    // Share the file
    await Share.shareXFiles([XFile(file.path)]);

    return file.path;
  }
}

/// Provider for available Indian states
@riverpod
List<String> availableStates(AvailableStatesRef ref) {
  return [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep',
    'Puducherry',
  ];
}