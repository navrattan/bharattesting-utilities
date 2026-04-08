import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharattesting_core/core.dart';
import '../models/json_converter_state.dart';

part 'json_converter_provider.g.dart';

@riverpod
class JsonConverter extends _$JsonConverter {
  Timer? _debounceTimer;

  @override
  JsonConverterState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    return const JsonConverterState();
  }

  void updateInputText(String text) {
    if (text == state.inputText) return;

    state = state.copyWith(
      inputText: text,
      errors: <String>[],
      warnings: <String>[],
      errorLineNumber: null,
      errorColumnNumber: null,
      errorMessage: null,
    );

    // Debounce auto-processing
    _debounceTimer?.cancel();
    if (text.trim().isNotEmpty) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        processInput();
      });
    } else {
      state = state.copyWith(
        outputText: '',
        detectedFormat: InputFormat.unknown,
        formatConfidence: 0.0,
        appliedRepairs: <RepairRule>[],
        metadata: null,
      );
    }
  }

  void toggleAutoRepair() {
    state = state.copyWith(autoRepairEnabled: !state.autoRepairEnabled);
    if (state.hasInput) {
      processInput();
    }
  }

  void togglePrettify() {
    state = state.copyWith(prettifyOutput: !state.prettifyOutput);
    if (state.hasOutput && state.detectedFormat == InputFormat.json) {
      _formatJsonOutput();
    }
  }

  Future<void> processInput() async {
    if (!state.canProcess) return;

    state = state.copyWith(
      isProcessing: true,
      errors: <String>[],
      warnings: <String>[],
      errorLineNumber: null,
      errorColumnNumber: null,
      errorMessage: null,
    );

    try {
      final input = state.inputText.trim();

      if (state.autoRepairEnabled) {
        await _processWithAutoRepair(input);
      } else {
        await _processWithoutRepair(input);
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errors: ['Unexpected error: ${e.toString()}'],
        outputText: '',
      );
    }
  }

  Future<void> _processWithAutoRepair(String input) async {
    try {
      // Try auto-repair first
      final repairResult = AutoRepair.repairJSON(input);

      if (repairResult.isSuccess) {
        // Successfully repaired
        final jsonData = jsonDecode(repairResult.repaired);
        final formattedJson = state.prettifyOutput
            ? const JsonEncoder.withIndent('  ').convert(jsonData)
            : jsonEncode(jsonData);

        state = state.copyWith(
          isProcessing: false,
          outputText: formattedJson,
          detectedFormat: InputFormat.json,
          formatConfidence: 1.0,
          appliedRepairs: repairResult.appliedRules,
          warnings: const <String>[],
        );
      } else {
        // Repair failed, try multi-format detection
        await _processMultiFormat(input, repairResult);
      }
    } catch (e) {
      // Fallback to multi-format detection
      await _processMultiFormat(input, null);
    }
  }

  Future<void> _processWithoutRepair(String input) async {
    try {
      // Try direct JSON parsing first
      final jsonData = jsonDecode(input);
      final formattedJson = state.prettifyOutput
          ? const JsonEncoder.withIndent('  ').convert(jsonData)
          : jsonEncode(jsonData);

      state = state.copyWith(
        isProcessing: false,
        outputText: formattedJson,
        detectedFormat: InputFormat.json,
        formatConfidence: 1.0,
        appliedRepairs: <RepairRule>[],
      );
    } catch (e) {
      // JSON parsing failed, try multi-format detection
      await _processMultiFormat(input, null);
    }
  }

  Future<void> _processMultiFormat(String input, RepairResult? failedRepair) async {
    final parseResult = StringParser.parseAny(input);

    if (parseResult.isSuccess) {
      String outputJson;
      try {
        outputJson = state.prettifyOutput
            ? const JsonEncoder.withIndent('  ').convert(parseResult.data)
            : jsonEncode(parseResult.data);
      } catch (e) {
        outputJson = jsonEncode({
          'data': parseResult.data,
          'metadata': parseResult.metadata,
        });
      }

      final warnings = <String>[];
      if (parseResult.detectedFormat != InputFormat.json) {
        warnings.add('Converted from ${parseResult.detectedFormat.name.toUpperCase()} to JSON');
      }

      state = state.copyWith(
        isProcessing: false,
        outputText: outputJson,
        detectedFormat: parseResult.detectedFormat,
        formatConfidence: parseResult.confidence,
        warnings: warnings,
        metadata: parseResult.metadata,
        appliedRepairs: <RepairRule>[],
      );
    } else {
      // All parsing failed
      final errors = <String>[];

      if (failedRepair != null && failedRepair.errors != null) {
        errors.addAll(failedRepair.errors!.map((e) => e.message));
      }

      if (parseResult.errors != null) {
        errors.addAll(parseResult.errors!);
      }

      if (errors.isEmpty) {
        errors.add('Unable to parse input as any supported format');
      }

      state = state.copyWith(
        isProcessing: false,
        outputText: '',
        errors: errors,
        detectedFormat: InputFormat.unknown,
        formatConfidence: 0.0,
        errorLineNumber: failedRepair?.lineNumber,
        errorColumnNumber: failedRepair?.columnNumber,
        errorMessage: errors.first,
      );
    }
  }

  void _formatJsonOutput() {
    if (state.outputText.isEmpty) return;

    try {
      final jsonData = jsonDecode(state.outputText);
      final formatted = state.prettifyOutput
          ? const JsonEncoder.withIndent('  ').convert(jsonData)
          : jsonEncode(jsonData);

      state = state.copyWith(outputText: formatted);
    } catch (e) {
      // Keep existing output if formatting fails
    }
  }

  Future<void> copyToClipboard() async {
    if (state.hasOutput) {
      await Clipboard.setData(ClipboardData(text: state.outputText));
    }
  }

  Future<void> pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      updateInputText(clipboardData!.text!);
    }
  }

  void clearInput() {
    state = const JsonConverterState();
  }

  void setInputFromExample(String example) {
    updateInputText(example);
  }

  Map<String, dynamic> getConversionSummary() {
    return {
      'detectedFormat': state.formatDisplayName,
      'confidence': state.confidenceDisplayText,
      'wasRepaired': state.wasRepaired,
      'appliedRepairs': state.appliedRepairs.length,
      'hasWarnings': state.hasWarnings,
      'warningCount': state.warnings.length,
      'inputLength': state.inputText.length,
      'outputLength': state.outputText.length,
    };
  }
}
