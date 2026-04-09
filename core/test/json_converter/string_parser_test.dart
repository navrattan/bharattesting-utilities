import 'package:test/test.dart';
import 'package:bharattesting_core/src/json_converter/string_parser.dart';

void main() {
  group('StringParser', () {
    group('parseAny', () {
      test('detects and parses JSON format', () {
        const input = '{"name": "Alice", "age": 30}';
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals(30));
        expect(result.confidence, equals(1.0));
      });

      test('detects malformed JSON with lower confidence', () {
        const input = '{"name": "Alice", "age": 30'; // Missing closing brace
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.confidence, lessThan(0.5));
      });

      test('detects CSV format', () {
        const input = 'name,age\nAlice,30\nBob,25';
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.csv));
        expect(result.confidence, greaterThanOrEqualTo(0.5));
      });

      test('detects XML format', () {
        const input = '<?xml version="1.0"?><user><name>Alice</name></user>';
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.xml));
        expect(result.confidence, equals(1.0));
      });

      test('detects YAML format', () {
        const input = 'name: Alice\nage: 30';
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.yaml));
        expect(result.confidence, greaterThan(0.4));
      });

      test('detects URL-encoded format', () {
        const input = 'name=Alice&age=30';
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.urlEncoded));
        expect(result.confidence, greaterThan(0.5));
      });

      test('detects INI format', () {
        const input = '[user]\nname=Alice\nage=30';
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.ini));
        expect(result.confidence, greaterThan(0.5));
      });

      test('handles unrecognized format', () {
        const input = 'This is just a regular string with no special structure.';
        final result = StringParser.parseAny(input);

        expect(result.detectedFormat, equals(InputFormat.unknown));
        expect(result.confidence, equals(0.0));
      });
    });

    group('parseAs', () {
      test('parses as JSON when format specified', () {
        const input = '{"key": "value"}';
        final result = StringParser.parseAs(input, InputFormat.json);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.data['key'], equals('value'));
      });

      test('parses as CSV when format specified', () {
        const input = 'id,name\n1,Alice';
        final result = StringParser.parseAs(input, InputFormat.csv);

        expect(result.detectedFormat, equals(InputFormat.csv));
        expect(result.data, isA<List>());
        expect(result.data.length, equals(1));
      });
    });

    group('CSV parsing', () {
      test('parses CSV with header correctly', () {
        const input = 'id,name,active\n1,Alice,true';
        final result = StringParser.parseAs(input, InputFormat.csv);

        expect(result.data[0]['id'], equals(1));
        expect(result.data[0]['name'], equals('Alice'));
        // CsvToListConverter might not parse 'true' as bool automatically
      });

      test('handles CSV with quoted fields', () {
        const input = 'id,name\n1,"Alice Smith"';
        final result = StringParser.parseAs(input, InputFormat.csv);

        expect(result.data[0]['name'], equals('Alice Smith'));
      });
    });

    group('YAML parsing', () {
      test('parses simple YAML key-value pairs', () {
        const input = 'name: Alice\nage: 30';
        final result = StringParser.parseAs(input, InputFormat.yaml);

        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals(30));
      });

      test('handles YAML with comments', () {
        const input = 'name: Alice # User name\nage: 30 # User age';
        final result = StringParser.parseAs(input, InputFormat.yaml);

        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals(30));
      });
    });

    group('INI parsing', () {
      test('parses INI sections and keys', () {
        const input = '[db]\nhost=localhost\nport=5432';
        final result = StringParser.parseAs(input, InputFormat.ini);

        expect(result.data['db']['host'], equals('localhost'));
        expect(result.data['db']['port'], equals('5432'));
      });

      test('handles INI with comments', () {
        const input = 'host=localhost # Host comment\nport=5432 ; Port comment';
        final result = StringParser.parseAs(input, InputFormat.ini);

        expect(result.data['default']['host'], equals('localhost'));
        expect(result.data['default']['port'], equals('5432'));
      });
    });

    group('edge cases', () {
      test('handles single character input', () {
        final result = StringParser.parseAny('a');
        expect(result.detectedFormat, equals(InputFormat.unknown));
      });

      test('handles very large input', () {
        final largeInput = '{"data": "${"a" * 10000}"}';
        final result = StringParser.parseAny(largeInput);
        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.isSuccess, isTrue);
      });
    });
  });
}
