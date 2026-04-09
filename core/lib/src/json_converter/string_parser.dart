/// Intelligent string parser for auto-detecting input formats
///
/// Detects and parses: JSON, CSV, YAML, XML, URL-encoded, INI formats

import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:yaml/yaml.dart';
import 'yaml_parser.dart';

/// Supported input formats for auto-detection
enum InputFormat {
  json('JSON', 'JavaScript Object Notation'),
  csv('CSV', 'Comma-Separated Values'),
  yaml('YAML', 'YAML Ain\'t Markup Language'),
  xml('XML', 'eXtensible Markup Language'),
  urlEncoded('URL-Encoded', 'URL-encoded form data'),
  ini('INI', 'Configuration file format'),
  unknown('Unknown', 'Unrecognized format');

  const InputFormat(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Result of format detection and parsing
class ParseResult {
  const ParseResult({
    required this.detectedFormat,
    required this.data,
    required this.confidence,
    this.metadata,
    this.errors,
  });

  /// The detected input format
  final InputFormat detectedFormat;

  /// Parsed data as Dart objects
  final dynamic data;

  /// Confidence score (0.0 to 1.0)
  final double confidence;

  /// Additional metadata about the parsing
  final Map<String, dynamic>? metadata;

  /// Any errors encountered during parsing
  final List<String>? errors;

  /// Whether parsing was successful
  bool get isSuccess => errors == null || errors!.isEmpty;
}

/// Intelligent string parser with format auto-detection
class StringParser {
  /// Auto-detect format and parse input string
  static ParseResult parseAny(String input) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) {
      return const ParseResult(
        detectedFormat: InputFormat.unknown,
        data: null,
        confidence: 0.0,
        errors: ['Input is empty'],
      );
    }

    // Try each format in order of specificity
    final detectors = [
      _detectJSON,
      _detectXML,
      _detectYAML,
      _detectURLEncoded,
      _detectINI,
      _detectCSV,
    ];

    ParseResult? bestResult;
    double bestConfidence = 0.05; // Lowered to ensure we pick up low confidence matches

    for (final detector in detectors) {
      try {
        final result = detector(trimmed);
        if (result.confidence > bestConfidence) {
          bestResult = result;
          bestConfidence = result.confidence;
        }
      } catch (e) {
        // Continue
      }
    }

    if (bestResult == null) {
      return ParseResult(
        detectedFormat: InputFormat.unknown,
        data: trimmed,
        confidence: 0.0,
        errors: ['Unable to detect input format'],
      );
    }

    return bestResult;
  }

  /// Parse input as specific format
  static ParseResult parseAs(String input, InputFormat format) {
    switch (format) {
      case InputFormat.json:
        return _parseJSON(input);
      case InputFormat.csv:
        return _parseCSV(input);
      case InputFormat.yaml:
        return _parseYAML(input);
      case InputFormat.xml:
        return _parseXML(input);
      case InputFormat.urlEncoded:
        return _parseURLEncoded(input);
      case InputFormat.ini:
        return _parseINI(input);
      case InputFormat.unknown:
        return ParseResult(
          detectedFormat: InputFormat.unknown,
          data: input,
          confidence: 0.0,
          errors: ['Unknown format specified'],
        );
    }
  }

  /// Detect and parse JSON format
  static ParseResult _detectJSON(String input) {
    final trimmed = input.trim();
    
    // Check if it looks like JSON even if it might be malformed
    final startsWithBracket = trimmed.startsWith('{') || trimmed.startsWith('[');
    
    try {
      final data = jsonDecode(trimmed);
      return ParseResult(
        detectedFormat: InputFormat.json,
        data: data,
        confidence: 1.0,
      );
    } catch (e) {
      if (startsWithBracket) {
        return ParseResult(
          detectedFormat: InputFormat.json,
          data: null,
          confidence: 0.3,
          errors: ['Malformed JSON: ${e.toString()}'],
        );
      }
      return const ParseResult(
        detectedFormat: InputFormat.json,
        data: null,
        confidence: 0.0,
      );
    }
  }

  /// Parse JSON format
  static ParseResult _parseJSON(String input) {
    try {
      final data = jsonDecode(input.trim());
      return ParseResult(
        detectedFormat: InputFormat.json,
        data: data,
        confidence: 1.0,
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.json,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Detect and parse XML format
  static ParseResult _detectXML(String input) {
    final trimmed = input.trim();
    if (!trimmed.startsWith('<')) {
      return const ParseResult(detectedFormat: InputFormat.xml, data: null, confidence: 0.0);
    }

    final hasXmlDeclaration = trimmed.startsWith('<?xml');
    final hasRootElement = RegExp(r'<[a-zA-Z][^>]*>').hasMatch(trimmed);

    if (!hasXmlDeclaration && !hasRootElement) {
      return const ParseResult(detectedFormat: InputFormat.xml, data: null, confidence: 0.0);
    }

    try {
      final data = _parseXMLContent(trimmed);
      return ParseResult(
        detectedFormat: InputFormat.xml,
        data: data,
        confidence: hasXmlDeclaration ? 1.0 : 0.8,
      );
    } catch (e) {
      return const ParseResult(detectedFormat: InputFormat.xml, data: null, confidence: 0.0);
    }
  }

  /// Parse XML format
  static ParseResult _parseXML(String input) {
    try {
      final data = _parseXMLContent(input);
      return ParseResult(
        detectedFormat: InputFormat.xml,
        data: data,
        confidence: 1.0,
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.xml,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Detect and parse YAML format
  static ParseResult _detectYAML(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty || trimmed.length < 3 || trimmed.startsWith('{') || trimmed.startsWith('[')) {
      return const ParseResult(detectedFormat: InputFormat.yaml, data: null, confidence: 0.0);
    }

    final lines = trimmed.split('\n');
    int indicators = 0;
    for (final line in lines) {
      final l = line.trim();
      if (l.isEmpty || l.startsWith('#')) continue;
      if (l == '---' || l == '...' || RegExp(r'^[^: \t]+:\s*').hasMatch(l) || RegExp(r'^-\s+').hasMatch(l)) {
        indicators++;
      }
    }

    double confidence = (indicators / (lines.length + 1)).clamp(0.0, 1.0);
    if (confidence < 0.4) return const ParseResult(detectedFormat: InputFormat.yaml, data: null, confidence: 0.0);

    try {
      final data = _parseYAMLContent(input);
      return ParseResult(detectedFormat: InputFormat.yaml, data: data, confidence: confidence);
    } catch (e) {
      return const ParseResult(detectedFormat: InputFormat.yaml, data: null, confidence: 0.0);
    }
  }

  /// Parse YAML format
  static ParseResult _parseYAML(String input) {
    final result = YAMLParser.parse(input);
    return ParseResult(
      detectedFormat: InputFormat.yaml,
      data: result.data,
      confidence: 1.0,
      errors: result.errors,
    );
  }

  /// Detect and parse URL-encoded format
  static ParseResult _detectURLEncoded(String input) {
    final trimmed = input.trim();
    if (!trimmed.contains('=')) return const ParseResult(detectedFormat: InputFormat.urlEncoded, data: null, confidence: 0.0);

    final hasAmpersands = trimmed.contains('&');
    final hasEncodedChars = RegExp(r'%[0-9A-Fa-f]{2}').hasMatch(trimmed);
    double confidence = 0.3 + (hasAmpersands ? 0.3 : 0) + (hasEncodedChars ? 0.4 : 0);

    try {
      final data = _parseURLEncodedContent(trimmed);
      return ParseResult(detectedFormat: InputFormat.urlEncoded, data: data, confidence: confidence.clamp(0.0, 1.0));
    } catch (e) {
      return const ParseResult(detectedFormat: InputFormat.urlEncoded, data: null, confidence: 0.0);
    }
  }

  /// Parse URL-encoded format
  static ParseResult _parseURLEncoded(String input) {
    try {
      final data = _parseURLEncodedContent(input);
      return ParseResult(detectedFormat: InputFormat.urlEncoded, data: data, confidence: 1.0);
    } catch (e) {
      return ParseResult(detectedFormat: InputFormat.urlEncoded, data: null, confidence: 0.0, errors: [e.toString()]);
    }
  }

  /// Detect and parse INI format
  static ParseResult _detectINI(String input) {
    final lines = input.split('\n');
    int indicators = 0;
    int nonBlank = 0;
    for (final line in lines) {
      final l = line.trim();
      if (l.isEmpty) continue;
      nonBlank++;
      if (RegExp(r'^\[[^\]]+\]$').hasMatch(l) || l.startsWith('#') || l.startsWith(';') || RegExp(r'^[^=]+=[^=]*$').hasMatch(l)) {
        indicators++;
      }
    }

    if (nonBlank == 0) return const ParseResult(detectedFormat: InputFormat.ini, data: null, confidence: 0.0);
    double confidence = (indicators / nonBlank).clamp(0.0, 1.0);
    if (confidence < 0.6) return const ParseResult(detectedFormat: InputFormat.ini, data: null, confidence: 0.0);

    try {
      final data = _parseINIContent(input);
      return ParseResult(detectedFormat: InputFormat.ini, data: data, confidence: confidence);
    } catch (e) {
      return const ParseResult(detectedFormat: InputFormat.ini, data: null, confidence: 0.0);
    }
  }

  /// Parse INI format
  static ParseResult _parseINI(String input) {
    try {
      final data = _parseINIContent(input);
      return ParseResult(detectedFormat: InputFormat.ini, data: data, confidence: 1.0);
    } catch (e) {
      return ParseResult(detectedFormat: InputFormat.ini, data: null, confidence: 0.0, errors: [e.toString()]);
    }
  }

  /// Detect and parse CSV format
  static ParseResult _detectCSV(String input) {
    final trimmed = input.trim();
    if (trimmed.length < 5 || !trimmed.contains(',')) return const ParseResult(detectedFormat: InputFormat.csv, data: null, confidence: 0.0);

    final lines = trimmed.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.length < 2) return const ParseResult(detectedFormat: InputFormat.csv, data: null, confidence: 0.0);

    final counts = lines.take(5).map((l) => ','.allMatches(l).length).toList();
    if (counts.first == 0 || !counts.every((c) => c == counts.first)) return const ParseResult(detectedFormat: InputFormat.csv, data: null, confidence: 0.0);

    try {
      final data = _parseCSVContent(input);
      return ParseResult(detectedFormat: InputFormat.csv, data: data, confidence: 0.5);
    } catch (e) {
      return const ParseResult(detectedFormat: InputFormat.csv, data: null, confidence: 0.0);
    }
  }

  /// Parse CSV format
  static ParseResult _parseCSV(String input) {
    try {
      final data = _parseCSVContent(input);
      return ParseResult(detectedFormat: InputFormat.csv, data: data, confidence: 1.0);
    } catch (e) {
      return ParseResult(detectedFormat: InputFormat.csv, data: null, confidence: 0.0, errors: [e.toString()]);
    }
  }

  static Map<String, dynamic> _parseXMLContent(String xml) {
    final rootMatch = RegExp(r'<([a-zA-Z][^>\s]*)[^>]*>').firstMatch(xml);
    return {'rootElement': rootMatch?.group(1), '_note': 'Simplified XML parsing'};
  }

  static dynamic _parseYAMLContent(String yaml) {
    final doc = loadYaml(yaml);
    return _convertYamlNode(doc);
  }

  static dynamic _convertYamlNode(dynamic node) {
    if (node is YamlMap) {
      return Map<String, dynamic>.fromEntries(node.nodes.entries.map((e) => MapEntry(e.key.value.toString(), _convertYamlNode(e.value))));
    } else if (node is YamlList) {
      return node.map(_convertYamlNode).toList();
    } else if (node is YamlScalar) {
      return node.value;
    }
    return node;
  }

  static Map<String, dynamic> _parseURLEncodedContent(String content) {
    final result = <String, dynamic>{};
    for (final pair in content.split('&')) {
      final parts = pair.split('=');
      if (parts.length >= 2) result[Uri.decodeComponent(parts[0])] = Uri.decodeComponent(parts.sublist(1).join('='));
      else if (parts.isNotEmpty && parts[0].isNotEmpty) result[Uri.decodeComponent(parts[0])] = null;
    }
    return result;
  }

  static Map<String, Map<String, String>> _parseINIContent(String content) {
    final result = <String, Map<String, String>>{};
    String section = 'default';
    for (final line in content.split('\n')) {
      final l = line.trim();
      if (l.isEmpty || l.startsWith('#') || l.startsWith(';')) continue;
      if (l.startsWith('[') && l.endsWith(']')) {
        section = l.substring(1, l.length - 1);
        result[section] = <String, String>{};
      } else if (l.contains('=')) {
        final parts = l.split('=');
        result.putIfAbsent(section, () => <String, String>{})[parts[0].trim()] = _stripInlineComment(parts.sublist(1).join('='));
      }
    }
    return result;
  }

  static List<Map<String, dynamic>> _parseCSVContent(String content) {
    final lines = content.split(RegExp(r'\r?\n')).where((l) => l.trim().isNotEmpty).toList();
    if (lines.length < 2) return [];
    final headers = const CsvToListConverter().convert('${lines[0]}\n')[0].map((h) => h.toString().trim()).toList();
    final result = <Map<String, dynamic>>[];
    for (int i = 1; i < lines.length; i++) {
      final values = const CsvToListConverter(shouldParseNumbers: true).convert('${lines[i]}\n')[0];
      final row = <String, dynamic>{};
      for (int j = 0; j < headers.length; j++) {
        final val = j < values.length ? values[j] : null;
        row[headers[j]] = val is String ? val.trim() : val;
      }
      result.add(row);
    }
    return result;
  }

  static String _stripInlineComment(String val) {
    final commentIdx = val.indexOf(RegExp(r'\s?[#;]'));
    return (commentIdx != -1 ? val.substring(0, commentIdx) : val).trim();
  }
}
