/// State management for Indian Data Faker
///
/// Manages template selection, generation options, and export functionality

import 'package:freezed_annotation/freezed_annotation.dart';

part 'faker_state.freezed.dart';

/// Available template types for generation
enum TemplateType {
  individual('Individual', 'Personal identifiers for individuals'),
  company('Company', 'Business identifiers for private/public companies'),
  proprietorship('Proprietorship', 'Sole proprietorship business identifiers'),
  partnership('Partnership', 'Partnership firm identifiers with partners'),
  trust('Trust', 'Trust/Society/Association identifiers');

  const TemplateType(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Available export formats
enum ExportFormat {
  csv('CSV', 'Comma-separated values'),
  json('JSON', 'JavaScript Object Notation'),
  xlsx('XLSX', 'Microsoft Excel format');

  const ExportFormat(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Bulk generation options
enum BulkSize {
  single(1, 'Single Record'),
  small(10, '10 Records'),
  medium(100, '100 Records'),
  large(1000, '1,000 Records'),
  xl(10000, '10,000 Records');

  const BulkSize(this.count, this.displayName);

  final int count;
  final String displayName;
}

/// State for Indian Data Faker
@freezed
class FakerState with _$FakerState {
  const factory FakerState({
    // Template selection
    @Default(TemplateType.individual) TemplateType selectedTemplate,

    // Generation options
    @Default(BulkSize.single) BulkSize bulkSize,
    @Default(true) bool useRandomSeed,
    @Default(null) int? customSeed,
    @Default(null) String? preferredState,

    // Identifier toggles (for custom selection)
    @Default(true) bool includeAllIdentifiers,
    @Default({}) Set<String> selectedIdentifiers,

    // Generated data
    @Default([]) List<Map<String, dynamic>> generatedRecords,
    @Default(null) DateTime? lastGeneratedAt,

    // Export options
    @Default(ExportFormat.json) ExportFormat selectedExportFormat,
    @Default(true) bool includeMetadata,
    @Default(true) bool prettifyOutput,

    // UI state
    @Default(false) bool isGenerating,
    @Default(false) bool isExporting,
    @Default(null) String? lastExportPath,
    @Default(null) String? errorMessage,

    // Performance metrics
    @Default(null) int? lastGenerationTimeMs,
    @Default(null) int? lastExportTimeMs,
  }) = _FakerState;
}

/// Extension methods for FakerState
extension FakerStateX on FakerState {
  /// Get available identifiers for the selected template
  List<String> get availableIdentifiers {
    switch (selectedTemplate) {
      case TemplateType.individual:
        return ['pan', 'aadhaar', 'pin_code', 'address', 'upi_id'];

      case TemplateType.company:
        return ['pan', 'gstin', 'cin', 'tan', 'ifsc', 'upi_id', 'udyam'];

      case TemplateType.proprietorship:
        return ['pan', 'gstin', 'udyam', 'tan', 'upi_id'];

      case TemplateType.partnership:
        return ['pan', 'gstin', 'tan', 'ifsc', 'upi_id', 'partners'];

      case TemplateType.trust:
        return ['pan', 'gstin', 'tan', 'ifsc', 'upi_id', 'registration'];
    }
  }

  /// Get the identifiers that will be generated
  Set<String> get effectiveIdentifiers {
    if (includeAllIdentifiers) {
      return availableIdentifiers.toSet();
    }
    return selectedIdentifiers.intersection(availableIdentifiers.toSet());
  }

  /// Check if state is valid for generation
  bool get canGenerate {
    return !isGenerating &&
           !isExporting &&
           (includeAllIdentifiers || selectedIdentifiers.isNotEmpty) &&
           (useRandomSeed || customSeed != null);
  }

  /// Check if there are records to export
  bool get canExport {
    return !isGenerating &&
           !isExporting &&
           generatedRecords.isNotEmpty;
  }

  /// Get seed to use for generation
  int? get seedToUse {
    if (useRandomSeed) {
      return DateTime.now().millisecondsSinceEpoch;
    }
    return customSeed;
  }

  /// Get template type string for core library
  String get templateTypeString {
    switch (selectedTemplate) {
      case TemplateType.individual:
        return 'individual';
      case TemplateType.company:
        return 'company';
      case TemplateType.proprietorship:
        return 'proprietorship';
      case TemplateType.partnership:
        return 'partnership';
      case TemplateType.trust:
        return 'trust';
    }
  }

  /// Get export format string for core library
  String get exportFormatString {
    switch (selectedExportFormat) {
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.json:
        return 'json';
      case ExportFormat.xlsx:
        return 'xlsx';
    }
  }

  /// Get file extension for export
  String get fileExtension {
    switch (selectedExportFormat) {
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.json:
        return 'json';
      case ExportFormat.xlsx:
        return 'xlsx';
    }
  }

  /// Get generation summary text
  String get generationSummary {
    if (generatedRecords.isEmpty) {
      return 'No records generated';
    }

    final count = generatedRecords.length;
    final template = selectedTemplate.displayName;
    final timeText = lastGenerationTimeMs != null
        ? ' in ${lastGenerationTimeMs}ms'
        : '';

    return '$count $template record${count == 1 ? '' : 's'} generated$timeText';
  }

  /// Get export summary text
  String get exportSummary {
    if (lastExportPath == null) {
      return 'No recent export';
    }

    final format = selectedExportFormat.displayName;
    final timeText = lastExportTimeMs != null
        ? ' in ${lastExportTimeMs}ms'
        : '';

    return 'Exported to $format$timeText';
  }

  /// Check if this is a business template (has business identifiers)
  bool get isBusinessTemplate {
    return selectedTemplate != TemplateType.individual;
  }

  /// Get template description with identifier count
  String get templateDescription {
    final identifierCount = availableIdentifiers.length;
    return '${selectedTemplate.description} ($identifierCount identifiers)';
  }

  /// Check if custom identifier selection is meaningful
  bool get supportsCustomSelection {
    return availableIdentifiers.length > 3; // Only useful if many identifiers
  }

  /// Get the effective bulk size (respects single record mode)
  int get effectiveBulkSize {
    return bulkSize.count;
  }

  /// Check if generation will be slow (large bulk size)
  bool get willBeSlowGeneration {
    return bulkSize.count >= 1000;
  }

  /// Get estimated generation time in seconds
  double get estimatedGenerationTimeSeconds {
    // Based on performance testing: ~3ms per record average
    return (bulkSize.count * 3.0) / 1000.0;
  }
}