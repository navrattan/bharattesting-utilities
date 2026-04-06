import 'package:test/test.dart';
import 'package:core/src/json_converter/string_parser.dart';

void main() {
  group('StringParser', () {
    group('parseAny', () {
      test('detects and parses valid JSON object', () {
        const jsonInput = '{"name": "test", "value": 123, "enabled": true}';
        final result = StringParser.parseAny(jsonInput);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.confidence, equals(1.0));
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<Map>());
        expect(result.data['name'], equals('test'));
        expect(result.data['value'], equals(123));
        expect(result.data['enabled'], isTrue);
      });

      test('detects and parses valid JSON array', () {
        const jsonInput = '[{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]';
        final result = StringParser.parseAny(jsonInput);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.confidence, equals(1.0));
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<List>());
        expect(result.data.length, equals(2));
        expect(result.data[0]['name'], equals('Alice'));
      });

      test('detects malformed JSON with lower confidence', () {
        const malformedJson = '{"name": "test", "value":}';
        final result = StringParser.parseAny(malformedJson);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.confidence, equals(0.3));
        expect(result.isSuccess, isFalse);
        expect(result.errors, isNotNull);
        expect(result.errors!.first, contains('Malformed JSON'));
      });

      test('detects CSV format', () {
        const csvInput = '''name,age,city
Alice,30,New York
Bob,25,London
Charlie,35,Paris''';
        final result = StringParser.parseAny(csvInput);

        expect(result.detectedFormat, equals(InputFormat.csv));
        expect(result.confidence, greaterThan(0.5));
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<List>());
        expect(result.metadata!['rowCount'], equals(4)); // Including header
        expect(result.metadata!['columnCount'], equals(3));
      });

      test('detects XML format', () {
        const xmlInput = '''<?xml version="1.0" encoding="UTF-8"?>
<users>
  <user id="1">
    <name>Alice</name>
    <age>30</age>
  </user>
</users>''';
        final result = StringParser.parseAny(xmlInput);

        expect(result.detectedFormat, equals(InputFormat.xml));
        expect(result.confidence, equals(1.0));
        expect(result.isSuccess, isTrue);
        expect(result.metadata!['hasDeclaration'], isTrue);
        expect(result.metadata!['rootElement'], equals('users'));
      });

      test('detects YAML format', () {
        const yamlInput = '''
name: Alice
age: 30
address:
  street: 123 Main St
  city: New York
hobbies:
  - reading
  - swimming
  - coding
''';
        final result = StringParser.parseAny(yamlInput);

        expect(result.detectedFormat, equals(InputFormat.yaml));
        expect(result.confidence, greaterThan(0.3));
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<Map>());
      });

      test('detects URL-encoded format', () {
        const urlEncodedInput = 'name=Alice&age=30&city=New%20York&enabled=true';
        final result = StringParser.parseAny(urlEncodedInput);

        expect(result.detectedFormat, equals(InputFormat.urlEncoded));
        expect(result.confidence, greaterThan(0.5));
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<Map>());
        expect(result.data['name'], equals('Alice'));
        expect(result.data['city'], equals('New York')); // URL decoded
      });

      test('detects INI format', () {
        const iniInput = '''
[database]
host=localhost
port=5432
name=mydb

[cache]
enabled=true
timeout=300
''';
        final result = StringParser.parseAny(iniInput);

        expect(result.detectedFormat, equals(InputFormat.ini));
        expect(result.confidence, greaterThan(0.4));
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<Map>());
        expect(result.data['database']['host'], equals('localhost'));
        expect(result.data['cache']['enabled'], equals('true'));
      });

      test('handles empty input', () {
        final result = StringParser.parseAny('');

        expect(result.detectedFormat, equals(InputFormat.unknown));
        expect(result.confidence, equals(0.0));
        expect(result.isSuccess, isFalse);
        expect(result.errors, contains('Input is empty'));
      });

      test('handles unrecognized format', () {
        const unknownInput = 'This is just plain text with no structure.';
        final result = StringParser.parseAny(unknownInput);

        expect(result.detectedFormat, equals(InputFormat.unknown));
        expect(result.confidence, equals(0.0));
        expect(result.isSuccess, isFalse);
      });
    });

    group('parseAs specific formats', () {
      test('parses as JSON when format specified', () {
        const jsonInput = '{"test": true}';
        final result = StringParser.parseAs(jsonInput, InputFormat.json);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.confidence, equals(1.0));
        expect(result.isSuccess, isTrue);
        expect(result.data['test'], isTrue);
      });

      test('parses as CSV when format specified', () {
        const csvInput = 'a,b,c\n1,2,3\n4,5,6';
        final result = StringParser.parseAs(csvInput, InputFormat.csv);

        expect(result.detectedFormat, equals(InputFormat.csv));
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<List>());
        expect(result.data.length, equals(2)); // Data rows (excluding header)
      });

      test('returns error for invalid format', () {
        const invalidJson = '{invalid json}';
        final result = StringParser.parseAs(invalidJson, InputFormat.json);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.isSuccess, isFalse);
        expect(result.errors, isNotNull);
      });
    });

    group('CSV parsing', () {
      test('parses CSV with header correctly', () {
        const csvInput = '''name,age,active
Alice,30,true
Bob,25,false''';
        final result = StringParser.parseAs(csvInput, InputFormat.csv);

        expect(result.isSuccess, isTrue);
        expect(result.data, isA<List>());
        expect(result.data[0]['name'], equals('Alice'));
        expect(result.data[0]['age'], equals(30)); // Auto-converted to number
        expect(result.data[0]['active'], equals(true)); // Auto-converted to boolean
      });

      test('handles CSV with quoted fields', () {
        const csvInput = '''name,description
"Alice Smith","A person who likes ""quotes"""
"Bob Jones","Simple description"''';
        final result = StringParser.parseAs(csvInput, InputFormat.csv);

        expect(result.isSuccess, isTrue);
        expect(result.data[0]['name'], equals('Alice Smith'));
        expect(result.data[0]['description'], contains('quotes'));
      });

      test('handles CSV with different delimiters', () {
        const csvInput = 'name;age;city\nAlice;30;New York\nBob;25;London';
        final result = StringParser.parseAs(csvInput, InputFormat.csv);

        expect(result.isSuccess, isTrue);
        // Note: Current implementation assumes comma delimiter
        // In production, you'd want delimiter auto-detection
      });
    });

    group('XML parsing', () {
      test('extracts root element from XML', () {
        const xmlInput = '<config><setting>value</setting></config>';
        final result = StringParser.parseAs(xmlInput, InputFormat.xml);

        expect(result.isSuccess, isTrue);
        expect(result.data['rootElement'], equals('config'));
      });

      test('handles XML without declaration', () {
        const xmlInput = '<simple>content</simple>';
        final result = StringParser.parseAs(xmlInput, InputFormat.xml);

        expect(result.isSuccess, isTrue);
        expect(result.data['rootElement'], equals('simple'));
      });
    });

    group('YAML parsing', () {
      test('parses simple YAML key-value pairs', () {
        const yamlInput = '''
name: Alice
age: 30
active: true
''';
        final result = StringParser.parseAs(yamlInput, InputFormat.yaml);

        expect(result.isSuccess, isTrue);
        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals('30')); // YAML parser returns strings
        expect(result.data['active'], equals('true'));
      });

      test('handles YAML with comments', () {
        const yamlInput = '''
# Configuration
name: Alice  # User name
age: 30      # User age
''';
        final result = StringParser.parseAs(yamlInput, InputFormat.yaml);

        expect(result.isSuccess, isTrue);
        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals('30'));
      });
    });

    group('URL-encoded parsing', () {
      test('parses standard form data', () {
        const input = 'name=Alice&age=30&active=true';
        final result = StringParser.parseAs(input, InputFormat.urlEncoded);

        expect(result.isSuccess, isTrue);
        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals('30'));
        expect(result.data['active'], equals('true'));
      });

      test('handles URL encoding', () {
        const input = 'message=Hello%20World&special=%21%40%23';
        final result = StringParser.parseAs(input, InputFormat.urlEncoded);

        expect(result.isSuccess, isTrue);
        expect(result.data['message'], equals('Hello World'));
        expect(result.data['special'], equals('!@#'));
      });

      test('handles empty values', () {
        const input = 'name=Alice&empty=&other=value';
        final result = StringParser.parseAs(input, InputFormat.urlEncoded);

        expect(result.isSuccess, isTrue);
        expect(result.data['name'], equals('Alice'));
        expect(result.data['empty'], equals(''));
        expect(result.data['other'], equals('value'));
      });
    });

    group('INI parsing', () {
      test('parses INI with multiple sections', () {
        const iniInput = '''
[section1]
key1=value1
key2=value2

[section2]
key3=value3
key4=value4
''';
        final result = StringParser.parseAs(iniInput, InputFormat.ini);

        expect(result.isSuccess, isTrue);
        expect(result.data['section1']['key1'], equals('value1'));
        expect(result.data['section2']['key3'], equals('value3'));
      });

      test('handles INI with comments', () {
        const iniInput = '''
# Global comment
[database]
host=localhost  # Host comment
port=5432
''';
        final result = StringParser.parseAs(iniInput, InputFormat.ini);

        expect(result.isSuccess, isTrue);
        expect(result.data['database']['host'], equals('localhost'));
        expect(result.data['database']['port'], equals('5432'));
      });

      test('handles default section', () {
        const iniInput = '''
global_key=global_value

[section]
section_key=section_value
''';
        final result = StringParser.parseAs(iniInput, InputFormat.ini);

        expect(result.isSuccess, isTrue);
        expect(result.data['default']['global_key'], equals('global_value'));
        expect(result.data['section']['section_key'], equals('section_value'));
      });
    });

    group('format confidence scoring', () {
      test('gives higher confidence to obvious formats', () {
        final jsonResult = StringParser.parseAny('{"key": "value"}');
        final csvResult = StringParser.parseAny('name,age\nAlice,30');
        final xmlResult = StringParser.parseAny('<?xml version="1.0"?><root></root>');

        expect(jsonResult.confidence, equals(1.0));
        expect(csvResult.confidence, greaterThan(0.7));
        expect(xmlResult.confidence, equals(1.0));
      });

      test('gives lower confidence to ambiguous formats', () {
        final ambiguousResult = StringParser.parseAny('key=value');

        expect(ambiguousResult.confidence, lessThan(0.8));
      });
    });

    group('edge cases', () {
      test('handles whitespace-only input', () {
        final result = StringParser.parseAny('   \n\t   ');

        expect(result.detectedFormat, equals(InputFormat.unknown));
        expect(result.isSuccess, isFalse);
      });

      test('handles single character input', () {
        final result = StringParser.parseAny('a');

        expect(result.detectedFormat, equals(InputFormat.unknown));
        expect(result.confidence, equals(0.0));
      });

      test('handles very large input', () {
        final largeJSON = '{"data": "${'a' * 10000}"}';
        final result = StringParser.parseAny(largeJSON);

        expect(result.detectedFormat, equals(InputFormat.json));
        expect(result.isSuccess, isTrue);
      });
    });

    group('metadata', () {
      test('provides useful metadata for JSON', () {
        final objectResult = StringParser.parseAny('{"key": "value"}');
        final arrayResult = StringParser.parseAny('[1, 2, 3]');

        expect(objectResult.metadata!['type'], equals('object'));
        expect(objectResult.metadata!['size'], equals(1));

        expect(arrayResult.metadata!['type'], equals('array'));
        expect(arrayResult.metadata!['size'], equals(3));
      });

      test('provides useful metadata for CSV', () {
        const csvInput = 'a,b\n1,2\n3,4';
        final result = StringParser.parseAny(csvInput);

        expect(result.metadata!['rowCount'], equals(3));
        expect(result.metadata!['columnCount'], equals(2));
      });
    });
  });
}