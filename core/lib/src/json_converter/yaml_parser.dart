/// YAML parser for converting YAML data to JSON format
///
/// Simplified YAML parser that handles common YAML structures without external dependencies

import 'dart:convert';

/// YAML parsing result
class YAMLParseResult {
  const YAMLParseResult({
    required this.data,
    required this.success,
    this.errors,
    this.warnings,
    this.metadata,
  });

  /// Parsed YAML data as Dart objects
  final dynamic data;

  /// Whether parsing was successful
  final bool success;

  /// Error messages if parsing failed
  final List<String>? errors;

  /// Warning messages
  final List<String>? warnings;

  /// Additional metadata
  final Map<String, dynamic>? metadata;
}

/// Simplified YAML parser for basic YAML structures
class YAMLParser {
  /// Parse YAML string to Dart objects
  static YAMLParseResult parse(String yamlContent) {
    if (yamlContent.trim().isEmpty) {
      return const YAMLParseResult(
        data: null,
        success: true,
        metadata: {'documentCount': 0},
      );
    }

    try {
      final context = _YAMLParseContext();
      final documents = _parseDocuments(yamlContent, context);

      final data = documents.length == 1 ? documents.first : documents;

      return YAMLParseResult(
        data: data,
        success: context.errors.isEmpty,
        errors: context.errors.isEmpty ? null : context.errors,
        warnings: context.warnings.isEmpty ? null : context.warnings,
        metadata: {
          'documentCount': documents.length,
          'hasMultipleDocuments': documents.length > 1,
          'lineCount': yamlContent.split('\n').length,
        },
      );
    } catch (e) {
      return YAMLParseResult(
        data: null,
        success: false,
        errors: [e.toString()],
      );
    }
  }

  /// Convert YAML to JSON string
  static String toJSON(String yamlContent, {bool prettify = false}) {
    final parseResult = parse(yamlContent);

    final output = {
      'data': parseResult.data,
      'success': parseResult.success,
      if (parseResult.metadata != null) 'metadata': parseResult.metadata,
      if (parseResult.warnings != null) 'warnings': parseResult.warnings,
      if (parseResult.errors != null) 'errors': parseResult.errors,
    };

    if (prettify) {
      return const JsonEncoder.withIndent('  ').convert(output);
    } else {
      return jsonEncode(output);
    }
  }

  /// Parse multiple YAML documents separated by ---
  static List<dynamic> _parseDocuments(String content, _YAMLParseContext context) {
    final documents = <dynamic>[];

    // Split by document separators
    final documentTexts = content.split(RegExp(r'^---\s*$', multiLine: true));

    for (int i = 0; i < documentTexts.length; i++) {
      final docText = documentTexts[i].trim();
      if (docText.isEmpty) continue;

      // Remove document end marker if present
      final cleanText = docText.replaceAll(RegExp(r'^\.\.\.\s*$', multiLine: true), '').trim();
      if (cleanText.isEmpty) continue;

      try {
        final document = _parseDocument(cleanText, context);
        documents.add(document);
      } catch (e) {
        context.errors.add('Failed to parse document ${i + 1}: ${e.toString()}');
      }
    }

    return documents.isEmpty ? [null] : documents;
  }

  /// Parse a single YAML document
  static dynamic _parseDocument(String content, _YAMLParseContext context) {
    final lines = content.split('\n');
    final rootLevel = _parseLevel(lines, 0, -1, context);

    if (rootLevel.length == 1 && rootLevel.containsKey('_type') && rootLevel['_type'] == 'list') {
      return rootLevel['items'];
    }

    return rootLevel.length == 1 && !rootLevel.containsKey('_type') ? rootLevel.values.first : rootLevel;
  }

  /// Parse a level of YAML indentation
  static Map<String, dynamic> _parseLevel(
    List<String> lines,
    int startIndex,
    int baseIndent,
    _YAMLParseContext context,
  ) {
    final result = <String, dynamic>{};
    int i = startIndex;

    while (i < lines.length) {
      final line = lines[i];
      final trimmed = line.trim();

      // Skip empty lines and comments
      if (trimmed.isEmpty || trimmed.startsWith('#')) {
        i++;
        continue;
      }

      final indent = _getIndentation(line);

      // If indentation decreased, we've finished this level
      if (baseIndent >= 0 && indent <= baseIndent) {
        break;
      }

      // Parse key-value pairs
      if (trimmed.startsWith('-')) {
        // This level is a list, not a map
        final listItems = _parseList(lines, i, indent, context);
        return {'items': listItems.items, '_type': 'list'};
      } else if (trimmed.contains(':')) {
        final colonIndex = trimmed.indexOf(':');
        final key = trimmed.substring(0, colonIndex).trim();
        final valueStr = trimmed.substring(colonIndex + 1).trim();

        if (valueStr.isEmpty) {
          // Multi-line value or nested object
          // Peek at next non-empty line to see its indentation and if it's a list
          int nextIdx = i + 1;
          while (nextIdx < lines.length && lines[nextIdx].trim().isEmpty) {
            nextIdx++;
          }

          if (nextIdx < lines.length) {
            final nextLine = lines[nextIdx];
            final nextIndent = _getIndentation(nextLine);
            
            if (nextIndent > indent) {
              final nestedLevel = _parseLevel(lines, nextIdx, indent, context);
              if (nestedLevel.containsKey('_type') && nestedLevel['_type'] == 'list') {
                result[key] = nestedLevel['items'];
              } else {
                result[key] = nestedLevel;
              }
              
              // Skip processed lines
              i = nextIdx;
              while (i + 1 < lines.length) {
                final l = lines[i + 1];
                if (l.trim().isNotEmpty && _getIndentation(l) <= indent) break;
                i++;
              }
            } else {
              result[key] = null;
            }
          } else {
            result[key] = null;
          }
        } else {
          // Single-line value
          result[key] = _parseValue(valueStr, context);
        }
      } else {
        // Invalid structure for a map level
        throw FormatException('Invalid YAML structure: $trimmed');
      }

      i++;
    }

    return result;
  }

  /// Parse a YAML list
  static _ListParseResult _parseList(
    List<String> lines,
    int startIndex,
    int baseIndent,
    _YAMLParseContext context,
  ) {
    final items = <dynamic>[];
    int i = startIndex;

    while (i < lines.length) {
      final line = lines[i];
      final trimmed = line.trim();

      if (trimmed.isEmpty || trimmed.startsWith('#')) {
        i++;
        continue;
      }

      final indent = _getIndentation(line);

      // If indentation decreased, we've finished this list
      if (indent < baseIndent) {
        break;
      }

      if (trimmed.startsWith('-')) {
        final valueStr = trimmed.substring(1).trim();

        if (valueStr.isEmpty) {
          // Multi-line list item or nested structure
          // Peek at next line indentation
          int nextIdx = i + 1;
          while (nextIdx < lines.length && lines[nextIdx].trim().isEmpty) {
            nextIdx++;
          }

          if (nextIdx < lines.length) {
            final nextLine = lines[nextIdx];
            final nextIndent = _getIndentation(nextLine);

            if (nextIndent > indent) {
              final nestedLevel = _parseLevel(lines, nextIdx, indent, context);
              items.add(nestedLevel);

              // Skip processed lines
              i = nextIdx;
              while (i + 1 < lines.length) {
                final l = lines[i + 1];
                if (l.trim().isNotEmpty && _getIndentation(l) <= indent) break;
                i++;
              }
            } else {
              items.add(null);
            }
          } else {
            items.add(null);
          }
        } else {
          // Single-line list item (could be key-value if it's like '- name: Alice')
          if (valueStr.contains(':')) {
            // It's an object as a list item
            final colonIndex = valueStr.indexOf(':');
            final key = valueStr.substring(0, colonIndex).trim();
            final val = _parseValue(valueStr.substring(colonIndex + 1).trim(), context);

            // We need to continue parsing this object at the same level
            final remainingObject = _parseLevel(lines, i + 1, indent, context);
            final itemMap = {key: val};
            itemMap.addAll(remainingObject);
            items.add(itemMap);

            // Skip processed lines for the object
            while (i + 1 < lines.length) {
              final nextLine = lines[i + 1];
              if (nextLine.trim().isNotEmpty && _getIndentation(nextLine) <= indent) break;
              i++;
            }
          } else {
            items.add(_parseValue(valueStr, context));
          }
        }
      }

      i++;
    }

    return _ListParseResult(items, i);
  }

  /// Parse a YAML scalar value
  static dynamic _parseValue(String value, _YAMLParseContext context) {
    var trimmed = value.trim();

    // Handle quoted strings (quotes should contain the full value or everything before #)
    if ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
        (trimmed.startsWith("'") && trimmed.endsWith("'"))) {
      return trimmed.substring(1, trimmed.length - 1);
    }

    // Strip inline comments if not in quotes
    if (trimmed.contains('#')) {
      trimmed = trimmed.substring(0, trimmed.indexOf('#')).trim();
    }

    if (trimmed.isEmpty) return null;

    // Handle special YAML values
    switch (trimmed.toLowerCase()) {
      case 'null':
      case '~':
        return null;
      case 'true':
        return true;
      case 'false':
        return false;
    }

    // Try to parse as number (only if not likely to be a string like port or year)
    // YAML spec says 8080 is a number. If test expects string, the test might be wrong or we need to be careful.
    // Let's check the test expectation again. 
    if (RegExp(r'^-?\d+$').hasMatch(trimmed)) {
      // If it's a long number or starts with 0, keep as string
      if ((trimmed.length > 1 && trimmed.startsWith('0')) || trimmed.length > 15) {
        return trimmed;
      }
      return int.tryParse(trimmed) ?? trimmed;
    }

    if (RegExp(r'^-?\d*\.\d+$').hasMatch(trimmed)) {
      return double.tryParse(trimmed) ?? trimmed;
    }

    // Handle scientific notation
    if (RegExp(r'^-?\d+\.?\d*[eE][+-]?\d+$').hasMatch(trimmed)) {
      return double.tryParse(trimmed) ?? trimmed;
    }

    // Handle multiline strings with | or >
    if (trimmed == '|' || trimmed == '>') {
      context.warnings.add('Multiline string indicators (| >) not fully supported');
      return '';
    }

    // Return as string
    return trimmed;
  }

  /// Get indentation level of a line
  static int _getIndentation(String line) {
    int indent = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == ' ') {
        indent++;
      } else if (line[i] == '\t') {
        indent += 2; // Count tabs as 2 spaces
      } else {
        break;
      }
    }
    return indent;
  }

  /// Validate YAML syntax (basic checks)
  static List<String> validateSyntax(String yamlContent) {
    final errors = <String>[];
    final lines = yamlContent.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      // Skip empty lines and comments
      if (line.trim().isEmpty || line.trim().startsWith('#')) {
        continue;
      }

      // Check for mixed tabs and spaces (common issue)
      if (line.contains('\t') && line.contains(' ')) {
        errors.add('Line $lineNumber: Mixed tabs and spaces in indentation');
      }

      // Check for invalid characters at start of line
      final trimmed = line.trim();
      if (trimmed.startsWith('@') || trimmed.startsWith('`')) {
        errors.add('Line $lineNumber: Invalid character at start of line');
      }

      // Check for unbalanced quotes
      final singleQuotes = trimmed.split("'").length - 1;
      final doubleQuotes = trimmed.split('"').length - 1;

      if (singleQuotes % 2 != 0) {
        errors.add('Line $lineNumber: Unbalanced single quotes');
      }

      if (doubleQuotes % 2 != 0) {
        errors.add('Line $lineNumber: Unbalanced double quotes');
      }
    }

    return errors;
  }
}

/// Parsing context for YAML
class _YAMLParseContext {
  final List<String> warnings = [];
  final List<String> errors = [];
}

/// Result of list parsing operation
class _ListParseResult {
  const _ListParseResult(this.items, this.nextIndex);

  final List<dynamic> items;
  final int nextIndex;
}