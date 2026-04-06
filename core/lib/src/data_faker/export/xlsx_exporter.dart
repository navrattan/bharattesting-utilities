/// XLSX export functionality for Indian Data Faker
///
/// Converts generated records to Excel format using archive package for ZIP compression

import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';

/// XLSX export functionality for faker data
class XLSXExporter {
  /// Export records to XLSX bytes
  static Uint8List exportToXLSX(List<Map<String, dynamic>> records, {
    String? sheetName,
    bool includeMetadataSheet = true,
  }) {
    if (records.isEmpty) {
      return _createEmptyWorkbook();
    }

    final workbook = _createWorkbook(records,
        sheetName: sheetName ?? 'Data',
        includeMetadataSheet: includeMetadataSheet);

    return _workbookToBytes(workbook);
  }

  /// Export records to XLSX with template-specific formatting
  static Uint8List exportTemplateToXLSX(
    List<Map<String, dynamic>> records,
    String templateType, {
    bool includeMetadataSheet = true,
  }) {
    if (records.isEmpty) {
      return _createEmptyWorkbook();
    }

    final sheetName = _getTemplateSheetName(templateType);
    final workbook = _createWorkbook(records,
        sheetName: sheetName,
        includeMetadataSheet: includeMetadataSheet,
        templateType: templateType);

    return _workbookToBytes(workbook);
  }

  /// Create workbook structure
  static Map<String, dynamic> _createWorkbook(
    List<Map<String, dynamic>> records, {
    required String sheetName,
    bool includeMetadataSheet = true,
    String? templateType,
  }) {
    final workbook = <String, dynamic>{
      'sheets': <String, List<List<String>>>{},
      'metadata': {
        'created_at': DateTime.now().toIso8601String(),
        'created_by': 'BharatTesting Data Faker',
        'version': '1.0',
        'website': 'https://bharattesting.com',
      }
    };

    // Add main data sheet
    final dataSheet = _createDataSheet(records, templateType);
    workbook['sheets'][sheetName] = dataSheet;

    // Add metadata sheet if requested
    if (includeMetadataSheet) {
      final metadataSheet = _createMetadataSheet(records, templateType);
      workbook['sheets']['Metadata'] = metadataSheet;
    }

    return workbook;
  }

  /// Create data sheet with records
  static List<List<String>> _createDataSheet(
    List<Map<String, dynamic>> records,
    String? templateType,
  ) {
    if (records.isEmpty) {
      return [['No data available']];
    }

    // Get column order
    final columns = templateType != null
        ? _getTemplateColumns(templateType)
        : _getAllColumns(records);

    final sheet = <List<String>>[];

    // Add header row
    sheet.add(columns);

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
      sheet.add(row);
    }

    return sheet;
  }

  /// Create metadata sheet
  static List<List<String>> _createMetadataSheet(
    List<Map<String, dynamic>> records,
    String? templateType,
  ) {
    final sheet = <List<String>>[];

    // Export information
    sheet.add(['Export Information', '']);
    sheet.add(['Generated At', DateTime.now().toIso8601String()]);
    sheet.add(['Total Records', records.length.toString()]);
    sheet.add(['Template Type', templateType ?? 'Mixed']);
    sheet.add(['Export Format', 'XLSX']);
    sheet.add(['Generator', 'BharatTesting Data Faker']);
    sheet.add(['Website', 'https://bharattesting.com']);
    sheet.add(['', '']); // Empty row

    if (records.isNotEmpty) {
      // Template distribution
      final templateDist = <String, int>{};
      for (final record in records) {
        final template = record['template_type'] as String? ?? 'unknown';
        templateDist[template] = (templateDist[template] ?? 0) + 1;
      }

      sheet.add(['Template Distribution', '']);
      for (final entry in templateDist.entries) {
        sheet.add([entry.key, entry.value.toString()]);
      }
      sheet.add(['', '']); // Empty row

      // State distribution
      final stateDist = <String, int>{};
      for (final record in records) {
        final state = record['state'] as String?;
        if (state != null) {
          stateDist[state] = (stateDist[state] ?? 0) + 1;
        }
      }

      if (stateDist.isNotEmpty) {
        sheet.add(['State Distribution', '']);
        for (final entry in stateDist.entries) {
          sheet.add([entry.key, entry.value.toString()]);
        }
        sheet.add(['', '']); // Empty row
      }

      // Column information
      sheet.add(['Column Information', '']);
      final columns = templateType != null
          ? _getTemplateColumns(templateType)
          : _getAllColumns(records);

      for (int i = 0; i < columns.length; i++) {
        final column = columns[i];
        final description = _getColumnDescription(column);
        sheet.add(['${i + 1}', column, description]);
      }
    }

    return sheet;
  }

  /// Get all unique columns from records
  static List<String> _getAllColumns(List<Map<String, dynamic>> records) {
    final allKeys = <String>{};
    for (final record in records) {
      allKeys.addAll(record.keys);
    }
    return allKeys.toList()..sort();
  }

  /// Get template-specific column order
  static List<String> _getTemplateColumns(String templateType) {
    switch (templateType) {
      case 'individual':
        return [
          'template_type', 'pan', 'aadhaar', 'pin_code', 'state',
          'address', 'upi_id', 'generated_at', 'seed_used'
        ];

      case 'company':
        return [
          'template_type', 'company_type', 'pan', 'gstin', 'cin', 'tan',
          'ifsc', 'upi_id', 'udyam', 'pin_code', 'state', 'state_code',
          'address', 'bank_code', 'generated_at', 'seed_used'
        ];

      case 'proprietorship':
        return [
          'template_type', 'pan', 'gstin', 'udyam', 'tan', 'pin_code',
          'state', 'state_code', 'address', 'upi_id', 'generated_at', 'seed_used'
        ];

      case 'partnership':
        return [
          'template_type', 'firm_type', 'pan', 'gstin', 'tan', 'ifsc',
          'upi_id', 'pin_code', 'state', 'state_code', 'address',
          'bank_code', 'number_of_partners', 'partners', 'generated_at', 'seed_used'
        ];

      case 'trust':
        return [
          'template_type', 'trust_type', 'pan', 'gstin', 'gst_registered',
          'tan', 'ifsc', 'upi_id', 'pin_code', 'state', 'state_code',
          'address', 'bank_code', 'registration', 'generated_at', 'seed_used'
        ];

      default:
        return [];
    }
  }

  /// Get column description for metadata sheet
  static String _getColumnDescription(String column) {
    const descriptions = {
      'template_type': 'Type of entity template used',
      'pan': 'Permanent Account Number',
      'gstin': 'Goods and Services Tax Identification Number',
      'aadhaar': 'Aadhaar unique identification number',
      'cin': 'Corporate Identification Number',
      'tan': 'Tax Deduction and Collection Account Number',
      'ifsc': 'Indian Financial System Code',
      'upi_id': 'Unified Payments Interface ID',
      'udyam': 'Udyam Registration Number',
      'pin_code': 'Postal Index Number',
      'state': 'State/Union Territory name',
      'state_code': 'GST state code',
      'address': 'Complete address',
      'bank_code': 'Bank identifier code',
      'company_type': 'Type of company entity',
      'firm_type': 'Type of partnership firm',
      'trust_type': 'Type of trust/society',
      'gst_registered': 'Whether entity is GST registered',
      'number_of_partners': 'Number of partners in firm',
      'partners': 'Partner details (JSON)',
      'registration': 'Registration details (JSON)',
      'generated_at': 'Timestamp of generation',
      'seed_used': 'Random seed used for generation',
    };

    return descriptions[column] ?? 'Generated field';
  }

  /// Get template-specific sheet name
  static String _getTemplateSheetName(String templateType) {
    switch (templateType) {
      case 'individual':
        return 'Individual Records';
      case 'company':
        return 'Company Records';
      case 'proprietorship':
        return 'Proprietorship Records';
      case 'partnership':
        return 'Partnership Records';
      case 'trust':
        return 'Trust Records';
      default:
        return 'Data';
    }
  }

  /// Convert workbook to XLSX bytes
  static Uint8List _workbookToBytes(Map<String, dynamic> workbook) {
    final archive = Archive();

    // Add required XLSX files
    _addXLSXFiles(archive, workbook);

    // Create ZIP archive
    final zipData = ZipEncoder().encode(archive);
    return Uint8List.fromList(zipData!);
  }

  /// Add required XLSX files to archive
  static void _addXLSXFiles(Archive archive, Map<String, dynamic> workbook) {
    // [Content_Types].xml
    final contentTypes = _createContentTypesXML(workbook);
    archive.addFile(ArchiveFile('[Content_Types].xml', contentTypes.length, contentTypes));

    // _rels/.rels
    final rels = _createRelsXML();
    archive.addFile(ArchiveFile('_rels/.rels', rels.length, rels));

    // xl/_rels/workbook.xml.rels
    final workbookRels = _createWorkbookRelsXML(workbook);
    archive.addFile(ArchiveFile('xl/_rels/workbook.xml.rels', workbookRels.length, workbookRels));

    // xl/workbook.xml
    final workbookXML = _createWorkbookXML(workbook);
    archive.addFile(ArchiveFile('xl/workbook.xml', workbookXML.length, workbookXML));

    // xl/sharedStrings.xml
    final sharedStrings = _createSharedStringsXML(workbook);
    archive.addFile(ArchiveFile('xl/sharedStrings.xml', sharedStrings.length, sharedStrings));

    // Add worksheet files
    final sheets = workbook['sheets'] as Map<String, List<List<String>>>;
    int sheetId = 1;
    for (final sheetName in sheets.keys) {
      final sheetData = sheets[sheetName]!;
      final worksheetXML = _createWorksheetXML(sheetData);
      archive.addFile(ArchiveFile('xl/worksheets/sheet$sheetId.xml', worksheetXML.length, worksheetXML));
      sheetId++;
    }
  }

  // XML generation methods (simplified for basic XLSX structure)
  static Uint8List _createContentTypesXML(Map<String, dynamic> workbook) {
    final sheets = workbook['sheets'] as Map<String, List<List<String>>>;
    final buffer = StringBuffer();

    buffer.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.write('<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">');
    buffer.write('<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>');
    buffer.write('<Default Extension="xml" ContentType="application/xml"/>');
    buffer.write('<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>');

    int sheetId = 1;
    for (final _ in sheets.keys) {
      buffer.write('<Override PartName="/xl/worksheets/sheet$sheetId.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>');
      sheetId++;
    }

    buffer.write('<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>');
    buffer.write('</Types>');

    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }

  static Uint8List _createRelsXML() {
    const content = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>''';

    return Uint8List.fromList(utf8.encode(content));
  }

  static Uint8List _createWorkbookRelsXML(Map<String, dynamic> workbook) {
    final sheets = workbook['sheets'] as Map<String, List<List<String>>>;
    final buffer = StringBuffer();

    buffer.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.write('<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">');

    int sheetId = 1;
    for (final _ in sheets.keys) {
      buffer.write('<Relationship Id="rId$sheetId" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet$sheetId.xml"/>');
      sheetId++;
    }

    buffer.write('<Relationship Id="rId${sheetId}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>');
    buffer.write('</Relationships>');

    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }

  static Uint8List _createWorkbookXML(Map<String, dynamic> workbook) {
    final sheets = workbook['sheets'] as Map<String, List<List<String>>>;
    final buffer = StringBuffer();

    buffer.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.write('<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">');
    buffer.write('<sheets>');

    int sheetId = 1;
    for (final sheetName in sheets.keys) {
      buffer.write('<sheet name="${_escapeXML(sheetName)}" sheetId="$sheetId" r:id="rId$sheetId"/>');
      sheetId++;
    }

    buffer.write('</sheets>');
    buffer.write('</workbook>');

    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }

  static Uint8List _createSharedStringsXML(Map<String, dynamic> workbook) {
    // Simplified - empty shared strings for basic functionality
    const content = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
</sst>''';

    return Uint8List.fromList(utf8.encode(content));
  }

  static Uint8List _createWorksheetXML(List<List<String>> sheetData) {
    final buffer = StringBuffer();

    buffer.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.write('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">');
    buffer.write('<sheetData>');

    for (int rowIndex = 0; rowIndex < sheetData.length; rowIndex++) {
      final row = sheetData[rowIndex];
      buffer.write('<row r="${rowIndex + 1}">');

      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        final cellValue = row[colIndex];
        final cellRef = _columnIndexToLetter(colIndex) + (rowIndex + 1).toString();

        buffer.write('<c r="$cellRef" t="inlineStr">');
        buffer.write('<is><t>${_escapeXML(cellValue)}</t></is>');
        buffer.write('</c>');
      }

      buffer.write('</row>');
    }

    buffer.write('</sheetData>');
    buffer.write('</worksheet>');

    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }

  /// Create empty workbook for no data scenarios
  static Uint8List _createEmptyWorkbook() {
    final emptyRecords = <Map<String, dynamic>>[];
    final workbook = _createWorkbook(emptyRecords, sheetName: 'Empty', includeMetadataSheet: false);
    return _workbookToBytes(workbook);
  }

  /// Convert column index to Excel letter (A, B, C, etc.)
  static String _columnIndexToLetter(int index) {
    String result = '';
    while (index >= 0) {
      result = String.fromCharCode(65 + (index % 26)) + result;
      index = (index ~/ 26) - 1;
    }
    return result;
  }

  /// Escape XML special characters
  static String _escapeXML(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  /// Generate filename for XLSX export
  static String generateFilename(String templateType, {String? prefix}) {
    final timestamp = DateTime.now().toIso8601String().split('T')[0];
    final basePrefix = prefix ?? 'bharattesting_faker';
    return '${basePrefix}_${templateType}_$timestamp.xlsx';
  }

  /// Validate XLSX bytes (basic check)
  static bool validateXLSXBytes(Uint8List xlsxBytes) {
    if (xlsxBytes.isEmpty) {
      return false;
    }

    try {
      // Basic validation - check if it's a valid ZIP file
      final archive = ZipDecoder().decodeBytes(xlsxBytes);
      return archive.isNotEmpty &&
             archive.any((file) => file.name.contains('workbook.xml'));
    } catch (e) {
      return false;
    }
  }

  /// Get approximate size in bytes
  static int getApproximateSize(List<Map<String, dynamic>> records) {
    if (records.isEmpty) {
      return 4096; // Basic empty workbook size
    }

    // Rough estimation based on data size
    final jsonSize = jsonEncode(records).length;
    return (jsonSize * 0.7).round(); // XLSX is usually smaller than JSON due to compression
  }
}