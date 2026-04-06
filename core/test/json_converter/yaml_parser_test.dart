import 'package:test/test.dart';
import 'package:core/src/json_converter/yaml_parser.dart';

void main() {
  group('YAMLParser', () {
    group('parse', () {
      test('parses simple key-value pairs', () {
        const yamlInput = '''
name: Alice
age: 30
active: true
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data, isA<Map>());
        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals('30')); // Simplified parser returns strings
        expect(result.data['active'], equals('true'));
      });

      test('parses nested objects', () {
        const yamlInput = '''
user:
  name: Alice
  details:
    age: 30
    city: New York
settings:
  theme: dark
  notifications: true
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data, isA<Map>());
        expect(result.data['user'], isA<Map>());
        expect(result.data['user']['name'], equals('Alice'));
        expect(result.data['user']['details'], isA<Map>());
        expect(result.data['user']['details']['city'], equals('New York'));
        expect(result.data['settings']['theme'], equals('dark'));
      });

      test('parses lists', () {
        const yamlInput = '''
- item1
- item2
- item3
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data, isA<Map>());
        expect(result.data['items'], isA<List>());
        expect(result.data['items'].length, equals(3));
        expect(result.data['items'][0], equals('item1'));
        expect(result.data['items'][2], equals('item3'));
      });

      test('parses mixed lists and objects', () {
        const yamlInput = '''
users:
  - name: Alice
    age: 30
  - name: Bob
    age: 25
config:
  debug: true
  ports:
    - 8080
    - 8443
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['users'], isA<List>());
        expect(result.data['users'].length, equals(2));
        expect(result.data['users'][0]['name'], equals('Alice'));
        expect(result.data['config']['ports'], isA<List>());
        expect(result.data['config']['ports'][0], equals('8080'));
      });

      test('handles YAML special values', () {
        const yamlInput = '''
null_value: null
tilde_null: ~
true_value: true
false_value: false
integer: 42
float: 3.14
scientific: 1.2e-3
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['null_value'], isNull);
        expect(result.data['tilde_null'], isNull);
        expect(result.data['true_value'], isTrue);
        expect(result.data['false_value'], isFalse);
        expect(result.data['integer'], equals(42));
        expect(result.data['float'], equals(3.14));
        expect(result.data['scientific'], equals(0.0012));
      });

      test('handles quoted strings', () {
        const yamlInput = '''
single_quoted: 'This is a single quoted string'
double_quoted: "This is a double quoted string"
unquoted: This is an unquoted string
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['single_quoted'], equals('This is a single quoted string'));
        expect(result.data['double_quoted'], equals('This is a double quoted string'));
        expect(result.data['unquoted'], equals('This is an unquoted string'));
      });

      test('handles comments', () {
        const yamlInput = '''
# This is a comment
name: Alice  # Inline comment
# Another comment
age: 30
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['name'], equals('Alice'));
        expect(result.data['age'], equals('30'));
      });

      test('handles empty input', () {
        final result = YAMLParser.parse('');

        expect(result.success, isTrue);
        expect(result.data, isNull);
        expect(result.metadata!['documentCount'], equals(0));
      });

      test('handles whitespace-only input', () {
        final result = YAMLParser.parse('   \n\t   ');

        expect(result.success, isTrue);
        expect(result.data, isNull);
      });

      test('handles multiple documents', () {
        const yamlInput = '''
---
name: Alice
age: 30
---
name: Bob
age: 25
---
name: Charlie
age: 35
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data, isA<List>());
        expect(result.data.length, equals(3));
        expect(result.data[0]['name'], equals('Alice'));
        expect(result.data[1]['name'], equals('Bob'));
        expect(result.data[2]['name'], equals('Charlie'));
        expect(result.metadata!['hasMultipleDocuments'], isTrue);
      });

      test('handles document end markers', () {
        const yamlInput = '''
---
name: Alice
age: 30
...
---
name: Bob
age: 25
...
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data, isA<List>());
        expect(result.data.length, equals(2));
      });

      test('handles complex indentation', () {
        const yamlInput = '''
level1:
  level2a:
    level3: value1
  level2b:
    level3: value2
    level3b:
      level4: value3
another:
  simple: value
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['level1']['level2a']['level3'], equals('value1'));
        expect(result.data['level1']['level2b']['level3b']['level4'], equals('value3'));
        expect(result.data['another']['simple'], equals('value'));
      });
    });

    group('toJSON', () {
      test('converts YAML to JSON successfully', () {
        const yamlInput = '''
name: Alice
age: 30
active: true
''';

        final jsonOutput = YAMLParser.toJSON(yamlInput);

        expect(jsonOutput, contains('"data"'));
        expect(jsonOutput, contains('"success"'));
        expect(jsonOutput, contains('"Alice"'));
        expect(jsonOutput, contains('true'));
      });

      test('supports prettified JSON output', () {
        const yamlInput = '''
name: test
value: 123
''';

        final compactJSON = YAMLParser.toJSON(yamlInput, prettify: false);
        final prettyJSON = YAMLParser.toJSON(yamlInput, prettify: true);

        expect(prettyJSON.length, greaterThan(compactJSON.length));
        expect(prettyJSON, contains('\n'));
        expect(prettyJSON, contains('  '));
      });

      test('includes metadata in JSON output', () {
        const yamlInput = '''
---
name: Alice
---
name: Bob
''';

        final jsonOutput = YAMLParser.toJSON(yamlInput, prettify: true);

        expect(jsonOutput, contains('"metadata"'));
        expect(jsonOutput, contains('"documentCount"'));
        expect(jsonOutput, contains('"hasMultipleDocuments"'));
      });

      test('includes warnings when multiline strings detected', () {
        const yamlInput = '''
description: |
  This is a multiline
  string that spans
  multiple lines
''';

        final jsonOutput = YAMLParser.toJSON(yamlInput, prettify: true);

        expect(jsonOutput, contains('"warnings"'));
        expect(jsonOutput, contains('Multiline string'));
      });

      test('handles parse errors gracefully', () {
        const invalidYaml = '''
[invalid: yaml: structure
''';

        final jsonOutput = YAMLParser.toJSON(invalidYaml);

        expect(jsonOutput, contains('"success": false'));
        expect(jsonOutput, contains('"errors"'));
      });
    });

    group('validateSyntax', () {
      test('returns empty list for valid YAML', () {
        const validYaml = '''
name: Alice
age: 30
hobbies:
  - reading
  - swimming
''';

        final errors = YAMLParser.validateSyntax(validYaml);

        expect(errors, isEmpty);
      });

      test('detects mixed tabs and spaces', () {
        const invalidYaml = '''
name: Alice
\tage: 30
  city: New York
''';

        final errors = YAMLParser.validateSyntax(invalidYaml);

        expect(errors, isNotEmpty);
        expect(errors.first, contains('Mixed tabs and spaces'));
      });

      test('detects unbalanced quotes', () {
        const invalidYaml = '''
name: "Alice
description: 'Missing closing quote
valid: "proper quote"
''';

        final errors = YAMLParser.validateSyntax(invalidYaml);

        expect(errors.length, equals(2));
        expect(errors[0], contains('Unbalanced double quotes'));
        expect(errors[1], contains('Unbalanced single quotes'));
      });

      test('detects invalid starting characters', () {
        const invalidYaml = '''
name: Alice
@invalid: value
`also_invalid: value
''';

        final errors = YAMLParser.validateSyntax(invalidYaml);

        expect(errors.length, equals(2));
        expect(errors[0], contains('Invalid character'));
        expect(errors[1], contains('Invalid character'));
      });

      test('provides line numbers in error messages', () {
        const invalidYaml = '''
name: Alice
age: 30
"unbalanced: quote
city: New York
''';

        final errors = YAMLParser.validateSyntax(invalidYaml);

        expect(errors, isNotEmpty);
        expect(errors.first, contains('Line 3'));
      });

      test('skips comments and empty lines', () {
        const yamlWithComments = '''
# This is a comment
name: Alice

# Another comment
age: 30
''';

        final errors = YAMLParser.validateSyntax(yamlWithComments);

        expect(errors, isEmpty);
      });
    });

    group('edge cases', () {
      test('handles extremely nested structures', () {
        const deepYaml = '''
a:
  b:
    c:
      d:
        e:
          f:
            g:
              h: deep_value
''';

        final result = YAMLParser.parse(deepYaml);

        expect(result.success, isTrue);
        expect(result.data['a']['b']['c']['d']['e']['f']['g']['h'], equals('deep_value'));
      });

      test('handles large lists', () {
        final buffer = StringBuffer();
        buffer.writeln('items:');

        for (int i = 0; i < 1000; i++) {
          buffer.writeln('  - item_$i');
        }

        final result = YAMLParser.parse(buffer.toString());

        expect(result.success, isTrue);
        expect(result.data['items'], isA<List>());
        expect(result.data['items'].length, equals(1000));
        expect(result.data['items'][0], equals('item_0'));
        expect(result.data['items'][999], equals('item_999'));
      });

      test('handles special characters in keys and values', () {
        const yamlInput = '''
"key with spaces": value
"key:with:colons": another_value
"unicode_key_🔥": "unicode_value_⚡️"
"numbers_123": "symbols_!@#$%"
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['key with spaces'], equals('value'));
        expect(result.data['key:with:colons'], equals('another_value'));
        expect(result.data['unicode_key_🔥'], equals('unicode_value_⚡️'));
        expect(result.data['numbers_123'], equals('symbols_!@#\$%'));
      });

      test('handles inconsistent indentation gracefully', () {
        const inconsistentYaml = '''
name: Alice
  age: 30
    city: New York
  country: USA
''';

        final result = YAMLParser.parse(inconsistentYaml);

        // Should handle gracefully, though structure may not be as expected
        expect(result.success, isTrue);
        expect(result.data['name'], equals('Alice'));
      });

      test('handles empty values', () {
        const yamlInput = '''
name: Alice
middle_name:
last_name: Smith
empty_explicit: null
empty_tilde: ~
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['name'], equals('Alice'));
        expect(result.data['middle_name'], isNull);
        expect(result.data['last_name'], equals('Smith'));
        expect(result.data['empty_explicit'], isNull);
        expect(result.data['empty_tilde'], isNull);
      });

      test('handles very long lines', () {
        final longValue = 'A' * 10000;
        final yamlInput = '''
name: Alice
description: $longValue
short: test
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['description'], equals(longValue));
        expect(result.data['short'], equals('test'));
      });
    });

    group('metadata', () {
      test('provides document count for single document', () {
        const yamlInput = '''
name: Alice
age: 30
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.metadata!['documentCount'], equals(1));
        expect(result.metadata!['hasMultipleDocuments'], isFalse);
      });

      test('provides document count for multiple documents', () {
        const yamlInput = '''
---
doc: 1
---
doc: 2
---
doc: 3
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.metadata!['documentCount'], equals(3));
        expect(result.metadata!['hasMultipleDocuments'], isTrue);
      });

      test('provides line count', () {
        const yamlInput = '''
line1: value1
line2: value2
line3: value3
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.metadata!['lineCount'], greaterThan(0));
      });
    });

    group('performance', () {
      test('handles large YAML files efficiently', () {
        final buffer = StringBuffer();

        // Generate a moderately complex YAML structure
        for (int i = 0; i < 1000; i++) {
          buffer.writeln('item_$i:');
          buffer.writeln('  id: $i');
          buffer.writeln('  name: Name $i');
          buffer.writeln('  active: ${i % 2 == 0}');
          buffer.writeln('  tags:');
          buffer.writeln('    - tag_${i}_1');
          buffer.writeln('    - tag_${i}_2');
        }

        final stopwatch = Stopwatch()..start();
        final result = YAMLParser.parse(buffer.toString());
        stopwatch.stop();

        expect(result.success, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Under 5 seconds

        print('Parsed large YAML (${buffer.length} chars) in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('deep nesting performance', () {
        final buffer = StringBuffer();

        // Create deeply nested structure
        String current = 'value';
        for (int i = 0; i < 100; i++) {
          current = 'level_$i:\n  $current';
        }

        final stopwatch = Stopwatch()..start();
        final result = YAMLParser.parse(current);
        stopwatch.stop();

        expect(result.success, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Under 1 second

        print('Parsed deep YAML (100 levels) in ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('warnings', () {
      test('collects warnings during parsing', () {
        const yamlWithIssues = '''
description: |
  This is a multiline string
  that our parser doesn't fully support
name: Alice
''';

        final result = YAMLParser.parse(yamlWithIssues);

        expect(result.success, isTrue);
        expect(result.warnings, isNotNull);
        expect(result.warnings!.first, contains('Multiline string'));
      });

      test('warnings do not prevent successful parsing', () {
        const yamlWithWarnings = '''
description: >
  Another multiline format
name: Alice
age: 30
''';

        final result = YAMLParser.parse(yamlWithWarnings);

        expect(result.success, isTrue);
        expect(result.data['name'], equals('Alice'));
        expect(result.warnings, isNotNull);
      });
    });
  });
}