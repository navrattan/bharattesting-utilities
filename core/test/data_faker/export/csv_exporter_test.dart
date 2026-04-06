import 'package:test/test.dart';
import 'package:core/src/data_faker/export/csv_exporter.dart';
import 'package:core/src/data_faker/templates/individual_template.dart';
import 'package:core/src/data_faker/templates/company_template.dart';

void main() {
  group('CSVExporter', () {
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

    group('exportToCSV', () {
      test('exports valid CSV with headers', () {
        final csv = CSVExporter.exportToCSV(testRecords);

        expect(csv, isNotEmpty);
        expect(csv, contains('aadhaar'));
        expect(csv, contains('gstin'));
        expect(csv, contains('pan'));
        expect(csv, contains('state'));
        expect(csv, contains('template_type'));

        // Should contain data values
        expect(csv, contains('ABCDE1234F'));
        expect(csv, contains('29CDEFG5678H1Z5'));
        expect(csv, contains('Karnataka'));
      });

      test('handles empty records list', () {
        final csv = CSVExporter.exportToCSV([]);
        expect(csv, isEmpty);
      });

      test('handles complex data types in records', () {
        final recordsWithComplexData = [
          {
            'template_type': 'partnership',
            'pan': 'ABCDE1234F',
            'partners': [
              {'name': 'Partner 1', 'share': '60.0'},
              {'name': 'Partner 2', 'share': '40.0'},
            ],
            'metadata': {'key': 'value'},
          },
        ];

        final csv = CSVExporter.exportToCSV(recordsWithComplexData);

        expect(csv, isNotEmpty);
        expect(csv, contains('partners'));
        expect(csv, contains('Partner 1'));
        expect(csv, contains('metadata'));
      });

      test('sorts columns alphabetically', () {
        final csv = CSVExporter.exportToCSV(testRecords);
        final lines = csv.split('\n');
        final headers = lines[0].split(',');

        // Headers should be sorted
        final sortedHeaders = List<String>.from(headers)..sort();
        expect(headers, equals(sortedHeaders));
      });
    });

    group('exportToCSVWithColumns', () {
      test('exports only specified columns', () {
        final columns = ['template_type', 'pan', 'state'];
        final csv = CSVExporter.exportToCSVWithColumns(testRecords, columns);

        expect(csv, isNotEmpty);

        final lines = csv.split('\n');
        final headers = lines[0].split(',');

        expect(headers.length, equals(3));
        expect(headers, contains('template_type'));
        expect(headers, contains('pan'));
        expect(headers, contains('state'));

        // Should not contain other columns
        expect(csv, isNot(contains('aadhaar')));
        expect(csv, isNot(contains('gstin')));
      });

      test('handles missing columns gracefully', () {
        final columns = ['template_type', 'nonexistent_column', 'pan'];
        final csv = CSVExporter.exportToCSVWithColumns(testRecords, columns);

        expect(csv, isNotEmpty);

        final lines = csv.split('\n');
        expect(lines.length, greaterThan(1));

        // Data rows should have empty values for missing columns
        final firstDataRow = lines[1].split(',');
        expect(firstDataRow.length, equals(3));
      });

      test('returns empty string for empty records or columns', () {
        expect(CSVExporter.exportToCSVWithColumns([], ['pan']), isEmpty);
        expect(CSVExporter.exportToCSVWithColumns(testRecords, []), isEmpty);
      });
    });

    group('exportTemplateToCSV', () {
      test('exports individual template with correct column order', () {
        final individualRecords = IndividualTemplate.generateBulk(
          count: 5,
          baseSeed: 1000,
        );

        final csv = CSVExporter.exportTemplateToCSV(individualRecords, 'individual');

        expect(csv, isNotEmpty);

        final lines = csv.split('\n');
        final headers = lines[0].split(',');

        // Should have expected individual template columns
        expect(headers, contains('template_type'));
        expect(headers, contains('pan'));
        expect(headers, contains('aadhaar'));
        expect(headers, contains('pin_code'));
        expect(headers, contains('state'));
        expect(headers, contains('address'));
        expect(headers, contains('upi_id'));
      });

      test('exports company template with correct column order', () {
        final companyRecords = CompanyTemplate.generateBulk(
          count: 3,
          baseSeed: 2000,
        );

        final csv = CSVExporter.exportTemplateToCSV(companyRecords, 'company');

        expect(csv, isNotEmpty);

        final lines = csv.split('\n');
        final headers = lines[0].split(',');

        // Should have expected company template columns
        expect(headers, contains('template_type'));
        expect(headers, contains('pan'));
        expect(headers, contains('gstin'));
        expect(headers, contains('cin'));
        expect(headers, contains('tan'));
        expect(headers, contains('ifsc'));
        expect(headers, contains('udyam'));
      });

      test('falls back to general export for unknown template', () {
        final csv1 = CSVExporter.exportTemplateToCSV(testRecords, 'unknown');
        final csv2 = CSVExporter.exportToCSV(testRecords);

        expect(csv1, equals(csv2));
      });
    });

    group('utility methods', () {
      test('generateFilename creates valid filename', () {
        final filename1 = CSVExporter.generateFilename('individual');
        final filename2 = CSVExporter.generateFilename('company', prefix: 'custom');

        expect(filename1, contains('bharattesting_faker'));
        expect(filename1, contains('individual'));
        expect(filename1, endsWith('.csv'));

        expect(filename2, contains('custom'));
        expect(filename2, contains('company'));
        expect(filename2, endsWith('.csv'));
      });

      test('validateCSVOutput validates correctly', () {
        final validCSV = CSVExporter.exportToCSV(testRecords);
        expect(CSVExporter.validateCSVOutput(validCSV), isTrue);

        expect(CSVExporter.validateCSVOutput(''), isFalse);
        expect(CSVExporter.validateCSVOutput('just_one_line'), isFalse);
      });

      test('getColumnCount returns correct count', () {
        final csv = CSVExporter.exportToCSV(testRecords);
        final columnCount = CSVExporter.getColumnCount(csv);

        expect(columnCount, greaterThan(0));
        expect(columnCount, equals(testRecords.expand((r) => r.keys).toSet().length));
      });

      test('getRowCount returns correct count', () {
        final csv = CSVExporter.exportToCSV(testRecords);
        final rowCount = CSVExporter.getRowCount(csv);

        expect(rowCount, equals(testRecords.length));
      });

      test('getColumnCount and getRowCount handle empty input', () {
        expect(CSVExporter.getColumnCount(''), equals(0));
        expect(CSVExporter.getRowCount(''), equals(0));
      });
    });

    group('data integrity', () {
      test('round-trip preserves data integrity', () {
        final originalRecords = IndividualTemplate.generateBulk(
          count: 10,
          baseSeed: 3000,
        );

        final csv = CSVExporter.exportToCSV(originalRecords);

        // Basic integrity checks
        expect(csv, isNotEmpty);
        expect(CSVExporter.validateCSVOutput(csv), isTrue);

        final rowCount = CSVExporter.getRowCount(csv);
        expect(rowCount, equals(originalRecords.length));

        // Check that all PANs are present
        for (final record in originalRecords) {
          final pan = record['pan'] as String;
          expect(csv, contains(pan));
        }
      });

      test('handles special characters in data', () {
        final recordsWithSpecialChars = [
          {
            'template_type': 'test',
            'field_with_comma': 'value,with,commas',
            'field_with_quotes': 'value "with" quotes',
            'field_with_newlines': 'value\nwith\nnewlines',
          },
        ];

        final csv = CSVExporter.exportToCSV(recordsWithSpecialChars);

        expect(csv, isNotEmpty);
        expect(CSVExporter.validateCSVOutput(csv), isTrue);

        // CSV should still be parseable despite special characters
        final rowCount = CSVExporter.getRowCount(csv);
        expect(rowCount, equals(1));
      });

      test('handles large datasets efficiently', () {
        final largeDataset = IndividualTemplate.generateBulk(
          count: 1000,
          baseSeed: 4000,
        );

        final stopwatch = Stopwatch()..start();
        final csv = CSVExporter.exportToCSV(largeDataset);
        stopwatch.stop();

        expect(csv, isNotEmpty);
        expect(CSVExporter.validateCSVOutput(csv), isTrue);
        expect(CSVExporter.getRowCount(csv), equals(1000));

        // Should complete in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));

        print('Exported 1000 records to CSV in ${stopwatch.elapsedMilliseconds}ms');
      });
    });
  });
}