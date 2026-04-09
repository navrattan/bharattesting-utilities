import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bharattesting_core/core.dart' as core hide TemplateType;

import 'faker_state.dart';

part 'faker_provider.g.dart';

@riverpod
class FakerNotifier extends _$FakerNotifier {
  @override
  FakerState build() {
    return const FakerState();
  }

  /// Update selected template
  void setTemplate(TemplateType template) {
    state = state.copyWith(
      selectedTemplate: template,
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

  /// Toggle identifier selection
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

  /// Generate records based on current state
  Future<void> generateRecords() async {
    state = state.copyWith(isGenerating: true, errorMessage: null);

    final stopwatch = Stopwatch()..start();

    try {
      final seed = state.useRandomSeed ? null : state.customSeed;

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
      final exportData = await compute(_exportRecordsInIsolate, {
        'records': state.generatedRecords,
        'format': format.name,
        'template': state.selectedTemplate.name,
        'prettify': state.prettifyOutput,
        'includeMetadata': state.includeMetadata,
      });

      final tempDir = await getTemporaryDirectory();
      final fileName = 'bharattesting_export_${DateTime.now().millisecondsSinceEpoch}.${format.name}';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(exportData);

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

  /// Toggle prettify output
  void togglePrettify(bool value) {
    state = state.copyWith(prettifyOutput: value);
  }

  /// Toggle include metadata
  void toggleMetadata(bool value) {
    state = state.copyWith(includeMetadata: value);
  }

  /// Clear generated records
  void clearRecords() {
    state = state.copyWith(generatedRecords: [], lastGeneratedAt: null);
  }

  /// Get required identifiers for a template
  Set<String> getRequiredIdentifiers(TemplateType template) {
    switch (template) {
      case TemplateType.individual:
        return {'Name', 'PAN', 'Aadhaar', 'PIN Code', 'UPI ID'};
      case TemplateType.company:
        return {'Company Name', 'CIN', 'PAN', 'GSTIN', 'TAN', 'IFSC', 'PIN Code'};
      case TemplateType.proprietorship:
        return {'Business Name', 'PAN', 'GSTIN', 'Udyam', 'PIN Code'};
      case TemplateType.partnership:
        return {'Firm Name', 'PAN', 'GSTIN', 'TAN', 'PIN Code'};
      case TemplateType.trust:
        return {'Trust Name', 'PAN', 'GSTIN', 'TAN', 'PIN Code'};
    }
  }
}

/// Isolate function for record generation
List<Map<String, dynamic>> _generateRecordsInIsolate(Map<String, dynamic> params) {
  final templateName = params['template'] as String;
  final count = params['count'] as int;
  final seed = params['seed'] as int?;

  switch (templateName) {
    case 'individual':
      return core.IndividualTemplate.generateBulk(
        count: count,
        baseSeed: seed,
      );
    case 'company':
      return core.CompanyTemplate.generateBulk(
        count: count,
        baseSeed: seed,
      );
    case 'proprietorship':
      return core.ProprietorshipTemplate.generateBulk(
        count: count,
        baseSeed: seed,
      );
    case 'partnership':
      return core.PartnershipTemplate.generateBulk(
        count: count,
        baseSeed: seed,
      );
    case 'trust':
      return core.TrustTemplate.generateBulk(
        count: count,
        baseSeed: seed,
      );
    default:
      return core.IndividualTemplate.generateBulk(
        count: count,
        baseSeed: seed,
      );
  }
}

/// Isolate function for data export
Uint8List _exportRecordsInIsolate(Map<String, dynamic> params) {
  return Uint8List(0);
}
