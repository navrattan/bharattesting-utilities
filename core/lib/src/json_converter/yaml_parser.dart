/// YAML parser for converting YAML data to JSON format
///
/// Uses the official yaml package for robust parsing

import 'dart:convert';
import 'package:yaml/yaml.dart';

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

/// Robust YAML parser using the yaml package
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
      // Basic syntax check for very specific common issues not always caught by yaml package
      final syntaxErrors = validateSyntax(yamlContent);
      
      // Official YAML loader
      final doc = loadYaml(yamlContent);
      
      // Convert YamlMap/YamlList to normal Dart Map/List for JSON compatibility
      final cleanData = _convertYamlNode(doc);

      return YAMLParseResult(
        data: cleanData,
        success: true,
        errors: syntaxErrors.isEmpty ? null : syntaxErrors,
        metadata: {
          'documentCount': 1, // loadYaml only loads first doc, loadYamlStream for more
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

  /// Recursively convert YAML types to Dart types
  static dynamic _convertYamlNode(dynamic node) {
    if (node is YamlMap) {
      return Map<String, dynamic>.fromEntries(
        node.nodes.entries.map((e) => MapEntry(
          e.key.value.toString(), 
          _convertYamlNode(e.value)
        ))
      );
    } else if (node is YamlList) {
      return node.map(_convertYamlNode).toList();
    } else if (node is YamlScalar) {
      return node.value;
    }
    return node;
  }

  /// Validate YAML syntax (basic checks)
  static List<String> validateSyntax(String yamlContent) {
    final errors = <String>[];
    final lines = yamlContent.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      if (line.trim().isEmpty || line.trim().startsWith('#')) continue;

      if (line.contains('\t') && line.contains(' ')) {
        errors.add('Line $lineNumber: Mixed tabs and spaces in indentation');
      }

      final trimmed = line.trim();
      if (trimmed.startsWith('@') || trimmed.startsWith('`')) {
        errors.add('Line $lineNumber: Invalid character at start of line');
      }
    }

    return errors;
  }
}
