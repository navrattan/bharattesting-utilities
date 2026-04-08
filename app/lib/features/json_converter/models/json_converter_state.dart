import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bharattesting_core/src/json_converter/json_converter.dart';

part 'json_converter_state.freezed.dart';

@freezed
abstract class JsonConverterState with _$JsonConverterState {
  const factory JsonConverterState({
    @Default('') String inputText,
    @Default('') String outputText,
    @Default(false) bool isProcessing,
    @Default(false) bool autoRepairEnabled,
    @Default(false) bool prettifyOutput,
    @Default(InputFormat.unknown) InputFormat detectedFormat,
    @Default(0.0) double formatConfidence,
    @Default(<RepairRule>[]) List<RepairRule> appliedRepairs,
    @Default(<String>[]) List<String> errors,
    @Default(<String>[]) List<String> warnings,
    int? errorLineNumber,
    int? errorColumnNumber,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) = _JsonConverterState;

  const JsonConverterState._();

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
