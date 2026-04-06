/// JSON formatter for pretty-printing and minification
///
/// Provides intelligent JSON formatting with customizable options

import 'dart:convert';

/// JSON formatting options
class JSONFormatOptions {
  const JSONFormatOptions({
    this.indent = '  ',
    this.sortKeys = false,
    this.trailingComma = false,
    this.compactArrays = false,
    this.compactObjects = false,
    this.maxLineLength,
    this.arrayWrapThreshold = 3,
    this.objectWrapThreshold = 3,
  });

  /// Indentation string (e.g., '  ', '    ', '\t')
  final String indent;

  /// Whether to sort object keys alphabetically
  final bool sortKeys;

  /// Whether to add trailing commas (JavaScript-style)
  final bool trailingComma;

  /// Whether to format small arrays on single line
  final bool compactArrays;

  /// Whether to format small objects on single line
  final bool compactObjects;

  /// Maximum line length before wrapping
  final int? maxLineLength;

  /// Array element count threshold for compact formatting
  final int arrayWrapThreshold;

  /// Object property count threshold for compact formatting
  final int objectWrapThreshold;

  /// Predefined formatting styles
  static const JSONFormatOptions compact = JSONFormatOptions();

  static const JSONFormatOptions standard = JSONFormatOptions(
    indent: '  ',
  );

  static const JSONFormatOptions verbose = JSONFormatOptions(
    indent: '    ',
    sortKeys: true,
    compactArrays: false,
    compactObjects: false,
  );

  static const JSONFormatOptions javascript = JSONFormatOptions(
    indent: '  ',
    trailingComma: true,
    compactArrays: true,
    compactObjects: true,
  );
}

/// Result of JSON formatting operation
class FormatResult {
  const FormatResult({
    required this.formatted,
    required this.originalSize,
    required this.formattedSize,
    this.metadata,
  });

  /// The formatted JSON string
  final String formatted;

  /// Size of original JSON in characters
  final int originalSize;

  /// Size of formatted JSON in characters
  final int formattedSize;

  /// Additional formatting metadata
  final Map<String, dynamic>? metadata;

  /// Size change ratio (negative = reduction, positive = increase)
  double get sizeChangeRatio =>
      (formattedSize - originalSize) / originalSize;

  /// Whether formatting reduced size
  bool get isCompressed => formattedSize < originalSize;
}

/// Advanced JSON formatter with customizable options
class JSONFormatter {
  /// Format JSON string with pretty-printing
  static FormatResult prettify(String jsonString, [JSONFormatOptions? options]) {
    options ??= JSONFormatOptions.standard;

    try {
      final data = jsonDecode(jsonString);
      final formatted = _formatValue(data, options, 0);

      return FormatResult(
        formatted: formatted,
        originalSize: jsonString.length,
        formattedSize: formatted.length,
        metadata: {
          'style': 'prettified',
          'indent': options.indent,
          'sortKeys': options.sortKeys,
        },
      );
    } catch (e) {
      throw FormatException('Invalid JSON: ${e.toString()}');
    }
  }

  /// Minify JSON string (remove all unnecessary whitespace)
  static FormatResult minify(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      final minified = jsonEncode(data);

      return FormatResult(
        formatted: minified,
        originalSize: jsonString.length,
        formattedSize: minified.length,
        metadata: {
          'style': 'minified',
          'compressionRatio': (jsonString.length - minified.length) / jsonString.length,
        },
      );
    } catch (e) {
      throw FormatException('Invalid JSON: ${e.toString()}');
    }
  }

  /// Format with custom style
  static FormatResult format(String jsonString, JSONFormatOptions options) {
    return prettify(jsonString, options);
  }

  /// Validate and normalize JSON
  static FormatResult normalize(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      final normalized = _formatValue(data, JSONFormatOptions.standard, 0);

      return FormatResult(
        formatted: normalized,
        originalSize: jsonString.length,
        formattedSize: normalized.length,
        metadata: {
          'style': 'normalized',
          'validationPassed': true,
        },
      );
    } catch (e) {
      throw FormatException('Invalid JSON: ${e.toString()}');
    }
  }

  /// Format any Dart value as JSON
  static String _formatValue(dynamic value, JSONFormatOptions options, int depth) {
    if (value == null) {
      return 'null';
    }

    if (value is String) {
      return jsonEncode(value);
    }

    if (value is num || value is bool) {
      return value.toString();
    }

    if (value is List) {
      return _formatArray(value, options, depth);
    }

    if (value is Map) {
      return _formatObject(value, options, depth);
    }

    // Fallback for unknown types
    return jsonEncode(value.toString());
  }

  /// Format JSON array
  static String _formatArray(List<dynamic> array, JSONFormatOptions options, int depth) {
    if (array.isEmpty) {
      return '[]';
    }

    final isCompact = options.compactArrays &&
                     array.length <= options.arrayWrapThreshold &&
                     _shouldFormatCompactArray(array, options);

    if (isCompact) {
      final elements = array.map((item) =>
        _formatValue(item, options, depth + 1)).toList();
      final content = elements.join(', ');

      // Check if compact format would exceed line length
      if (options.maxLineLength != null && content.length > options.maxLineLength!) {
        return _formatArrayMultiline(array, options, depth);
      }

      return '[$content]';
    } else {
      return _formatArrayMultiline(array, options, depth);
    }
  }

  /// Format array with multiline layout
  static String _formatArrayMultiline(List<dynamic> array, JSONFormatOptions options, int depth) {
    final indent = options.indent * depth;
    final itemIndent = options.indent * (depth + 1);
    final buffer = StringBuffer();

    buffer.write('[\n');

    for (int i = 0; i < array.length; i++) {
      final item = array[i];
      buffer.write(itemIndent);
      buffer.write(_formatValue(item, options, depth + 1));

      if (i < array.length - 1) {
        buffer.write(',');
      } else if (options.trailingComma) {
        buffer.write(',');
      }

      buffer.write('\n');
    }

    buffer.write(indent);
    buffer.write(']');

    return buffer.toString();
  }

  /// Format JSON object
  static String _formatObject(Map<dynamic, dynamic> object, JSONFormatOptions options, int depth) {
    if (object.isEmpty) {
      return '{}';
    }

    // Convert keys to strings and optionally sort
    List<String> keys = object.keys.map((key) => key.toString()).toList();
    if (options.sortKeys) {
      keys.sort();
    }

    final isCompact = options.compactObjects &&
                     keys.length <= options.objectWrapThreshold &&
                     _shouldFormatCompactObject(object, options);

    if (isCompact) {
      final properties = keys.map((key) {
        final keyStr = jsonEncode(key);
        final valueStr = _formatValue(object[key], options, depth + 1);
        return '$keyStr: $valueStr';
      }).toList();
      final content = properties.join(', ');

      // Check if compact format would exceed line length
      if (options.maxLineLength != null && content.length > options.maxLineLength!) {
        return _formatObjectMultiline(object, keys, options, depth);
      }

      return '{$content}';
    } else {
      return _formatObjectMultiline(object, keys, options, depth);
    }
  }

  /// Format object with multiline layout
  static String _formatObjectMultiline(
    Map<dynamic, dynamic> object,
    List<String> keys,
    JSONFormatOptions options,
    int depth,
  ) {
    final indent = options.indent * depth;
    final propIndent = options.indent * (depth + 1);
    final buffer = StringBuffer();

    buffer.write('{\n');

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      final value = object[key];

      buffer.write(propIndent);
      buffer.write(jsonEncode(key));
      buffer.write(': ');
      buffer.write(_formatValue(value, options, depth + 1));

      if (i < keys.length - 1) {
        buffer.write(',');
      } else if (options.trailingComma) {
        buffer.write(',');
      }

      buffer.write('\n');
    }

    buffer.write(indent);
    buffer.write('}');

    return buffer.toString();
  }

  /// Check if array should be formatted compactly
  static bool _shouldFormatCompactArray(List<dynamic> array, JSONFormatOptions options) {
    // Don't compact if any element is a complex object/array
    for (final item in array) {
      if (item is Map || item is List) {
        return false;
      }
      // Don't compact if any string value is too long
      if (item is String && item.length > 20) {
        return false;
      }
    }
    return true;
  }

  /// Check if object should be formatted compactly
  static bool _shouldFormatCompactObject(Map<dynamic, dynamic> object, JSONFormatOptions options) {
    // Don't compact if any value is a complex object/array
    for (final value in object.values) {
      if (value is Map || value is List) {
        return false;
      }
      // Don't compact if any string value is too long
      if (value is String && value.length > 20) {
        return false;
      }
    }

    // Don't compact if any key is too long
    for (final key in object.keys) {
      if (key.toString().length > 15) {
        return false;
      }
    }

    return true;
  }

  /// Get JSON statistics
  static Map<String, dynamic> getStatistics(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      final stats = _analyzeValue(data);

      return {
        'size': jsonString.length,
        'minifiedSize': jsonEncode(data).length,
        'structure': stats,
        'valid': true,
      };
    } catch (e) {
      return {
        'size': jsonString.length,
        'valid': false,
        'error': e.toString(),
      };
    }
  }

  /// Analyze JSON value structure
  static Map<String, dynamic> _analyzeValue(dynamic value, [Map<String, int>? counts]) {
    counts ??= <String, int>{};

    if (value == null) {
      counts['null'] = (counts['null'] ?? 0) + 1;
    } else if (value is String) {
      counts['string'] = (counts['string'] ?? 0) + 1;
    } else if (value is int) {
      counts['integer'] = (counts['integer'] ?? 0) + 1;
    } else if (value is double) {
      counts['double'] = (counts['double'] ?? 0) + 1;
    } else if (value is bool) {
      counts['boolean'] = (counts['boolean'] ?? 0) + 1;
    } else if (value is List) {
      counts['array'] = (counts['array'] ?? 0) + 1;
      for (final item in value) {
        _analyzeValue(item, counts);
      }
    } else if (value is Map) {
      counts['object'] = (counts['object'] ?? 0) + 1;
      for (final item in value.values) {
        _analyzeValue(item, counts);
      }
    }

    return counts;
  }

  /// Detect current JSON formatting style
  static String detectStyle(String jsonString) {
    final hasNewlines = jsonString.contains('\n');
    final hasIndentation = RegExp(r'\n\s+').hasMatch(jsonString);
    final hasTrailingCommas = RegExp(r',\s*[}\]]').hasMatch(jsonString);

    if (!hasNewlines) {
      return 'minified';
    } else if (!hasIndentation) {
      return 'compact';
    } else if (hasTrailingCommas) {
      return 'javascript';
    } else {
      return 'standard';
    }
  }

  /// Convert between different formatting styles
  static FormatResult convertStyle(String jsonString, String fromStyle, String toStyle) {
    // First normalize to standard format
    final normalized = normalize(jsonString);

    // Then apply target style
    switch (toStyle.toLowerCase()) {
      case 'minified':
        return minify(jsonString);
      case 'compact':
        return format(jsonString, JSONFormatOptions.compact);
      case 'javascript':
        return format(jsonString, JSONFormatOptions.javascript);
      case 'verbose':
        return format(jsonString, JSONFormatOptions.verbose);
      default:
        return format(jsonString, JSONFormatOptions.standard);
    }
  }
}