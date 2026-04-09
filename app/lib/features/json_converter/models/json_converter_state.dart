import 'package:bharattesting_core/src/json_converter/json_converter.dart';
export 'package:bharattesting_core/src/json_converter/json_converter.dart';

class JsonConverterState {
  const JsonConverterState({
    this.inputText = '',
    this.outputText = '',
    this.isProcessing = false,
    this.autoRepairEnabled = false,
    this.prettifyOutput = false,
    this.detectedFormat = InputFormat.unknown,
    this.formatConfidence = 0.0,
    this.appliedRepairs = const <RepairRule>[],
    this.errors = const <String>[],
    this.warnings = const <String>[],
    this.errorLineNumber,
    this.errorColumnNumber,
    this.errorMessage,
    this.metadata,
  });

  final String inputText;
  final String outputText;
  final bool isProcessing;
  final bool autoRepairEnabled;
  final bool prettifyOutput;
  final InputFormat detectedFormat;
  final double formatConfidence;
  final List<RepairRule> appliedRepairs;
  final List<String> errors;
  final List<String> warnings;
  final int? errorLineNumber;
  final int? errorColumnNumber;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  JsonConverterState copyWith({
    String? inputText,
    String? outputText,
    bool? isProcessing,
    bool? autoRepairEnabled,
    bool? prettifyOutput,
    InputFormat? detectedFormat,
    double? formatConfidence,
    List<RepairRule>? appliedRepairs,
    List<String>? errors,
    List<String>? warnings,
    int? errorLineNumber,
    int? errorColumnNumber,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return JsonConverterState(
      inputText: inputText ?? this.inputText,
      outputText: outputText ?? this.outputText,
      isProcessing: isProcessing ?? this.isProcessing,
      autoRepairEnabled: autoRepairEnabled ?? this.autoRepairEnabled,
      prettifyOutput: prettifyOutput ?? this.prettifyOutput,
      detectedFormat: detectedFormat ?? this.detectedFormat,
      formatConfidence: formatConfidence ?? this.formatConfidence,
      appliedRepairs: appliedRepairs ?? this.appliedRepairs,
      errors: errors ?? this.errors,
      warnings: warnings ?? this.warnings,
      errorLineNumber: errorLineNumber ?? this.errorLineNumber,
      errorColumnNumber: errorColumnNumber ?? this.errorColumnNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasInput => inputText.trim().isNotEmpty;
  bool get hasOutput => outputText.trim().isNotEmpty;
  bool get canProcess => hasInput && !isProcessing;
  bool get wasRepaired => appliedRepairs.isNotEmpty;

  String get formatDisplayName {
    switch (detectedFormat) {
      case InputFormat.json:
        return 'JSON';
      case InputFormat.csv:
        return 'CSV';
      case InputFormat.yaml:
        return 'YAML';
      case InputFormat.xml:
        return 'XML';
      case InputFormat.urlEncoded:
        return 'URL Encoded';
      case InputFormat.ini:
        return 'INI';
      case InputFormat.unknown:
        return 'Unknown';
    }
  }

  String get confidenceDisplayText {
    if (formatConfidence == 0.0) return 'No detection';
    if (formatConfidence < 0.3) return 'Low confidence';
    if (formatConfidence < 0.7) return 'Medium confidence';
    return 'High confidence';
  }
}
