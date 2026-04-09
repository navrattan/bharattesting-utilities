/// State management for Indian Data Faker
///
/// Manages template selection, generation options, and export functionality

import 'package:bharattesting_core/core.dart' as core;

/// Available identifier categories for selection
enum ExportFormat {
  json('JSON', 'JavaScript Object Notation'),
  csv('CSV', 'Comma-separated values'),
  sql('SQL', 'SQL INSERT statements'),
  xml('XML', 'eXtensible Markup Language'),
  html('HTML', 'HTML Table format'),
  js('Javascript', 'JS Object Array'),
  ts('Typescript', 'TS Interface & Data'),
  php('PHP', 'PHP Associative Array'),
  python('Python', 'Python List of Dicts');

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
class FakerState {
  const FakerState({
    this.selectedTemplate = core.TemplateType.individual,
    this.bulkSize = BulkSize.single,
    this.useRandomSeed = true,
    this.customSeed,
    this.preferredState,
    this.includeAllIdentifiers = true,
    this.selectedIdentifiers = const {},
    this.generatedRecords = const [],
    this.lastGeneratedAt,
    this.selectedExportFormat = ExportFormat.json,
    this.includeMetadata = true,
    this.prettifyOutput = true,
    this.isGenerating = false,
    this.isExporting = false,
    this.lastExportPath,
    this.errorMessage,
    this.lastGenerationTimeMs,
    this.lastExportTimeMs,
  });

  final core.TemplateType selectedTemplate;
  final BulkSize bulkSize;
  final bool useRandomSeed;
  final int? customSeed;
  final String? preferredState;
  final bool includeAllIdentifiers;
  final Set<String> selectedIdentifiers;
  final List<Map<String, dynamic>> generatedRecords;
  final DateTime? lastGeneratedAt;
  final ExportFormat selectedExportFormat;
  final bool includeMetadata;
  final bool prettifyOutput;
  final bool isGenerating;
  final bool isExporting;
  final String? lastExportPath;
  final String? errorMessage;
  final int? lastGenerationTimeMs;
  final int? lastExportTimeMs;

  FakerState copyWith({
    core.TemplateType? selectedTemplate,
    BulkSize? bulkSize,
    bool? useRandomSeed,
    int? customSeed,
    String? preferredState,
    bool? includeAllIdentifiers,
    Set<String>? selectedIdentifiers,
    List<Map<String, dynamic>>? generatedRecords,
    DateTime? lastGeneratedAt,
    ExportFormat? selectedExportFormat,
    bool? includeMetadata,
    bool? prettifyOutput,
    bool? isGenerating,
    bool? isExporting,
    String? lastExportPath,
    String? errorMessage,
    int? lastGenerationTimeMs,
    int? lastExportTimeMs,
  }) {
    return FakerState(
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      bulkSize: bulkSize ?? this.bulkSize,
      useRandomSeed: useRandomSeed ?? this.useRandomSeed,
      customSeed: customSeed ?? this.customSeed,
      preferredState: preferredState ?? this.preferredState,
      includeAllIdentifiers: includeAllIdentifiers ?? this.includeAllIdentifiers,
      selectedIdentifiers: selectedIdentifiers ?? this.selectedIdentifiers,
      generatedRecords: generatedRecords ?? this.generatedRecords,
      lastGeneratedAt: lastGeneratedAt ?? this.lastGeneratedAt,
      selectedExportFormat: selectedExportFormat ?? this.selectedExportFormat,
      includeMetadata: includeMetadata ?? this.includeMetadata,
      prettifyOutput: prettifyOutput ?? this.prettifyOutput,
      isGenerating: isGenerating ?? this.isGenerating,
      isExporting: isExporting ?? this.isExporting,
      lastExportPath: lastExportPath ?? this.lastExportPath,
      errorMessage: errorMessage ?? this.errorMessage,
      lastGenerationTimeMs: lastGenerationTimeMs ?? this.lastGenerationTimeMs,
      lastExportTimeMs: lastExportTimeMs ?? this.lastExportTimeMs,
    );
  }
}

/// Extension methods for FakerState
extension FakerStateX on FakerState {
  /// Get available identifiers for the selected template
  List<String> get availableIdentifiers {
    switch (selectedTemplate) {
      case core.TemplateType.individual:
        return ['pan', 'aadhaar', 'pin_code', 'address', 'upi_id'];

      case core.TemplateType.company:
        return ['pan', 'gstin', 'cin', 'tan', 'ifsc', 'upi_id', 'udyam'];

      case core.TemplateType.proprietorship:
        return ['pan', 'gstin', 'udyam', 'tan', 'upi_id'];

      case core.TemplateType.partnership:
        return ['pan', 'gstin', 'tan', 'ifsc', 'upi_id', 'partners'];

      case core.TemplateType.trust:
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
    return selectedTemplate.name;
  }

  /// Get export format string for core library
  String get exportFormatString {
    switch (selectedExportFormat) {
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.json:
        return 'json';
      case ExportFormat.sql:
        return 'sql';
      case ExportFormat.xml:
        return 'xml';
      case ExportFormat.html:
        return 'html';
      case ExportFormat.js:
        return 'js';
      case ExportFormat.ts:
        return 'ts';
      case ExportFormat.php:
        return 'php';
      case ExportFormat.python:
        return 'python';
    }
  }

  /// Get file extension for export
  String get fileExtension {
    switch (selectedExportFormat) {
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.json:
        return 'json';
      case ExportFormat.sql:
        return 'sql';
      case ExportFormat.xml:
        return 'xml';
      case ExportFormat.html:
        return 'html';
      case ExportFormat.js:
        return 'js';
      case ExportFormat.ts:
        return 'ts';
      case ExportFormat.php:
        return 'php';
      case ExportFormat.python:
        return 'py';
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
    return selectedTemplate != core.TemplateType.individual;
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
