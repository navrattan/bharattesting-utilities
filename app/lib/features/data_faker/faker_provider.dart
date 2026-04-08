/// Riverpod provider for Indian Data Faker
///
/// Manages state and business logic for data generation and export

import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:bharattesting_core/bharattesting_core.dart';

import 'faker_state.dart';

part 'faker_provider.g.dart';

/// Provider for Indian Data Faker
@riverpod
class FakerNotifier extends _$FakerNotifier {
  @override
  FakerState build() {
    return const FakerState();
  }

  /// Update selected template type
  void setTemplate(TemplateType template) {
    state = state.copyWith(
      selectedTemplate: template,
      // Reset identifier selection when template changes
      selectedIdentifiers: {},
      // Clear previous data
      generatedRecords: [],
      errorMessage: null,
    );
  }

  /// Update bulk size
  void setBulkSize(BulkSize size) {
    state = state.copyWith(
      bulkSize: size,
      errorMessage: null,
    );
  }

  /// Toggle between random and custom seed
  void setUseRandomSeed(bool useRandom) {
    state = state.copyWith(
      useRandomSeed: useRandom,
      errorMessage: null,
    );
  }

  /// Set custom seed value
  void setCustomSeed(int? seed) {
    state = state.copyWith(
      customSeed: seed,
      errorMessage: null,
    );
  }

  /// Set preferred state for generation
  void setPreferredState(String? stateName) {
    state = state.copyWith(
      preferredState: stateName,
      errorMessage: null,
    );
  }

  /// Toggle include all identifiers
  void setIncludeAllIdentifiers(bool includeAll) {
    state = state.copyWith(
      includeAllIdentifiers: includeAll,
      errorMessage: null,
    );
  }

  /// Toggle specific identifier selection
  void toggleIdentifier(String identifier) {
    final current = Set<String>.from(state.selectedIdentifiers);

    if (current.contains(identifier)) {
      current.remove(identifier);
    } else {
      current.add(identifier);
    }

    state = state.copyWith(
      selectedIdentifiers: current,
      errorMessage: null,
    );
  }

  /// Set export format
  void setExportFormat(ExportFormat format) {
    state = state.copyWith(
      selectedExportFormat: format,
      errorMessage: null,
    );
  }

  /// Toggle export metadata inclusion
  void setIncludeMetadata(bool include) {
    state = state.copyWith(
      includeMetadata: include,
      errorMessage: null,
    );
  }

  /// Toggle output prettification
  void setPrettifyOutput(bool prettify) {
    state = state.copyWith(
      prettifyOutput: prettify,
      errorMessage: null,
    );
  }

  /// Generate data records
  Future<void> generateRecords() async {
    if (!state.canGenerate) return;

    state = state.copyWith(
      isGenerating: true,
      errorMessage: null,
    );

    try {
      final stopwatch = Stopwatch()..start();

      final records = await compute(_generateRecordsInIsolate, {
        'template': state.templateTypeString,
        'count': state.effectiveBulkSize,
        'seed': state.seedToUse,
        'preferredState': state.preferredState,
      });

      stopwatch.stop();

      state = state.copyWith(
        isGenerating: false,
        generatedRecords: records,
        lastGeneratedAt: DateTime.now(),
        lastGenerationTimeMs: stopwatch.elapsedMilliseconds,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Generation failed: ${e.toString()}',
      );
    }
  }

  /// Export generated records
  Future<void> exportRecords() async {
    if (!state.canExport) return;

    state = state.copyWith(
      isExporting: true,
      errorMessage: null,
    );

    try {
      final stopwatch = Stopwatch()..start();

      final exportData = await compute(_exportRecordsInIsolate, {
        'records': state.generatedRecords,
        'format': state.exportFormatString,
        'template': state.templateTypeString,
        'includeMetadata': state.includeMetadata,
        'prettify': state.prettifyOutput,
      });

      stopwatch.stop();

      // Save and share file
      final filePath = await _saveAndShareFile(
        exportData,
        state.templateTypeString,
        state.fileExtension,
      );

      state = state.copyWith(
        isExporting: false,
        lastExportPath: filePath,
        lastExportTimeMs: stopwatch.elapsedMilliseconds,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'Export failed: ${e.toString()}',
      );
    }
  }

  /// Copy single record to clipboard
  Future<void> copySingleRecord(Map<String, dynamic> record) async {
    try {
      final json = JSONExporter.exportSingleRecord(record, prettify: true);
      await Clipboard.setData(ClipboardData(text: json));
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Copy failed: ${e.toString()}',
      );
    }
  }

  /// Copy all records to clipboard as JSON
  Future<void> copyAllRecords() async {
    if (state.generatedRecords.isEmpty) return;

    try {
      final json = JSONExporter.exportToJSONArray(
        state.generatedRecords,
        prettify: state.prettifyOutput,
      );
      await Clipboard.setData(ClipboardData(text: json));
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Copy failed: ${e.toString()}',
      );
    }
  }

  /// Clear generated records
  void clearRecords() {
    state = state.copyWith(
      generatedRecords: [],
      lastGeneratedAt: null,
      lastGenerationTimeMs: null,
      lastExportPath: null,
      lastExportTimeMs: null,
      errorMessage: null,
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset to default state
  void reset() {
    state = const FakerState();
  }
}

/// Generate records in isolate for performance
Future<List<Map<String, dynamic>>> _generateRecordsInIsolate(
  Map<String, dynamic> params,
) async {
  final template = params['template'] as String;
  final count = params['count'] as int;
  final seed = params['seed'] as int?;
  final preferredState = params['preferredState'] as String?;

  switch (template) {
    case 'individual':
      return IndividualTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'company':
      return CompanyTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'proprietorship':
      return ProprietorshipTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'partnership':
      return PartnershipTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    case 'trust':
      return TrustTemplate.generateBulk(
        count: count,
        baseSeed: seed,
        preferredState: preferredState,
      );

    default:
      throw ArgumentError('Unknown template: $template');
  }
}

/// Export records in isolate for performance
Future<dynamic> _exportRecordsInIsolate(
  Map<String, dynamic> params,
) async {
  final records = (params['records'] as List).cast<Map<String, dynamic>>();
  final format = params['format'] as String;
  final template = params['template'] as String;
  final includeMetadata = params['includeMetadata'] as bool;
  final prettify = params['prettify'] as bool;

  switch (format) {
    case 'csv':
      return CSVExporter.exportTemplateToCSV(records, template);

    case 'json':
      if (includeMetadata) {
        return JSONExporter.exportTemplateToJSON(
          records,
          template,
          prettify: prettify,
        );
      } else {
        return JSONExporter.exportToJSONArray(
          records,
          prettify: prettify,
        );
      }

    case 'xlsx':
      return XLSXExporter.exportTemplateToXLSX(
        records,
        template,
        includeMetadataSheet: includeMetadata,
      );

    default:
      throw ArgumentError('Unknown format: $format');
  }
}

/// Save file and share it
Future<String> _saveAndShareFile(
  dynamic data,
  String template,
  String extension,
) async {
  final timestamp = DateTime.now().toIso8601String().split('T')[0];
  final filename = 'bharattesting_faker_${template}_$timestamp.$extension';

  if (kIsWeb) {
    // Web: Download directly
    final bytes =
        data is String ? Uint8List.fromList(data.codeUnits) : data as Uint8List;

    // Use web download (would need platform-specific implementation)
    // For now, copy to clipboard as fallback
    if (data is String && extension != 'xlsx') {
      await Clipboard.setData(ClipboardData(text: data));
      return 'Copied to clipboard';
    } else {
      throw UnsupportedError('XLSX download not implemented for web');
    }
  } else {
    // Mobile: Save to documents directory and share
    final documentsDir = await getApplicationDocumentsDirectory();
    final btDir = Directory('${documentsDir.path}/BharatTesting');
    await btDir.create(recursive: true);

    final file = File('${btDir.path}/$filename');

    if (data is String) {
      await file.writeAsString(data);
    } else if (data is Uint8List) {
      await file.writeAsBytes(data);
    } else {
      throw ArgumentError('Unsupported data type for file writing');
    }

    // Share the file
    await Share.shareXFiles([XFile(file.path)]);

    return file.path;
  }
}

class IndividualTemplate {
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    return _LocalTemplateGenerator.generateBulk(
      template: 'individual',
      count: count,
      baseSeed: baseSeed,
      preferredState: preferredState,
    );
  }
}

class CompanyTemplate {
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    return _LocalTemplateGenerator.generateBulk(
      template: 'company',
      count: count,
      baseSeed: baseSeed,
      preferredState: preferredState,
    );
  }
}

class ProprietorshipTemplate {
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    return _LocalTemplateGenerator.generateBulk(
      template: 'proprietorship',
      count: count,
      baseSeed: baseSeed,
      preferredState: preferredState,
    );
  }
}

class PartnershipTemplate {
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    return _LocalTemplateGenerator.generateBulk(
      template: 'partnership',
      count: count,
      baseSeed: baseSeed,
      preferredState: preferredState,
    );
  }
}

class TrustTemplate {
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    return _LocalTemplateGenerator.generateBulk(
      template: 'trust',
      count: count,
      baseSeed: baseSeed,
      preferredState: preferredState,
    );
  }
}

class JSONExporter {
  static String exportSingleRecord(
    Map<String, dynamic> record, {
    bool prettify = false,
  }) {
    return prettify
        ? const JsonEncoder.withIndent('  ').convert(record)
        : jsonEncode(record);
  }

  static String exportToJSONArray(
    List<Map<String, dynamic>> records, {
    bool prettify = false,
  }) {
    return prettify
        ? const JsonEncoder.withIndent('  ').convert(records)
        : jsonEncode(records);
  }

  static String exportTemplateToJSON(
    List<Map<String, dynamic>> records,
    String template, {
    bool prettify = false,
  }) {
    final payload = <String, dynamic>{
      'template': template,
      'generatedAt': DateTime.now().toIso8601String(),
      'recordCount': records.length,
      'records': records,
    };
    return prettify
        ? const JsonEncoder.withIndent('  ').convert(payload)
        : jsonEncode(payload);
  }
}

class CSVExporter {
  static String exportTemplateToCSV(
    List<Map<String, dynamic>> records,
    String template,
  ) {
    if (records.isEmpty) {
      return '';
    }

    final headers = records.first.keys.toList();
    final lines = <String>[
      headers.join(','),
      ...records.map((record) {
        return headers.map((key) => _escapeCsvValue(record[key])).join(',');
      }),
    ];

    return lines.join('\n');
  }

  static String _escapeCsvValue(Object? value) {
    final raw = value?.toString() ?? '';
    if (raw.contains(',') || raw.contains('"') || raw.contains('\n')) {
      final escaped = raw.replaceAll('"', '""');
      return '"$escaped"';
    }
    return raw;
  }
}

class XLSXExporter {
  static Uint8List exportTemplateToXLSX(
    List<Map<String, dynamic>> records,
    String template, {
    bool includeMetadataSheet = true,
  }) {
    final csv = CSVExporter.exportTemplateToCSV(records, template);
    return Uint8List.fromList(utf8.encode(csv));
  }
}

class _LocalTemplateGenerator {
  static const _firstNames = <String>[
    'Aarav',
    'Ananya',
    'Vihaan',
    'Aditi',
    'Arjun',
    'Isha',
    'Kabir',
    'Meera',
    'Rohan',
    'Diya',
    'Ravi',
    'Sneha',
  ];
  static const _lastNames = <String>[
    'Sharma',
    'Verma',
    'Patel',
    'Gupta',
    'Mehta',
    'Nair',
    'Reddy',
    'Singh',
    'Khan',
    'Iyer',
    'Das',
    'Kapoor',
  ];
  static const _cities = <String>[
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Hyderabad',
    'Pune',
    'Chennai',
    'Kolkata',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
    'Kochi',
    'Indore',
  ];
  static const _states = <String>[
    'Maharashtra',
    'Delhi',
    'Karnataka',
    'Telangana',
    'Tamil Nadu',
    'Gujarat',
    'Rajasthan',
    'Uttar Pradesh',
    'West Bengal',
    'Kerala',
  ];
  static const _upiHandles = <String>[
    'okaxis',
    'okhdfcbank',
    'oksbi',
    'paytm',
    'ibl',
    'ybl',
  ];
  static const _banks = <String>[
    'HDFC Bank',
    'ICICI Bank',
    'State Bank of India',
    'Axis Bank',
    'Kotak Mahindra Bank',
    'Punjab National Bank',
  ];
  static const _stateCodes = <String>[
    '27',
    '07',
    '29',
    '36',
    '33',
    '24',
    '08',
    '09',
    '19',
    '32',
  ];

  static List<Map<String, dynamic>> generateBulk({
    required String template,
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    final seedBase = baseSeed ?? DateTime.now().millisecondsSinceEpoch;
    return List<Map<String, dynamic>>.generate(count, (index) {
      final random = math.Random(seedBase + index);
      return _generateRecord(
        random: random,
        index: index + 1,
        template: template,
        preferredState: preferredState,
      );
    });
  }

  static Map<String, dynamic> _generateRecord({
    required math.Random random,
    required int index,
    required String template,
    required String? preferredState,
  }) {
    final firstName = _firstNames[random.nextInt(_firstNames.length)];
    final lastName = _lastNames[random.nextInt(_lastNames.length)];
    final name = '$firstName $lastName';
    final state = preferredState ?? _states[random.nextInt(_states.length)];
    final stateCode = _stateCodes[random.nextInt(_stateCodes.length)];
    final city = _cities[random.nextInt(_cities.length)];
    final bank = _banks[random.nextInt(_banks.length)];
    final ifsc = _generateIfsc(random);
    final pan = _generatePan(random, template);
    final gstin = _generateGstin(random, pan, stateCode);
    final upi = _generateUpi(random, name);

    final base = <String, dynamic>{
      'index': index,
      'name': name,
      'state': state,
      'city': city,
      'pan': pan,
      'address': '${100 + random.nextInt(900)} Test Street, $city, $state',
      'pin_code': _digits(random, 6),
      'ifsc': ifsc,
      'bank_name': bank,
      'upi_id': upi,
    };

    switch (template) {
      case 'individual':
        return <String, dynamic>{
          ...base,
          'aadhaar': _digits(random, 12),
        };
      case 'company':
        return <String, dynamic>{
          ...base,
          'company_name': '${lastName} Technologies Pvt Ltd',
          'gstin': gstin,
          'cin': _generateCin(random, stateCode),
          'tan': _generateTan(random),
          'udyam': _generateUdyam(random, stateCode),
        };
      case 'proprietorship':
        return <String, dynamic>{
          ...base,
          'gstin': gstin,
          'udyam': _generateUdyam(random, stateCode),
          'tan': _generateTan(random),
        };
      case 'partnership':
        return <String, dynamic>{
          ...base,
          'gstin': gstin,
          'tan': _generateTan(random),
          'partners': '${_firstNames[random.nextInt(_firstNames.length)]} & '
              '${_firstNames[random.nextInt(_firstNames.length)]}',
        };
      case 'trust':
      default:
        return <String, dynamic>{
          ...base,
          'gstin': gstin,
          'tan': _generateTan(random),
          'registration': 'REG-${_digits(random, 8)}',
        };
    }
  }

  static String _generatePan(math.Random random, String template) {
    final prefix = switch (template) {
      'company' => 'C',
      'trust' => 'A',
      _ => 'P',
    };
    return '$prefix${_letters(random, 4)}${_digits(random, 4)}${_letters(random, 1)}';
  }

  static String _generateGstin(
      math.Random random, String pan, String stateCode) {
    return '$stateCode$pan${random.nextInt(9) + 1}Z${_letters(random, 1)}';
  }

  static String _generateCin(math.Random random, String stateCode) {
    final year = 1995 + random.nextInt(31);
    return 'U${stateCode}${_digits(random, 5)}$year${_letters(random, 3)}${_digits(random, 6)}';
  }

  static String _generateTan(math.Random random) {
    return '${_letters(random, 4)}${_digits(random, 5)}${_letters(random, 1)}';
  }

  static String _generateIfsc(math.Random random) {
    return '${_letters(random, 4)}0${_letters(random, 6)}';
  }

  static String _generateUpi(math.Random random, String name) {
    final handle = _upiHandles[random.nextInt(_upiHandles.length)];
    final user = name.toLowerCase().replaceAll(' ', '.') + _digits(random, 2);
    return '$user@$handle';
  }

  static String _generateUdyam(math.Random random, String stateCode) {
    return 'UDYAM-$stateCode-${_digits(random, 4)}-${_digits(random, 7)}';
  }

  static String _digits(math.Random random, int length) {
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(random.nextInt(10));
    }
    return buffer.toString();
  }

  static String _letters(math.Random random, int length) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(alphabet[random.nextInt(alphabet.length)]);
    }
    return buffer.toString();
  }
}

/// Provider for available Indian states
@riverpod
List<String> availableStates(AvailableStatesRef ref) {
  return [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep',
    'Puducherry',
  ];
}
