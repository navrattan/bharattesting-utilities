/// CSV parser for converting CSV data to JSON format
///
/// Handles various CSV dialects and formats with intelligent type detection

import 'dart:convert';

/// CSV parsing configuration
class CSVConfig {
  const CSVConfig({
    this.delimiter = ',',
    this.quoteChar = '"',
    this.escapeChar,
    this.hasHeader = true,
    this.skipEmptyLines = true,
    this.autoDetectTypes = true,
    this.trimWhitespace = true,
  });

  /// Field delimiter character
  final String delimiter;

  /// Quote character for enclosing fields
  final String quoteChar;

  /// Escape character (if null, uses double quote)
  final String? escapeChar;

  /// Whether first row contains headers
  final bool hasHeader;

  /// Whether to skip empty lines
  final bool skipEmptyLines;

  /// Whether to automatically detect and convert data types
  final bool autoDetectTypes;

  /// Whether to trim whitespace from fields
  final bool trimWhitespace;
}

/// Result of CSV parsing operation
class CSVParseResult {
  const CSVParseResult({
    required this.data,
    required this.headers,
    required this.rowCount,
    required this.columnCount,
    this.metadata,
    this.warnings,
  });

  /// Parsed data as list of maps (if headers) or list of lists (if no headers)
  final dynamic data;

  /// Column headers (if detected/provided)
  final List<String> headers;

  /// Number of data rows (excluding header)
  final int rowCount;

  /// Number of columns
  final int columnCount;

  /// Additional metadata about the parsing
  final Map<String, dynamic>? metadata;

  /// Warning messages
  final List<String>? warnings;
}

/// Advanced CSV parser with intelligent type detection
class CSVParser {
  /// Parse CSV string with configuration
  static CSVParseResult parse(String csvContent, [CSVConfig? config]) {
    config ??= const CSVConfig();

    if (csvContent.trim().isEmpty) {
      return CSVParseResult(
        data: config.hasHeader ? <Map<String, dynamic>>[] : <List<dynamic>>[],
        headers: [],
        rowCount: 0,
        columnCount: 0,
      );
    }

    final parseContext = _CSVParseContext(config);
    final rawRows = _parseRawRows(csvContent, parseContext);

    if (rawRows.isEmpty) {
      return CSVParseResult(
        data: config.hasHeader ? <Map<String, dynamic>>[] : <List<dynamic>>[],
        headers: [],
        rowCount: 0,
        columnCount: 0,
      );
    }

    // Determine headers and data rows
    List<String> headers;
    List<List<String>> dataRows;

    if (config.hasHeader && rawRows.isNotEmpty) {
      headers = rawRows[0].map((cell) =>
        config.trimWhitespace ? cell.trim() : cell).toList();
      dataRows = rawRows.skip(1).toList();
    } else {
      // Generate default headers
      final maxColumns = rawRows.map((row) => row.length).reduce((a, b) => a > b ? a : b);
      headers = List.generate(maxColumns, (index) => 'column_${index + 1}');
      dataRows = rawRows;
    }

    // Type detection and conversion
    final typedData = config.autoDetectTypes
        ? _convertTypes(dataRows, parseContext)
        : dataRows.map((row) => List<dynamic>.from(row)).toList();

    // Format output
    final data = config.hasHeader
        ? _formatAsMapList(typedData, headers)
        : typedData;

    final metadata = {
      'delimiter': config.delimiter,
      'hasHeader': config.hasHeader,
      'autoDetectedTypes': config.autoDetectTypes,
      'typeInfo': config.autoDetectTypes ? _analyzeTypes(typedData) : null,
      'emptyRowsSkipped': parseContext.emptyRowsSkipped,
      'totalRowsParsed': rawRows.length,
    };

    return CSVParseResult(
      data: data,
      headers: headers,
      rowCount: dataRows.length,
      columnCount: headers.length,
      metadata: metadata,
      warnings: parseContext.warnings.isEmpty ? null : parseContext.warnings,
    );
  }

  /// Convert CSV to JSON string
  static String toJSON(String csvContent, {
    CSVConfig? config,
    bool prettify = false,
  }) {
    final parseResult = parse(csvContent, config);

    final output = {
      'data': parseResult.data,
      'metadata': {
        'rowCount': parseResult.rowCount,
        'columnCount': parseResult.columnCount,
        'headers': parseResult.headers,
        ...parseResult.metadata ?? {},
      },
      if (parseResult.warnings != null && parseResult.warnings!.isNotEmpty)
        'warnings': parseResult.warnings,
    };

    if (prettify) {
      return const JsonEncoder.withIndent('  ').convert(output);
    } else {
      return jsonEncode(output);
    }
  }

  /// Auto-detect CSV delimiter
  static String detectDelimiter(String csvContent) {
    final delimiters = [',', ';', '\t', '|', ':'];
    final lines = csvContent.split('\n').take(10).toList();
    final scores = <String, double>{};

    for (final delimiter in delimiters) {
      final counts = lines.map((line) =>
        line.split(delimiter).length).where((count) => count > 1).toList();

      if (counts.isEmpty) {
        scores[delimiter] = 0.0;
        continue;
      }

      // Calculate consistency score
      final avgCount = counts.reduce((a, b) => a + b) / counts.length;
      final variance = counts.map((count) =>
        (count - avgCount) * (count - avgCount)).reduce((a, b) => a + b) / counts.length;

      // Higher count and lower variance = better delimiter
      scores[delimiter] = avgCount * (1.0 / (1.0 + variance));
    }

    // Return delimiter with highest score
    return scores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Parse raw rows from CSV content
  static List<List<String>> _parseRawRows(String content, _CSVParseContext context) {
    final rows = <List<String>>[];
    final lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (context.config.skipEmptyLines && line.trim().isEmpty) {
        context.emptyRowsSkipped++;
        continue;
      }

      try {
        final fields = _parseCSVLine(line, context);
        if (fields.isNotEmpty || !context.config.skipEmptyLines) {
          rows.add(fields);
        }
      } catch (e) {
        context.warnings.add('Error parsing line ${i + 1}: ${e.toString()}');
      }
    }

    return rows;
  }

  /// Parse a single CSV line into fields
  static List<String> _parseCSVLine(String line, _CSVParseContext context) {
    final fields = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;
    bool escaped = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      final isQuote = char == context.config.quoteChar;
      final isDelimiter = char == context.config.delimiter;
      final isEscape = context.config.escapeChar != null &&
                      char == context.config.escapeChar;

      if (escaped) {
        buffer.write(char);
        escaped = false;
        continue;
      }

      if (isEscape) {
        escaped = true;
        continue;
      }

      if (isQuote) {
        if (!inQuotes) {
          inQuotes = true;
        } else {
          // Check for escaped quote (double quote)
          if (i + 1 < line.length && line[i + 1] == context.config.quoteChar) {
            buffer.write(char);
            i++; // Skip next quote
          } else {
            inQuotes = false;
          }
        }
        continue;
      }

      if (isDelimiter && !inQuotes) {
        fields.add(context.config.trimWhitespace ?
                   buffer.toString().trim() : buffer.toString());
        buffer.clear();
        continue;
      }

      buffer.write(char);
    }

    // Add last field
    fields.add(context.config.trimWhitespace ?
               buffer.toString().trim() : buffer.toString());

    return fields;
  }

  /// Convert string values to appropriate types
  static List<List<dynamic>> _convertTypes(
    List<List<String>> rows,
    _CSVParseContext context,
  ) {
    if (rows.isEmpty) return [];

    // Determine column count
    final maxColumns = rows.map((row) => row.length).reduce((a, b) => a > b ? a : b);

    // Analyze each column to determine type
    final columnTypes = <_ColumnType>[];

    for (int col = 0; col < maxColumns; col++) {
      final values = rows.map((row) =>
        col < row.length ? row[col] : '').where((v) => v.isNotEmpty).toList();

      columnTypes.add(_detectColumnType(values));
    }

    // Convert values based on detected types
    final typedRows = <List<dynamic>>[];

    for (final row in rows) {
      final typedRow = <dynamic>[];

      for (int col = 0; col < maxColumns; col++) {
        final value = col < row.length ? row[col] : '';
        final convertedValue = _convertValue(value, columnTypes[col]);
        typedRow.add(convertedValue);
      }

      typedRows.add(typedRow);
    }

    return typedRows;
  }

  /// Detect the type of a column based on its values
  static _ColumnType _detectColumnType(List<String> values) {
    if (values.isEmpty) return _ColumnType.string;

    int intCount = 0;
    int doubleCount = 0;
    int boolCount = 0;
    int dateCount = 0;

    for (final value in values) {
      if (value.isEmpty) continue;

      // Check for integer
      if (int.tryParse(value) != null) {
        intCount++;
        continue;
      }

      // Check for double
      if (double.tryParse(value) != null) {
        doubleCount++;
        continue;
      }

      // Check for boolean
      final lowerValue = value.toLowerCase();
      if (['true', 'false', 'yes', 'no', '1', '0'].contains(lowerValue)) {
        boolCount++;
        continue;
      }

      // Check for date (basic patterns)
      if (_isDate(value)) {
        dateCount++;
        continue;
      }
    }

    final total = values.length;
    final threshold = total * 0.8; // 80% threshold for type detection

    if (intCount >= threshold) return _ColumnType.integer;
    if (doubleCount + intCount >= threshold) return _ColumnType.double;
    if (boolCount >= threshold) return _ColumnType.boolean;
    if (dateCount >= threshold) return _ColumnType.date;

    return _ColumnType.string;
  }

  /// Convert value to appropriate type
  static dynamic _convertValue(String value, _ColumnType type) {
    if (value.isEmpty) return null;

    switch (type) {
      case _ColumnType.integer:
        return int.tryParse(value) ?? value;

      case _ColumnType.double:
        return double.tryParse(value) ?? value;

      case _ColumnType.boolean:
        final lowerValue = value.toLowerCase();
        if (['true', 'yes', '1'].contains(lowerValue)) return true;
        if (['false', 'no', '0'].contains(lowerValue)) return false;
        return value;

      case _ColumnType.date:
        // Basic date parsing - in production, use intl package
        return value; // Return as string for now

      case _ColumnType.string:
        return value;
    }
  }

  /// Format typed data as list of maps
  static List<Map<String, dynamic>> _formatAsMapList(
    List<List<dynamic>> typedData,
    List<String> headers,
  ) {
    final result = <Map<String, dynamic>>[];

    for (final row in typedData) {
      final map = <String, dynamic>{};
      for (int i = 0; i < headers.length && i < row.length; i++) {
        map[headers[i]] = row[i];
      }
      result.add(map);
    }

    return result;
  }

  /// Analyze types in converted data
  static Map<String, dynamic> _analyzeTypes(List<List<dynamic>> typedData) {
    if (typedData.isEmpty) return {};

    final maxColumns = typedData.map((row) => row.length).reduce((a, b) => a > b ? a : b);
    final columnAnalysis = <String, Map<String, int>>{};

    for (int col = 0; col < maxColumns; col++) {
      final types = <String, int>{};

      for (final row in typedData) {
        if (col < row.length && row[col] != null) {
          final type = row[col].runtimeType.toString();
          types[type] = (types[type] ?? 0) + 1;
        }
      }

      columnAnalysis['column_${col + 1}'] = types;
    }

    return columnAnalysis;
  }

  /// Basic date detection
  static bool _isDate(String value) {
    // Basic date patterns - in production, use more sophisticated detection
    final datePatterns = [
      RegExp(r'^\d{4}-\d{2}-\d{2}$'), // YYYY-MM-DD
      RegExp(r'^\d{2}/\d{2}/\d{4}$'), // MM/DD/YYYY
      RegExp(r'^\d{2}-\d{2}-\d{4}$'), // DD-MM-YYYY
    ];

    return datePatterns.any((pattern) => pattern.hasMatch(value));
  }
}

/// Column type enumeration
enum _ColumnType {
  string,
  integer,
  double,
  boolean,
  date,
}

/// Parsing context for state tracking
class _CSVParseContext {
  _CSVParseContext(this.config);

  final CSVConfig config;
  final List<String> warnings = [];
  int emptyRowsSkipped = 0;
}