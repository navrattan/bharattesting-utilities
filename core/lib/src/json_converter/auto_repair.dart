/// Auto-repair functionality for malformed JSON and data
///
/// Implements 6 intelligent repair rules to fix common JSON formatting issues

import 'dart:convert';

/// Result of auto-repair operation
class RepairResult {
  const RepairResult({
    required this.repaired,
    required this.appliedRules,
    required this.errors,
    this.lineNumber,
    this.columnNumber,
  });

  /// Successfully repaired JSON string
  final String repaired;

  /// List of repair rules that were applied
  final List<RepairRule> appliedRules;

  /// List of errors encountered (if any)
  final List<RepairError> errors;

  /// Line number where error occurred (if applicable)
  final int? lineNumber;

  /// Column number where error occurred (if applicable)
  final int? columnNumber;

  /// Whether repair was successful
  bool get isSuccess => errors.isEmpty;

  /// Whether any repairs were applied
  bool get wasRepaired => appliedRules.isNotEmpty;
}

/// Types of repair rules available
enum RepairRule {
  trailingCommas('Remove trailing commas'),
  singleQuotes('Convert single quotes to double quotes'),
  unquotedKeys('Add quotes around unquoted object keys'),
  jsComments('Remove JavaScript-style comments'),
  pythonLiterals('Convert Python literals (True/False/None)'),
  trailingText('Remove trailing text after valid JSON');

  const RepairRule(this.description);
  final String description;
}

/// Error encountered during repair
class RepairError {
  const RepairError({
    required this.message,
    required this.position,
    this.suggestion,
  });

  final String message;
  final int position;
  final String? suggestion;
}

/// Auto-repair engine for JSON and data formats
class AutoRepair {
  /// Attempt to auto-repair malformed JSON string
  static RepairResult repairJSON(String input, {
    Set<RepairRule>? enabledRules,
  }) {
    final rules = enabledRules ?? RepairRule.values.toSet();
    final appliedRules = <RepairRule>[];
    final errors = <RepairError>[];

    String current = input.trim();

    try {
      // Test if input is already valid JSON
      jsonDecode(current);
      return RepairResult(
        repaired: current,
        appliedRules: appliedRules,
        errors: errors,
      );
    } catch (e) {
      // Input needs repair, proceed with rules
    }

    // Apply repair rules in order of complexity

    // Rule 1: Remove JavaScript-style comments
    if (rules.contains(RepairRule.jsComments)) {
      final commentResult = _removeComments(current);
      if (commentResult.wasModified) {
        current = commentResult.result;
        appliedRules.add(RepairRule.jsComments);
      }
    }

    // Rule 2: Convert Python literals
    if (rules.contains(RepairRule.pythonLiterals)) {
      final pythonResult = _convertPythonLiterals(current);
      if (pythonResult.wasModified) {
        current = pythonResult.result;
        appliedRules.add(RepairRule.pythonLiterals);
      }
    }

    // Rule 3: Convert single quotes to double quotes
    if (rules.contains(RepairRule.singleQuotes)) {
      final quoteResult = _convertSingleQuotes(current);
      if (quoteResult.wasModified) {
        current = quoteResult.result;
        appliedRules.add(RepairRule.singleQuotes);
      }
    }

    // Rule 4: Add quotes around unquoted keys
    if (rules.contains(RepairRule.unquotedKeys)) {
      final keyResult = _quoteUnquotedKeys(current);
      if (keyResult.wasModified) {
        current = keyResult.result;
        appliedRules.add(RepairRule.unquotedKeys);
      }
    }

    // Rule 5: Remove trailing commas
    if (rules.contains(RepairRule.trailingCommas)) {
      final commaResult = _removeTrailingCommas(current);
      if (commaResult.wasModified) {
        current = commaResult.result;
        appliedRules.add(RepairRule.trailingCommas);
      }
    }

    // Rule 6: Remove trailing text after valid JSON
    if (rules.contains(RepairRule.trailingText)) {
      final trailingResult = _removeTrailingText(current);
      if (trailingResult.wasModified) {
        current = trailingResult.result;
        appliedRules.add(RepairRule.trailingText);
      }
    }

    // Final validation
    try {
      jsonDecode(current);
      return RepairResult(
        repaired: current,
        appliedRules: appliedRules,
        errors: errors,
      );
    } catch (e) {
      final position = _extractErrorPosition(e.toString(), current);
      errors.add(RepairError(
        message: _userFriendlyError(e.toString()),
        position: position.offset,
        suggestion: _suggestFix(e.toString()),
      ));

      return RepairResult(
        repaired: current,
        appliedRules: appliedRules,
        errors: errors,
        lineNumber: position.line,
        columnNumber: position.column,
      );
    }
  }

  /// Remove JavaScript-style comments (// and /* */)
  static RepairOperationResult _removeComments(String input) {
    String result = input;
    bool wasModified = false;

    // Remove single-line comments (//)
    final singleLinePattern = RegExp(r'//.*$', multiLine: true);
    if (singleLinePattern.hasMatch(result)) {
      result = result.replaceAll(singleLinePattern, '');
      wasModified = true;
    }

    // Remove multi-line comments (/* */)
    final multiLinePattern = RegExp(r'/\*[\s\S]*?\*/', multiLine: true);
    if (multiLinePattern.hasMatch(result)) {
      result = result.replaceAll(multiLinePattern, '');
      wasModified = true;
    }

    return RepairOperationResult(result.trim(), wasModified);
  }

  /// Convert Python literals (True/False/None) to JSON equivalents
  static RepairOperationResult _convertPythonLiterals(String input) {
    String result = input;
    bool wasModified = false;

    final replacements = {
      RegExp(r'\bTrue\b'): 'true',
      RegExp(r'\bFalse\b'): 'false',
      RegExp(r'\bNone\b'): 'null',
    };

    for (final entry in replacements.entries) {
      if (entry.key.hasMatch(result)) {
        result = result.replaceAll(entry.key, entry.value);
        wasModified = true;
      }
    }

    return RepairOperationResult(result, wasModified);
  }

  /// Convert single quotes to double quotes (carefully avoiding strings)
  static RepairOperationResult _convertSingleQuotes(String input) {
    String result = input;
    bool wasModified = false;

    final buffer = StringBuffer();
    bool inDoubleQuote = false;
    bool inSingleQuote = false;
    bool escaped = false;

    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final nextChar = i + 1 < input.length ? input[i + 1] : null;

      if (escaped) {
        buffer.write(char);
        escaped = false;
        continue;
      }

      if (char == '\\') {
        buffer.write(char);
        escaped = true;
        continue;
      }

      if (char == '"' && !inSingleQuote) {
        inDoubleQuote = !inDoubleQuote;
        buffer.write(char);
      } else if (char == "'" && !inDoubleQuote) {
        if (!inSingleQuote) {
          // Start of single-quoted string - convert to double quote
          buffer.write('"');
          inSingleQuote = true;
          wasModified = true;
        } else {
          // End of single-quoted string - convert to double quote
          buffer.write('"');
          inSingleQuote = false;
        }
      } else {
        buffer.write(char);
      }
    }

    return RepairOperationResult(buffer.toString(), wasModified);
  }

  /// Add quotes around unquoted object keys
  static RepairOperationResult _quoteUnquotedKeys(String input) {
    String result = input;
    bool wasModified = false;

    // Pattern to match unquoted keys in objects
    // Matches: key: value (where key is not quoted)
    final unquotedKeyPattern = RegExp(
      r'(\{|\,)\s*([a-zA-Z_$][a-zA-Z0-9_$]*)\s*:',
      multiLine: true,
    );

    final matches = unquotedKeyPattern.allMatches(result).toList().reversed;
    for (final match in matches) {
      final prefix = match.group(1)!;
      final key = match.group(2)!;
      final replacement = '$prefix"$key":';

      result = result.replaceRange(
        match.start,
        match.end,
        replacement,
      );
      wasModified = true;
    }

    return RepairOperationResult(result, wasModified);
  }

  /// Remove trailing commas from arrays and objects
  static RepairOperationResult _removeTrailingCommas(String input) {
    String result = input;
    bool wasModified = false;

    // Remove trailing commas in arrays: [1, 2, 3,] -> [1, 2, 3]
    final arrayPattern = RegExp(r',\s*\]', multiLine: true);
    if (arrayPattern.hasMatch(result)) {
      result = result.replaceAll(arrayPattern, ']');
      wasModified = true;
    }

    // Remove trailing commas in objects: {a: 1, b: 2,} -> {a: 1, b: 2}
    final objectPattern = RegExp(r',\s*\}', multiLine: true);
    if (objectPattern.hasMatch(result)) {
      result = result.replaceAll(objectPattern, '}');
      wasModified = true;
    }

    return RepairOperationResult(result, wasModified);
  }

  /// Remove trailing text after valid JSON
  static RepairOperationResult _removeTrailingText(String input) {
    // Try to find the end of valid JSON by parsing incrementally
    for (int i = input.length; i > 0; i--) {
      final candidate = input.substring(0, i).trim();
      try {
        jsonDecode(candidate);
        // Found valid JSON ending at position i
        if (i < input.length) {
          return RepairOperationResult(candidate, true);
        }
        break;
      } catch (e) {
        // Continue searching
      }
    }

    return RepairOperationResult(input, false);
  }

  /// Extract error position from JSON decode error message
  static ErrorPosition _extractErrorPosition(String error, String input) {
    // Try to extract position from common error patterns
    final lineColPattern = RegExp(r'line (\d+), column (\d+)');
    final positionPattern = RegExp(r'position (\d+)');
    final characterPattern = RegExp(r'character (\d+)');

    final lineColMatch = lineColPattern.firstMatch(error);
    if (lineColMatch != null) {
      final line = int.parse(lineColMatch.group(1)!);
      final col = int.parse(lineColMatch.group(2)!);
      final offset = _lineColToOffset(input, line, col);
      return ErrorPosition(line: line, column: col, offset: offset);
    }

    final posMatch = positionPattern.firstMatch(error) ??
                    characterPattern.firstMatch(error);
    if (posMatch != null) {
      final offset = int.parse(posMatch.group(1)!);
      final lineCol = _offsetToLineCol(input, offset);
      return ErrorPosition(
        line: lineCol.line,
        column: lineCol.column,
        offset: offset,
      );
    }

    return const ErrorPosition(line: 1, column: 1, offset: 0);
  }

  /// Convert line/column to character offset
  static int _lineColToOffset(String input, int line, int col) {
    final lines = input.split('\n');
    int offset = 0;

    for (int i = 0; i < line - 1 && i < lines.length; i++) {
      offset += lines[i].length + 1; // +1 for newline
    }

    offset += col - 1;
    return offset.clamp(0, input.length);
  }

  /// Convert character offset to line/column
  static ErrorPosition _offsetToLineCol(String input, int offset) {
    if (offset <= 0) return const ErrorPosition(line: 1, column: 1, offset: 0);
    if (offset >= input.length) {
      final lines = input.split('\n');
      return ErrorPosition(
        line: lines.length,
        column: lines.last.length + 1,
        offset: input.length,
      );
    }

    final beforeOffset = input.substring(0, offset);
    final lines = beforeOffset.split('\n');

    return ErrorPosition(
      line: lines.length,
      column: lines.last.length + 1,
      offset: offset,
    );
  }

  /// Convert technical error to user-friendly message
  static String _userFriendlyError(String error) {
    if (error.contains('Unexpected character')) {
      return 'Invalid character found - check for unescaped quotes or special characters';
    }
    if (error.contains('Expected')) {
      return 'Missing or malformed JSON structure - check brackets, braces, and commas';
    }
    if (error.contains('Unterminated')) {
      return 'Unterminated string - check for missing closing quotes';
    }
    if (error.contains('trailing comma')) {
      return 'Trailing comma found - remove extra comma before closing bracket';
    }

    return 'JSON format error - please check syntax';
  }

  /// Suggest fix for common errors
  static String? _suggestFix(String error) {
    if (error.contains('trailing comma')) {
      return 'Remove the extra comma before the closing bracket or brace';
    }
    if (error.contains('single quote')) {
      return 'Replace single quotes with double quotes for strings';
    }
    if (error.contains('unquoted')) {
      return 'Add double quotes around object keys';
    }

    return null;
  }
}

/// Result of a single repair operation
class RepairOperationResult {
  const RepairOperationResult(this.result, this.wasModified);

  final String result;
  final bool wasModified;
}

/// Position information for errors
class ErrorPosition {
  const ErrorPosition({
    required this.line,
    required this.column,
    required this.offset,
  });

  final int line;
  final int column;
  final int offset;
}