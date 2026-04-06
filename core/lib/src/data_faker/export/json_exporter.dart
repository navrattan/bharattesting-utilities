/// JSON export functionality for Indian Data Faker
///
/// Converts generated records to JSON format with proper formatting and metadata

import 'dart:convert';

/// JSON export functionality for faker data
class JSONExporter {
  /// Export records to formatted JSON string
  static String exportToJSON(List<Map<String, dynamic>> records, {
    bool prettify = true,
    bool includeMetadata = true,
  }) {
    if (records.isEmpty) {
      return prettify ? '[]' : '[]';
    }

    Map<String, dynamic> output;

    if (includeMetadata) {
      output = {
        'metadata': _generateMetadata(records),
        'records': records,
      };
    } else {
      output = {'records': records};
    }

    if (prettify) {
      return const JsonEncoder.withIndent('  ').convert(output);
    } else {
      return jsonEncode(output);
    }
  }

  /// Export records as raw JSON array (no metadata wrapper)
  static String exportToJSONArray(List<Map<String, dynamic>> records, {
    bool prettify = true,
  }) {
    if (records.isEmpty) {
      return prettify ? '[]' : '[]';
    }

    if (prettify) {
      return const JsonEncoder.withIndent('  ').convert(records);
    } else {
      return jsonEncode(records);
    }
  }

  /// Export single record to JSON
  static String exportSingleRecord(Map<String, dynamic> record, {
    bool prettify = true,
  }) {
    if (prettify) {
      return const JsonEncoder.withIndent('  ').convert(record);
    } else {
      return jsonEncode(record);
    }
  }

  /// Export records with template-specific structure
  static String exportTemplateToJSON(
    List<Map<String, dynamic>> records,
    String templateType, {
    bool prettify = true,
  }) {
    if (records.isEmpty) {
      return prettify ? '{}' : '{}';
    }

    final templateStructure = _getTemplateStructure(records, templateType);

    if (prettify) {
      return const JsonEncoder.withIndent('  ').convert(templateStructure);
    } else {
      return jsonEncode(templateStructure);
    }
  }

  /// Generate metadata for the export
  static Map<String, dynamic> _generateMetadata(List<Map<String, dynamic>> records) {
    if (records.isEmpty) {
      return {
        'export_info': {
          'generated_at': DateTime.now().toIso8601String(),
          'total_records': 0,
          'template_types': <String>[],
          'export_format': 'json',
          'version': '1.0',
        }
      };
    }

    final templateTypes = <String>{};
    final stateDistribution = <String, int>{};
    final templateDistribution = <String, int>{};

    for (final record in records) {
      final templateType = record['template_type'] as String? ?? 'unknown';
      templateTypes.add(templateType);

      // Count template distribution
      templateDistribution[templateType] = (templateDistribution[templateType] ?? 0) + 1;

      // Count state distribution
      final state = record['state'] as String?;
      if (state != null) {
        stateDistribution[state] = (stateDistribution[state] ?? 0) + 1;
      }
    }

    return {
      'export_info': {
        'generated_at': DateTime.now().toIso8601String(),
        'total_records': records.length,
        'template_types': templateTypes.toList()..sort(),
        'export_format': 'json',
        'version': '1.0',
        'generator': 'BharatTesting Data Faker',
        'website': 'https://bharattesting.com',
      },
      'statistics': {
        'template_distribution': templateDistribution,
        'state_distribution': stateDistribution,
        'unique_states': stateDistribution.length,
        'unique_templates': templateTypes.length,
      }
    };
  }

  /// Create template-specific structure
  static Map<String, dynamic> _getTemplateStructure(
    List<Map<String, dynamic>> records,
    String templateType,
  ) {
    final templateInfo = _getTemplateInfo(templateType);

    return {
      'template_info': templateInfo,
      'metadata': _generateMetadata(records),
      'records': records,
    };
  }

  /// Get template information
  static Map<String, dynamic> _getTemplateInfo(String templateType) {
    switch (templateType) {
      case 'individual':
        return {
          'type': 'individual',
          'description': 'Individual person identifiers',
          'identifiers': ['pan', 'aadhaar', 'pin_code', 'upi_id'],
          'business_identifiers': false,
          'entity_type': 'individual',
        };

      case 'company':
        return {
          'type': 'company',
          'description': 'Private/Public limited company identifiers',
          'identifiers': ['pan', 'gstin', 'cin', 'tan', 'ifsc', 'upi_id', 'udyam'],
          'business_identifiers': true,
          'entity_type': 'company',
        };

      case 'proprietorship':
        return {
          'type': 'proprietorship',
          'description': 'Sole proprietorship business identifiers',
          'identifiers': ['pan', 'gstin', 'udyam', 'tan', 'upi_id'],
          'business_identifiers': true,
          'entity_type': 'proprietorship',
        };

      case 'partnership':
        return {
          'type': 'partnership',
          'description': 'Partnership firm identifiers with partners',
          'identifiers': ['pan', 'gstin', 'tan', 'ifsc', 'upi_id'],
          'business_identifiers': true,
          'entity_type': 'partnership',
          'supports_partners': true,
        };

      case 'trust':
        return {
          'type': 'trust',
          'description': 'Trust/Society/Association identifiers',
          'identifiers': ['pan', 'gstin', 'tan', 'ifsc', 'upi_id'],
          'business_identifiers': true,
          'entity_type': 'trust',
          'gst_optional': true,
        };

      default:
        return {
          'type': templateType,
          'description': 'Mixed or unknown template type',
          'identifiers': [],
          'business_identifiers': false,
          'entity_type': 'unknown',
        };
    }
  }

  /// Generate filename for JSON export
  static String generateFilename(String templateType, {
    String? prefix,
    bool includeMetadata = true,
  }) {
    final timestamp = DateTime.now().toIso8601String().split('T')[0];
    final basePrefix = prefix ?? 'bharattesting_faker';
    final suffix = includeMetadata ? 'with_metadata' : 'records_only';
    return '${basePrefix}_${templateType}_${suffix}_$timestamp.json';
  }

  /// Validate JSON output
  static bool validateJSONOutput(String jsonOutput) {
    if (jsonOutput.isEmpty) {
      return false;
    }

    try {
      jsonDecode(jsonOutput);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get record count from JSON string
  static int getRecordCount(String jsonOutput) {
    try {
      final decoded = jsonDecode(jsonOutput);

      if (decoded is List) {
        return decoded.length;
      }

      if (decoded is Map && decoded.containsKey('records')) {
        final records = decoded['records'];
        if (records is List) {
          return records.length;
        }
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Extract records from JSON string
  static List<Map<String, dynamic>> extractRecords(String jsonOutput) {
    try {
      final decoded = jsonDecode(jsonOutput);

      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }

      if (decoded is Map && decoded.containsKey('records')) {
        final records = decoded['records'];
        if (records is List) {
          return records.cast<Map<String, dynamic>>();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Pretty print existing JSON string
  static String prettifyJSON(String jsonOutput) {
    try {
      final decoded = jsonDecode(jsonOutput);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (e) {
      return jsonOutput; // Return original if parsing fails
    }
  }

  /// Minify JSON string
  static String minifyJSON(String jsonOutput) {
    try {
      final decoded = jsonDecode(jsonOutput);
      return jsonEncode(decoded);
    } catch (e) {
      return jsonOutput; // Return original if parsing fails
    }
  }
}