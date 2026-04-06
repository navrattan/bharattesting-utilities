/// Intelligent string parser for auto-detecting input formats
///
/// Detects and parses: JSON, CSV, YAML, XML, URL-encoded, INI formats

import 'dart:convert';

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
      _detectCSV, // CSV last as it's most permissive
    ];

    ParseResult? bestResult;
    double bestConfidence = 0.0;

    for (final detector in detectors) {
      try {
        final result = detector(trimmed);
        if (result.confidence > bestConfidence) {
          bestResult = result;
          bestConfidence = result.confidence;

          // If we have high confidence, stop searching
          if (bestConfidence >= 0.9) {
            break;
          }
        }
      } catch (e) {
        // Continue to next detector
      }
    }

    return bestResult ?? ParseResult(
      detectedFormat: InputFormat.unknown,
      data: trimmed,
      confidence: 0.0,
      errors: ['Unable to detect input format'],
    );
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
    try {
      // Quick structural checks
      final trimmed = input.trim();
      if (!((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
            (trimmed.startsWith('[') && trimmed.endsWith(']')))) {
        return ParseResult(
          detectedFormat: InputFormat.json,
          data: null,
          confidence: 0.0,
        );
      }

      final data = jsonDecode(trimmed);
      return ParseResult(
        detectedFormat: InputFormat.json,
        data: data,
        confidence: 1.0,
        metadata: {
          'type': data is Map ? 'object' : data is List ? 'array' : 'primitive',
          'size': data is Map ? data.length : data is List ? data.length : 1,
        },
      );
    } catch (e) {
      // Might be malformed JSON - return low confidence
      final trimmed = input.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        return ParseResult(
          detectedFormat: InputFormat.json,
          data: null,
          confidence: 0.3,
          errors: ['Malformed JSON: ${e.toString()}'],
        );
      }

      return ParseResult(
        detectedFormat: InputFormat.json,
        data: null,
        confidence: 0.0,
      );
    }
  }

  /// Parse JSON format (called after detection)
  static ParseResult _parseJSON(String input) {
    try {
      final data = jsonDecode(input.trim());
      return ParseResult(
        detectedFormat: InputFormat.json,
        data: data,
        confidence: 1.0,
        metadata: {
          'type': data is Map ? 'object' : data is List ? 'array' : 'primitive',
        },
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

    // Basic XML structure detection
    if (!trimmed.startsWith('<') || !trimmed.endsWith('>')) {
      return ParseResult(
        detectedFormat: InputFormat.xml,
        data: null,
        confidence: 0.0,
      );
    }

    // Check for XML declaration or root element
    final hasXmlDeclaration = trimmed.startsWith('<?xml');
    final hasRootElement = RegExp(r'<[a-zA-Z][^>]*>').hasMatch(trimmed);

    if (!hasXmlDeclaration && !hasRootElement) {
      return ParseResult(
        detectedFormat: InputFormat.xml,
        data: null,
        confidence: 0.2,
      );
    }

    try {
      final data = _parseXMLContent(trimmed);
      return ParseResult(
        detectedFormat: InputFormat.xml,
        data: data,
        confidence: hasXmlDeclaration ? 1.0 : 0.8,
        metadata: {
          'hasDeclaration': hasXmlDeclaration,
          'rootElement': _extractRootElement(trimmed),
        },
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

  /// Parse XML format (simplified parser)
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
    final lines = input.split('\n');
    int yamlIndicators = 0;
    int totalLines = lines.where((line) => line.trim().isNotEmpty).length;

    if (totalLines == 0) {
      return ParseResult(
        detectedFormat: InputFormat.yaml,
        data: null,
        confidence: 0.0,
      );
    }

    // Look for YAML indicators
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      // YAML document separator
      if (trimmed == '---' || trimmed == '...') {
        yamlIndicators += 2;
        continue;
      }

      // Key-value pairs with colon
      if (RegExp(r'^[^:]+:\s*').hasMatch(trimmed)) {
        yamlIndicators++;
      }

      // List items
      if (RegExp(r'^-\s+').hasMatch(trimmed)) {
        yamlIndicators++;
      }

      // Indented structure
      if (RegExp(r'^\s{2,}').hasMatch(line)) {
        yamlIndicators++;
      }
    }

    final confidence = (yamlIndicators / totalLines).clamp(0.0, 1.0);

    if (confidence < 0.3) {
      return ParseResult(
        detectedFormat: InputFormat.yaml,
        data: null,
        confidence: confidence,
      );
    }

    try {
      final data = _parseYAMLContent(input);
      return ParseResult(
        detectedFormat: InputFormat.yaml,
        data: data,
        confidence: confidence,
        metadata: {
          'lineCount': totalLines,
          'yamlIndicators': yamlIndicators,
        },
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.yaml,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Parse YAML format (simplified parser)
  static ParseResult _parseYAML(String input) {
    try {
      final data = _parseYAMLContent(input);
      return ParseResult(
        detectedFormat: InputFormat.yaml,
        data: data,
        confidence: 1.0,
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.yaml,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Detect and parse URL-encoded format
  static ParseResult _detectURLEncoded(String input) {
    final trimmed = input.trim();

    // Check for URL-encoded patterns
    final hasAmpersands = trimmed.contains('&');
    final hasEquals = trimmed.contains('=');
    final hasEncodedChars = RegExp(r'%[0-9A-Fa-f]{2}').hasMatch(trimmed);
    final noSpaces = !trimmed.contains(' ') || hasEncodedChars;

    if (!hasEquals) {
      return ParseResult(
        detectedFormat: InputFormat.urlEncoded,
        data: null,
        confidence: 0.0,
      );
    }

    double confidence = 0.3; // Base confidence for having equals sign

    if (hasAmpersands) confidence += 0.3;
    if (hasEncodedChars) confidence += 0.2;
    if (noSpaces) confidence += 0.2;

    try {
      final data = _parseURLEncodedContent(trimmed);
      return ParseResult(
        detectedFormat: InputFormat.urlEncoded,
        data: data,
        confidence: confidence,
        metadata: {
          'parameterCount': data.length,
        },
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.urlEncoded,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Parse URL-encoded format
  static ParseResult _parseURLEncoded(String input) {
    try {
      final data = _parseURLEncodedContent(input);
      return ParseResult(
        detectedFormat: InputFormat.urlEncoded,
        data: data,
        confidence: 1.0,
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.urlEncoded,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Detect and parse INI format
  static ParseResult _detectINI(String input) {
    final lines = input.split('\n');
    int iniIndicators = 0;
    int totalLines = lines.where((line) => line.trim().isNotEmpty).length;

    if (totalLines == 0) {
      return ParseResult(
        detectedFormat: InputFormat.ini,
        data: null,
        confidence: 0.0,
      );
    }

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      // Section headers [section]
      if (RegExp(r'^\[[^\]]+\]$').hasMatch(trimmed)) {
        iniIndicators += 2;
        continue;
      }

      // Comments
      if (trimmed.startsWith('#') || trimmed.startsWith(';')) {
        iniIndicators++;
        continue;
      }

      // Key-value pairs
      if (RegExp(r'^[^=]+=[^=]*$').hasMatch(trimmed)) {
        iniIndicators++;
      }
    }

    final confidence = totalLines > 0 ? (iniIndicators / totalLines).clamp(0.0, 1.0) : 0.0;

    if (confidence < 0.4) {
      return ParseResult(
        detectedFormat: InputFormat.ini,
        data: null,
        confidence: confidence,
      );
    }

    try {
      final data = _parseINIContent(input);
      return ParseResult(
        detectedFormat: InputFormat.ini,
        data: data,
        confidence: confidence,
        metadata: {
          'sectionCount': data.keys.length,
        },
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.ini,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Parse INI format
  static ParseResult _parseINI(String input) {
    try {
      final data = _parseINIContent(input);
      return ParseResult(
        detectedFormat: InputFormat.ini,
        data: data,
        confidence: 1.0,
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.ini,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Detect and parse CSV format
  static ParseResult _detectCSV(String input) {
    final lines = input.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) {
      return ParseResult(
        detectedFormat: InputFormat.csv,
        data: null,
        confidence: 0.0,
      );
    }

    // Analyze first few lines for CSV patterns
    final sampleLines = lines.take(5).toList();
    final commaCount = sampleLines.map((line) => line.split(',').length).toList();
    final hasConsistentColumns = commaCount.toSet().length == 1;

    double confidence = 0.1; // Base confidence

    if (hasConsistentColumns && commaCount.first > 1) {
      confidence += 0.4;
    }

    // Check for quoted fields
    if (sampleLines.any((line) => line.contains('"'))) {
      confidence += 0.2;
    }

    // Check for header row (first row different from data rows)
    if (lines.length > 1) {
      final firstRow = lines[0].split(',');
      final secondRow = lines[1].split(',');

      if (firstRow.length == secondRow.length) {
        // Check if first row looks like headers (mostly text)
        final firstRowNumeric = firstRow.where((cell) =>
          double.tryParse(cell.trim()) != null).length;
        final secondRowNumeric = secondRow.where((cell) =>
          double.tryParse(cell.trim()) != null).length;

        if (firstRowNumeric < secondRowNumeric) {
          confidence += 0.3;
        }
      }
    }

    try {
      final data = _parseCSVContent(input);
      return ParseResult(
        detectedFormat: InputFormat.csv,
        data: data,
        confidence: confidence.clamp(0.0, 1.0),
        metadata: {
          'rowCount': lines.length,
          'columnCount': commaCount.isNotEmpty ? commaCount.first : 0,
          'hasHeader': confidence > 0.5,
        },
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.csv,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Parse CSV format
  static ParseResult _parseCSV(String input) {
    try {
      final data = _parseCSVContent(input);
      return ParseResult(
        detectedFormat: InputFormat.csv,
        data: data,
        confidence: 1.0,
      );
    } catch (e) {
      return ParseResult(
        detectedFormat: InputFormat.csv,
        data: null,
        confidence: 0.0,
        errors: [e.toString()],
      );
    }
  }

  /// Parse XML content into Dart objects (simplified)
  static Map<String, dynamic> _parseXMLContent(String xml) {
    // This is a simplified XML parser for basic structures
    // In production, you'd use a proper XML parser library

    final result = <String, dynamic>{};

    // Extract root element name
    final rootMatch = RegExp(r'<([a-zA-Z][^>\s]*)[^>]*>').firstMatch(xml);
    if (rootMatch != null) {
      result['rootElement'] = rootMatch.group(1);
    }

    // Extract text content (simplified)
    final textContent = xml
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (textContent.isNotEmpty) {
      result['textContent'] = textContent;
    }

    // Note: This is a basic parser. For production use, implement proper XML parsing
    result['_note'] = 'Simplified XML parsing - use proper XML parser for complex structures';

    return result;
  }

  /// Parse YAML content into Dart objects (simplified)
  static dynamic _parseYAMLContent(String yaml) {
    // This is a simplified YAML parser for basic structures
    // In production, you'd use the yaml package

    final lines = yaml.split('\n');
    final result = <String, dynamic>{};

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      if (trimmed.contains(':')) {
        final parts = trimmed.split(':');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join(':').trim();
          result[key] = value.isEmpty ? null : value;
        }
      }
    }

    return result;
  }

  /// Parse URL-encoded content into Map
  static Map<String, dynamic> _parseURLEncodedContent(String content) {
    final result = <String, dynamic>{};

    final pairs = content.split('&');
    for (final pair in pairs) {
      final parts = pair.split('=');
      if (parts.length >= 2) {
        final key = Uri.decodeComponent(parts[0]);
        final value = Uri.decodeComponent(parts.sublist(1).join('='));
        result[key] = value;
      } else if (parts.length == 1) {
        result[parts[0]] = null;
      }
    }

    return result;
  }

  /// Parse INI content into nested Map
  static Map<String, Map<String, String>> _parseINIContent(String content) {
    final result = <String, Map<String, String>>{};
    String currentSection = 'default';

    final lines = content.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith(';')) {
        continue;
      }

      // Section header
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        currentSection = trimmed.substring(1, trimmed.length - 1);
        result[currentSection] = <String, String>{};
        continue;
      }

      // Key-value pair
      if (trimmed.contains('=')) {
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          result.putIfAbsent(currentSection, () => <String, String>{});
          result[currentSection]![key] = value;
        }
      }
    }

    return result;
  }

  /// Parse CSV content into list of maps
  static List<Map<String, dynamic>> _parseCSVContent(String content) {
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) return [];

    // Simple CSV parser (doesn't handle escaped quotes properly)
    final headers = lines[0].split(',').map((h) => h.trim()).toList();
    final rows = <Map<String, dynamic>>[];

    for (int i = 1; i < lines.length; i++) {
      final values = lines[i].split(',').map((v) => v.trim()).toList();
      final row = <String, dynamic>{};

      for (int j = 0; j < headers.length && j < values.length; j++) {
        final value = values[j];
        // Try to parse as number
        final numValue = double.tryParse(value);
        row[headers[j]] = numValue ?? value;
      }

      rows.add(row);
    }

    return rows;
  }

  /// Extract root element name from XML
  static String? _extractRootElement(String xml) {
    final match = RegExp(r'<([a-zA-Z][^>\s]*)[^>]*>').firstMatch(xml);
    return match?.group(1);
  }
}