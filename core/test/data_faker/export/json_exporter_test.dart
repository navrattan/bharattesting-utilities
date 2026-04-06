import 'dart:convert';
import 'package:test/test.dart';
import 'package:core/src/data_faker/export/json_exporter.dart';
import 'package:core/src/data_faker/templates/individual_template.dart';
import 'package:core/src/data_faker/templates/company_template.dart';

void main() {
  group('JSONExporter', () {
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

    group('exportToJSON', () {
      test('exports valid JSON with metadata', () {
        final json = JSONExporter.exportToJSON(testRecords);

        expect(json, isNotEmpty);
        expect(JSONExporter.validateJSONOutput(json), isTrue);

        final decoded = jsonDecode(json) as Map<String, dynamic>;

        expect(decoded, containsKey('metadata'));
        expect(decoded, containsKey('records'));

        final metadata = decoded['metadata'] as Map<String, dynamic>;
        expect(metadata, containsKey('export_info'));
        expect(metadata, containsKey('statistics'));

        final records = decoded['records'] as List;
        expect(records.length, equals(testRecords.length));
      });

      test('exports valid JSON without metadata', () {
        final json = JSONExporter.exportToJSON(testRecords, includeMetadata: false);

        expect(json, isNotEmpty);
        expect(JSONExporter.validateJSONOutput(json), isTrue);

        final decoded = jsonDecode(json) as Map<String, dynamic>;

        expect(decoded, containsKey('records'));
        expect(decoded, isNot(containsKey('metadata')));

        final records = decoded['records'] as List;
        expect(records.length, equals(testRecords.length));
      });

      test('exports minified JSON when prettify is false', () {
        final prettyJson = JSONExporter.exportToJSON(testRecords, prettify: true);
        final minifiedJson = JSONExporter.exportToJSON(testRecords, prettify: false);

        expect(prettyJson.length, greaterThan(minifiedJson.length));
        expect(prettyJson, contains('\n'));
        expect(minifiedJson, isNot(contains('\n')));

        // Both should decode to same data
        expect(jsonDecode(prettyJson), equals(jsonDecode(minifiedJson)));
      });

      test('handles empty records list', () {
        final json = JSONExporter.exportToJSON([]);

        expect(json, isNotEmpty);
        expect(JSONExporter.validateJSONOutput(json), isTrue);

        final decoded = jsonDecode(json) as Map<String, dynamic>;
        final records = decoded['records'] as List;
        expect(records, isEmpty);

        final metadata = decoded['metadata'] as Map<String, dynamic>;
        final exportInfo = metadata['export_info'] as Map<String, dynamic>;
        expect(exportInfo['total_records'], equals(0));
      });
    });

    group('exportToJSONArray', () {
      test('exports records as JSON array', () {
        final json = JSONExporter.exportToJSONArray(testRecords);

        expect(json, isNotEmpty);
        expect(JSONExporter.validateJSONOutput(json), isTrue);

        final decoded = jsonDecode(json) as List;
        expect(decoded.length, equals(testRecords.length));

        final firstRecord = decoded[0] as Map<String, dynamic>;
        expect(firstRecord['template_type'], equals('individual'));
        expect(firstRecord['pan'], equals('ABCDE1234F'));
      });

      test('exports empty array for empty records', () {
        final json = JSONExporter.exportToJSONArray([]);

        expect(json, equals('[]'));
        expect(JSONExporter.validateJSONOutput(json), isTrue);
      });

      test('respects prettify parameter', () {
        final prettyJson = JSONExporter.exportToJSONArray(testRecords, prettify: true);
        final minifiedJson = JSONExporter.exportToJSONArray(testRecords, prettify: false);

        expect(prettyJson.length, greaterThan(minifiedJson.length));
        expect(prettyJson, contains('\n'));
        expect(minifiedJson, isNot(contains('\n')));
      });
    });

    group('exportSingleRecord', () {
      test('exports single record as JSON object', () {
        final record = testRecords[0];
        final json = JSONExporter.exportSingleRecord(record);

        expect(json, isNotEmpty);
        expect(JSONExporter.validateJSONOutput(json), isTrue);

        final decoded = jsonDecode(json) as Map<String, dynamic>;
        expect(decoded['template_type'], equals('individual'));
        expect(decoded['pan'], equals('ABCDE1234F'));
      });

      test('respects prettify parameter for single record', () {
        final record = testRecords[0];
        final prettyJson = JSONExporter.exportSingleRecord(record, prettify: true);
        final minifiedJson = JSONExporter.exportSingleRecord(record, prettify: false);

        expect(prettyJson.length, greaterThan(minifiedJson.length));
        expect(jsonDecode(prettyJson), equals(jsonDecode(minifiedJson)));
      });
    });

    group('exportTemplateToJSON', () {
      test('exports template with specific structure', () {
        final individualRecords = IndividualTemplate.generateBulk(
          count: 3,
          baseSeed: 1000,
        );

        final json = JSONExporter.exportTemplateToJSON(individualRecords, 'individual');

        expect(json, isNotEmpty);
        expect(JSONExporter.validateJSONOutput(json), isTrue);

        final decoded = jsonDecode(json) as Map<String, dynamic>;

        expect(decoded, containsKey('template_info'));
        expect(decoded, containsKey('metadata'));
        expect(decoded, containsKey('records'));

        final templateInfo = decoded['template_info'] as Map<String, dynamic>;
        expect(templateInfo['type'], equals('individual'));
        expect(templateInfo['entity_type'], equals('individual'));
        expect(templateInfo['business_identifiers'], isFalse);

        final identifiers = templateInfo['identifiers'] as List;
        expect(identifiers, contains('pan'));
        expect(identifiers, contains('aadhaar'));
      });

      test('exports company template with business identifiers', () {
        final companyRecords = CompanyTemplate.generateBulk(
          count: 2,
          baseSeed: 2000,
        );

        final json = JSONExporter.exportTemplateToJSON(companyRecords, 'company');

        expect(json, isNotEmpty);
        final decoded = jsonDecode(json) as Map<String, dynamic>;

        final templateInfo = decoded['template_info'] as Map<String, dynamic>;
        expect(templateInfo['type'], equals('company'));
        expect(templateInfo['business_identifiers'], isTrue);

        final identifiers = templateInfo['identifiers'] as List;
        expect(identifiers, contains('pan'));
        expect(identifiers, contains('gstin'));
        expect(identifiers, contains('cin'));
      });
    });

    group('utility methods', () {
      test('generateFilename creates valid filename', () {
        final filename1 = JSONExporter.generateFilename('individual');
        final filename2 = JSONExporter.generateFilename('company',
            prefix: 'custom', includeMetadata: false);

        expect(filename1, contains('bharattesting_faker'));
        expect(filename1, contains('individual'));
        expect(filename1, contains('with_metadata'));
        expect(filename1, endsWith('.json'));

        expect(filename2, contains('custom'));
        expect(filename2, contains('company'));
        expect(filename2, contains('records_only'));
        expect(filename2, endsWith('.json'));
      });

      test('validateJSONOutput validates correctly', () {
        final validJSON = JSONExporter.exportToJSON(testRecords);
        expect(JSONExporter.validateJSONOutput(validJSON), isTrue);

        expect(JSONExporter.validateJSONOutput(''), isFalse);
        expect(JSONExporter.validateJSONOutput('invalid json'), isFalse);
        expect(JSONExporter.validateJSONOutput('{"incomplete": '), isFalse);
        expect(JSONExporter.validateJSONOutput('[]'), isTrue);
        expect(JSONExporter.validateJSONOutput('{}'), isTrue);
      });

      test('getRecordCount returns correct count', () {
        final jsonWithMetadata = JSONExporter.exportToJSON(testRecords);
        final jsonArray = JSONExporter.exportToJSONArray(testRecords);

        expect(JSONExporter.getRecordCount(jsonWithMetadata), equals(testRecords.length));
        expect(JSONExporter.getRecordCount(jsonArray), equals(testRecords.length));

        expect(JSONExporter.getRecordCount('[]'), equals(0));
        expect(JSONExporter.getRecordCount('invalid'), equals(0));
      });

      test('extractRecords extracts records correctly', () {
        final jsonWithMetadata = JSONExporter.exportToJSON(testRecords);
        final jsonArray = JSONExporter.exportToJSONArray(testRecords);

        final extractedFromMetadata = JSONExporter.extractRecords(jsonWithMetadata);
        final extractedFromArray = JSONExporter.extractRecords(jsonArray);

        expect(extractedFromMetadata.length, equals(testRecords.length));
        expect(extractedFromArray.length, equals(testRecords.length));

        expect(extractedFromMetadata[0]['template_type'], equals('individual'));
        expect(extractedFromArray[1]['template_type'], equals('company'));

        expect(JSONExporter.extractRecords('invalid'), isEmpty);
      });

      test('prettifyJSON and minifyJSON work correctly', () {
        final minifiedInput = '{"key":"value","array":[1,2,3]}';
        final prettified = JSONExporter.prettifyJSON(minifiedInput);
        final minified = JSONExporter.minifyJSON(prettified);

        expect(prettified, contains('\n'));
        expect(prettified.length, greaterThan(minifiedInput.length));

        expect(minified, isNot(contains('\n')));
        expect(jsonDecode(minified), equals(jsonDecode(prettified)));

        // Should handle invalid JSON gracefully
        expect(JSONExporter.prettifyJSON('invalid'), equals('invalid'));
        expect(JSONExporter.minifyJSON('invalid'), equals('invalid'));
      });
    });

    group('metadata generation', () {
      test('generates comprehensive metadata', () {
        final mixedRecords = [
          ...IndividualTemplate.generateBulk(count: 3, baseSeed: 1000),
          ...CompanyTemplate.generateBulk(count: 2, baseSeed: 2000),
        ];

        final json = JSONExporter.exportToJSON(mixedRecords);
        final decoded = jsonDecode(json) as Map<String, dynamic>;

        final metadata = decoded['metadata'] as Map<String, dynamic>;
        final exportInfo = metadata['export_info'] as Map<String, dynamic>;
        final statistics = metadata['statistics'] as Map<String, dynamic>;

        expect(exportInfo['total_records'], equals(5));
        expect(exportInfo['generator'], equals('BharatTesting Data Faker'));
        expect(exportInfo['website'], equals('https://bharattesting.com'));

        final templateTypes = exportInfo['template_types'] as List;
        expect(templateTypes, contains('individual'));
        expect(templateTypes, contains('company'));

        final templateDist = statistics['template_distribution'] as Map;
        expect(templateDist['individual'], equals(3));
        expect(templateDist['company'], equals(2));

        expect(statistics['unique_templates'], equals(2));
        expect(statistics, containsKey('state_distribution'));
      });

      test('handles empty metadata generation', () {
        final json = JSONExporter.exportToJSON([]);
        final decoded = jsonDecode(json) as Map<String, dynamic>;

        final metadata = decoded['metadata'] as Map<String, dynamic>;
        final exportInfo = metadata['export_info'] as Map<String, dynamic>;

        expect(exportInfo['total_records'], equals(0));
        expect(exportInfo['template_types'], isEmpty);
      });
    });

    group('performance tests', () {
      test('handles large datasets efficiently', () {
        final largeDataset = IndividualTemplate.generateBulk(
          count: 1000,
          baseSeed: 3000,
        );

        final stopwatch = Stopwatch()..start();
        final json = JSONExporter.exportToJSON(largeDataset);
        stopwatch.stop();

        expect(json, isNotEmpty);
        expect(JSONExporter.validateJSONOutput(json), isTrue);
        expect(JSONExporter.getRecordCount(json), equals(1000));

        // Should complete in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));

        print('Exported 1000 records to JSON in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('minified vs prettified size comparison', () {
        final records = IndividualTemplate.generateBulk(count: 100, baseSeed: 4000);

        final prettified = JSONExporter.exportToJSON(records, prettify: true);
        final minified = JSONExporter.exportToJSON(records, prettify: false);

        print('Prettified size: ${prettified.length} bytes');
        print('Minified size: ${minified.length} bytes');
        print('Size reduction: ${((prettified.length - minified.length) / prettified.length * 100).toStringAsFixed(1)}%');

        expect(minified.length, lessThan(prettified.length));
      });
    });
  });
}