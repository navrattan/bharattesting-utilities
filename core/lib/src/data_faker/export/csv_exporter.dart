/// CSV export functionality for Indian Data Faker
///
/// Converts generated records to CSV format with proper headers and encoding

import 'dart:convert';
import 'package:csv/csv.dart';

/// CSV export functionality for faker data
class CSVExporter {
  /// Export records to CSV string
  static String exportToCSV(List<Map<String, dynamic>> records) {
    if (records.isEmpty) {
      return '';
    }

    // Extract all unique keys from all records to create comprehensive headers
    final allKeys = <String>{};
    for (final record in records) {
      allKeys.addAll(record.keys);
    }

    // Sort keys for consistent column order
    final sortedKeys = allKeys.toList()..sort();

    // Create CSV data
    final csvData = <List<String>>[];

    // Add headers
    csvData.add(sortedKeys);

    // Add data rows
    for (final record in records) {
      final row = <String>[];
      for (final key in sortedKeys) {
        final value = record[key];
        if (value == null) {
          row.add('');
        } else if (value is List || value is Map) {
          // Convert complex types to JSON strings
          row.add(jsonEncode(value));
        } else {
          row.add(value.toString());
        }
      }
      csvData.add(row);
    }

    // Convert to CSV string
    return const ListToCsvConverter().convert(csvData);
  }

  /// Export records to CSV with custom column selection
  static String exportToCSVWithColumns(
    List<Map<String, dynamic>> records,
    List<String> columns,
  ) {
    if (records.isEmpty || columns.isEmpty) {
      return '';
    }

    // Create CSV data
    final csvData = <List<String>>[];

    // Add headers
    csvData.add(columns);

    // Add data rows
    for (final record in records) {
      final row = <String>[];
      for (final column in columns) {
        final value = record[column];
        if (value == null) {
          row.add('');
        } else if (value is List || value is Map) {
          row.add(jsonEncode(value));
        } else {
          row.add(value.toString());
        }
      }
      csvData.add(row);
    }

    return const ListToCsvConverter().convert(csvData);
  }

  /// Export records to CSV with template-specific formatting
  static String exportTemplateToCSV(
    List<Map<String, dynamic>> records,
    String templateType,
  ) {
    if (records.isEmpty) {
      return '';
    }

    final templateColumns = _getTemplateColumns(templateType);

    if (templateColumns.isEmpty) {
      return exportToCSV(records);
    }

    return exportToCSVWithColumns(records, templateColumns);
  }

  /// Get preferred column order for each template type
  static List<String> _getTemplateColumns(String templateType) {
    switch (templateType) {
      case 'individual':
        return [
          'template_type',
          'pan',
          'aadhaar',
          'pin_code',
          'state',
          'address',
          'upi_id',
          'generated_at',
          'seed_used',
        ];

      case 'company':
        return [
          'template_type',
          'company_type',
          'pan',
          'gstin',
          'cin',
          'tan',
          'ifsc',
          'upi_id',
          'udyam',
          'pin_code',
          'state',
          'state_code',
          'address',
          'bank_code',
          'generated_at',
          'seed_used',
        ];

      case 'proprietorship':
        return [
          'template_type',
          'pan',
          'gstin',
          'udyam',
          'tan',
          'pin_code',
          'state',
          'state_code',
          'address',
          'upi_id',
          'generated_at',
          'seed_used',
        ];

      case 'partnership':
        return [
          'template_type',
          'firm_type',
          'pan',
          'gstin',
          'tan',
          'ifsc',
          'upi_id',
          'pin_code',
          'state',
          'state_code',
          'address',
          'bank_code',
          'number_of_partners',
          'partners',
          'generated_at',
          'seed_used',
        ];

      case 'trust':
        return [
          'template_type',
          'trust_type',
          'pan',
          'gstin',
          'gst_registered',
          'tan',
          'ifsc',
          'upi_id',
          'pin_code',
          'state',
          'state_code',
          'address',
          'bank_code',
          'registration',
          'generated_at',
          'seed_used',
        ];

      default:
        return [];
    }
  }

  /// Generate filename for CSV export
  static String generateFilename(String templateType, {String? prefix}) {
    final timestamp = DateTime.now().toIso8601String().split('T')[0];
    final basePrefix = prefix ?? 'bharattesting_faker';
    return '${basePrefix}_${templateType}_$timestamp.csv';
  }

  /// Validate CSV output
  static bool validateCSVOutput(String csvOutput) {
    if (csvOutput.isEmpty) {
      return false;
    }

    try {
      final lines = csvOutput.split('\n');
      if (lines.length < 2) {
        return false; // Need at least header + 1 data row
      }

      // Parse first row to validate it's valid CSV
      const converter = CsvToListConverter();
      final firstRow = converter.convert(lines[0]);

      return firstRow.isNotEmpty && firstRow[0].isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get column count from CSV string
  static int getColumnCount(String csvOutput) {
    if (csvOutput.isEmpty) {
      return 0;
    }

    try {
      final lines = csvOutput.split('\n');
      if (lines.isEmpty) {
        return 0;
      }

      const converter = CsvToListConverter();
      final firstRow = converter.convert(lines[0]);
      return firstRow.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get row count from CSV string (excluding header)
  static int getRowCount(String csvOutput) {
    if (csvOutput.isEmpty) {
      return 0;
    }

    final lines = csvOutput.split('\n').where((line) => line.trim().isNotEmpty).toList();
    return lines.length > 1 ? lines.length - 1 : 0;
  }
}