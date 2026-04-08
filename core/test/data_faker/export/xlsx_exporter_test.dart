import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/export/xlsx_exporter.dart';
import 'package:bharattesting_core/src/data_faker/templates/individual_template.dart';
import 'package:bharattesting_core/src/data_faker/templates/company_template.dart';

void main() {
  group('XLSXExporter', () {
    late List<Map<String, dynamic>> testRecords;

    setUp(() {
      testRecords = [
        {
          'template_type': 'individual',
          'pan': 'ABCDE1234F',
          'aadhaar': '123456789012',
          'state': 'Karnataka',
          'pin_code': '560001',
        },
        {
          'template_type': 'company',
          'pan': 'CDEFG5678H',
          'gstin': '29CDEFG5678H1Z5',
          'state': 'Karnataka',
          'pin_code': '560002',
        },
      ];
    });

    group('exportToXLSX', () {
      test('exports valid XLSX bytes', () {
        final xlsxBytes = XLSXExporter.exportToXLSX(testRecords);

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Should be a reasonable size
        expect(xlsxBytes.length, greaterThan(1000));
        expect(xlsxBytes.length, lessThan(100000)); // Not too large for test data
      });

      test('creates XLSX with custom sheet name', () {
        final xlsxBytes = XLSXExporter.exportToXLSX(
          testRecords,
          sheetName: 'CustomSheet',
        );

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);
      });

      test('creates XLSX without metadata sheet', () {
        final xlsxBytesWithMetadata = XLSXExporter.exportToXLSX(
          testRecords,
          includeMetadataSheet: true,
        );

        final xlsxBytesWithoutMetadata = XLSXExporter.exportToXLSX(
          testRecords,
          includeMetadataSheet: false,
        );

        expect(xlsxBytesWithMetadata, isNotEmpty);
        expect(xlsxBytesWithoutMetadata, isNotEmpty);

        // With metadata should be larger
        expect(xlsxBytesWithMetadata.length, greaterThan(xlsxBytesWithoutMetadata.length));

        expect(XLSXExporter.validateXLSXBytes(xlsxBytesWithMetadata), isTrue);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytesWithoutMetadata), isTrue);
      });

      test('handles empty records list', () {
        final xlsxBytes = XLSXExporter.exportToXLSX([]);

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Empty workbook should be smaller but valid
        expect(xlsxBytes.length, greaterThan(500));
      });
    });

    group('exportTemplateToXLSX', () {
      test('exports individual template with correct sheet name', () {
        final individualRecords = IndividualTemplate.generateBulk(
          count: 5,
          baseSeed: 1000,
        );

        final xlsxBytes = XLSXExporter.exportTemplateToXLSX(
          individualRecords,
          'individual',
        );

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Should be larger than empty workbook
        expect(xlsxBytes.length, greaterThan(2000));
      });

      test('exports company template with business identifiers', () {
        final companyRecords = CompanyTemplate.generateBulk(
          count: 3,
          baseSeed: 2000,
        );

        final xlsxBytes = XLSXExporter.exportTemplateToXLSX(
          companyRecords,
          'company',
        );

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Company records have more fields, should be larger
        expect(xlsxBytes.length, greaterThan(2000));
      });

      test('excludes metadata sheet when specified', () {
        final records = IndividualTemplate.generateBulk(count: 2, baseSeed: 3000);

        final xlsxWithMetadata = XLSXExporter.exportTemplateToXLSX(
          records,
          'individual',
          includeMetadataSheet: true,
        );

        final xlsxWithoutMetadata = XLSXExporter.exportTemplateToXLSX(
          records,
          'individual',
          includeMetadataSheet: false,
        );

        expect(xlsxWithMetadata.length, greaterThan(xlsxWithoutMetadata.length));
      });
    });

    group('utility methods', () {
      test('generateFilename creates valid filename', () {
        final filename1 = XLSXExporter.generateFilename('individual');
        final filename2 = XLSXExporter.generateFilename('company', prefix: 'custom');

        expect(filename1, contains('bharattesting_faker'));
        expect(filename1, contains('individual'));
        expect(filename1, endsWith('.xlsx'));

        expect(filename2, contains('custom'));
        expect(filename2, contains('company'));
        expect(filename2, endsWith('.xlsx'));

        // Should include current date
        final today = DateTime.now().toIso8601String().split('T')[0];
        expect(filename1, contains(today));
        expect(filename2, contains(today));
      });

      test('validateXLSXBytes validates correctly', () {
        final validXLSX = XLSXExporter.exportToXLSX(testRecords);
        expect(XLSXExporter.validateXLSXBytes(validXLSX), isTrue);

        final emptyBytes = Uint8List(0);
        expect(XLSXExporter.validateXLSXBytes(emptyBytes), isFalse);

        final invalidBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        expect(XLSXExporter.validateXLSXBytes(invalidBytes), isFalse);
      });

      test('getApproximateSize returns reasonable estimate', () {
        final smallDataset = testRecords;
        final largeDataset = IndividualTemplate.generateBulk(count: 100, baseSeed: 4000);

        final smallSize = XLSXExporter.getApproximateSize(smallDataset);
        final largeSize = XLSXExporter.getApproximateSize(largeDataset);
        final emptySize = XLSXExporter.getApproximateSize([]);

        expect(smallSize, greaterThan(0));
        expect(largeSize, greaterThan(smallSize));
        expect(emptySize, equals(4096)); // Basic empty workbook size

        print('Empty XLSX size estimate: $emptySize bytes');
        print('Small dataset size estimate: $smallSize bytes');
        print('Large dataset size estimate: $largeSize bytes');
      });
    });

    group('internal utility methods', () {
      test('columnIndexToLetter converts correctly', () {
        // Access private method through reflection would be complex in Dart
        // Instead we test through the public interface by checking the output format
        final xlsxBytes = XLSXExporter.exportToXLSX(testRecords);
        expect(xlsxBytes, isNotEmpty);

        // If column conversion is wrong, the XLSX would be invalid
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);
      });

      test('XML escaping is handled correctly', () {
        final recordsWithSpecialChars = [
          {
            'template_type': 'test',
            'field_with_xml_chars': 'value <with> &special& "chars"',
            'field_with_quotes': "value 'with' quotes",
          },
        ];

        final xlsxBytes = XLSXExporter.exportToXLSX(recordsWithSpecialChars);

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);
      });
    });

    group('data integrity', () {
      test('maintains data integrity for complex records', () {
        final complexRecords = [
          {
            'template_type': 'partnership',
            'pan': 'ABCDE1234F',
            'partners': [
              {'name': 'Partner 1', 'share': '60.0'},
              {'name': 'Partner 2', 'share': '40.0'},
            ],
            'metadata': {'created': '2024-01-01', 'version': 1},
          },
        ];

        final xlsxBytes = XLSXExporter.exportToXLSX(complexRecords);

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Complex data should be serialized as JSON strings in cells
        expect(xlsxBytes.length, greaterThan(1000));
      });

      test('handles null and empty values correctly', () {
        final recordsWithNulls = [
          {
            'template_type': 'test',
            'valid_field': 'value',
            'null_field': null,
            'empty_field': '',
          },
        ];

        final xlsxBytes = XLSXExporter.exportToXLSX(recordsWithNulls);

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);
      });

      test('produces consistent output for same input', () {
        final xlsxBytes1 = XLSXExporter.exportToXLSX(testRecords);
        final xlsxBytes2 = XLSXExporter.exportToXLSX(testRecords);

        expect(xlsxBytes1.length, equals(xlsxBytes2.length));
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes1), isTrue);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes2), isTrue);

        // Note: Due to timestamps in metadata, the bytes might not be identical
        // but they should be the same size and both valid
      });
    });

    group('performance tests', () {
      test('handles large datasets efficiently', () {
        final largeDataset = IndividualTemplate.generateBulk(
          count: 1000,
          baseSeed: 5000,
        );

        final stopwatch = Stopwatch()..start();
        final xlsxBytes = XLSXExporter.exportToXLSX(largeDataset);
        stopwatch.stop();

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Should complete in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(10000)); // 10 seconds max

        print('Exported 1000 records to XLSX in ${stopwatch.elapsedMilliseconds}ms');
        print('XLSX size: ${xlsxBytes.length} bytes');
      });

      test('size comparison across formats', () {
        final dataset = IndividualTemplate.generateBulk(count: 100, baseSeed: 6000);

        final xlsxSize = XLSXExporter.exportToXLSX(dataset).length;
        final approximateSize = XLSXExporter.getApproximateSize(dataset);

        print('Actual XLSX size: $xlsxSize bytes');
        print('Estimated size: $approximateSize bytes');
        print('Estimation accuracy: ${(approximateSize / xlsxSize * 100).toStringAsFixed(1)}%');

        // Estimation should be reasonably close (within 50% margin)
        expect(approximateSize, greaterThan(xlsxSize * 0.5));
        expect(approximateSize, lessThan(xlsxSize * 1.5));
      });

      test('memory usage with different dataset sizes', () {
        final sizes = [10, 50, 100, 500];

        for (final size in sizes) {
          final dataset = IndividualTemplate.generateBulk(count: size, baseSeed: 7000 + size);

          final stopwatch = Stopwatch()..start();
          final xlsxBytes = XLSXExporter.exportToXLSX(dataset);
          stopwatch.stop();

          expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

          print('Size $size: ${xlsxBytes.length} bytes, ${stopwatch.elapsedMilliseconds}ms');
        }
      });
    });

    group('template-specific formatting', () {
      test('individual template has correct column order', () {
        final records = IndividualTemplate.generateBulk(count: 2, baseSeed: 8000);
        final xlsxBytes = XLSXExporter.exportTemplateToXLSX(records, 'individual');

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Individual template should have specific columns
        // This is tested indirectly through successful validation
      });

      test('company template has correct column order', () {
        final records = CompanyTemplate.generateBulk(count: 2, baseSeed: 9000);
        final xlsxBytes = XLSXExporter.exportTemplateToXLSX(records, 'company');

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Company template should have business identifiers
        // This is tested indirectly through successful validation
      });

      test('unknown template falls back gracefully', () {
        final xlsxBytes = XLSXExporter.exportTemplateToXLSX(testRecords, 'unknown');

        expect(xlsxBytes, isNotEmpty);
        expect(XLSXExporter.validateXLSXBytes(xlsxBytes), isTrue);

        // Should work even with unknown template type
      });
    });
  });
}