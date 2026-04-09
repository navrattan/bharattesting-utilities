import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharattesting_core/core.dart' as core;
import '../models/json_converter_state.dart' hide InputFormat, RepairRule;

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

  /// Update input text with debouncing
  void updateInput(String input) {
    state = state.copyWith(inputText: input);

    _debounceTimer?.cancel();
    if (input.trim().isNotEmpty) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        processInput();
      });
    } else {
      state = state.copyWith(
        outputText: '',
        detectedFormat: core.InputFormat.unknown,
        formatConfidence: 0.0,
        appliedRepairs: <core.RepairRule>[],
        metadata: null,
      );
    }
  }

  /// Alias for updateInput used by some UI components
  void updateInputText(String input) => updateInput(input);

  /// Set input from example
  void setInputFromExample(String example) {
    state = state.copyWith(inputText: example);
    processInput();
  }

  /// Toggle auto-repair functionality
  void toggleAutoRepair() {
    state = state.copyWith(autoRepairEnabled: !state.autoRepairEnabled);
    if (state.hasInput) {
      processInput();
    }
  }

  /// Toggle pretty-print output
  void togglePrettify() {
    state = state.copyWith(prettifyOutput: !state.prettifyOutput);
    if (state.hasOutput && state.detectedFormat == core.InputFormat.json) {
      _formatJsonOutput();
    }
  }

  /// Process the current input text
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
      final repairResult = core.AutoRepair.repairJSON(input);

      if (repairResult.isSuccess) {
        // Successfully repaired
        final jsonData = jsonDecode(repairResult.repaired);
        final formattedJson = state.prettifyOutput
            ? const JsonEncoder.withIndent('  ').convert(jsonData)
            : jsonEncode(jsonData);

        state = state.copyWith(
          isProcessing: false,
          outputText: formattedJson,
          detectedFormat: core.InputFormat.json,
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
        detectedFormat: core.InputFormat.json,
        formatConfidence: 1.0,
        appliedRepairs: <core.RepairRule>[],
        warnings: const <String>[],
      );
    } catch (e) {
      // Direct JSON failed, try other formats
      await _processMultiFormat(input, null);
    }
  }

  Future<void> _processMultiFormat(String input, core.RepairResult? repairResult) async {
    try {
      // Use core multi-format parser
      final parseResult = core.StringParser.parseAny(input);

      if (parseResult.isSuccess) {
        final formattedJson = state.prettifyOutput
            ? const JsonEncoder.withIndent('  ').convert(parseResult.data)
            : jsonEncode(parseResult.data);

        state = state.copyWith(
          isProcessing: false,
          outputText: formattedJson,
          detectedFormat: parseResult.detectedFormat,
          formatConfidence: parseResult.confidence,
          appliedRepairs: repairResult?.appliedRules ?? <core.RepairRule>[],
          warnings: <String>[], // Add warnings if ParseResult has them
          metadata: parseResult.metadata,
        );
      } else {
        // All parsing attempts failed
        state = state.copyWith(
          isProcessing: false,
          outputText: '',
          detectedFormat: core.InputFormat.unknown,
          formatConfidence: 0.0,
          errors: parseResult.errors ?? ['Could not parse input as JSON, CSV, or YAML'],
          errorMessage: parseResult.errors?.first,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errors: ['Detection failed: ${e.toString()}'],
        outputText: '',
      );
    }
  }

  void _formatJsonOutput() {
    try {
      final jsonData = jsonDecode(state.outputText);
      final formattedJson = state.prettifyOutput
          ? const JsonEncoder.withIndent('  ').convert(jsonData)
          : jsonEncode(jsonData);

      state = state.copyWith(outputText: formattedJson);
    } catch (_) {
      // Keep original output if re-formatting fails
    }
  }

  /// Copy output to clipboard
  Future<void> copyToClipboard() async {
    if (state.outputText.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: state.outputText));
  }

  /// Paste from clipboard
  Future<void> pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      updateInput(data!.text!);
    }
  }

  /// Clear input
  void clearInput() {
    state = state.copyWith(
      inputText: '',
      outputText: '',
      detectedFormat: core.InputFormat.unknown,
      formatConfidence: 0.0,
      appliedRepairs: [],
      errors: [],
      warnings: [],
      metadata: null,
    );
  }

  /// Clear all input and output
  void clearAll() {
    state = const JsonConverterState();
  }
}
