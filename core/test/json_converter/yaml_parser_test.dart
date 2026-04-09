import 'package:test/test.dart';
import 'package:bharattesting_core/src/json_converter/yaml_parser.dart';

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
        expect(result.data['age'], equals(30));
        expect(result.data['active'], equals(true));
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
        expect(result.data['config']['ports'][0], equals(8080));
      });

      test('handles YAML special values', () {
        const yamlInput = '''
null_value: null
tilde_null: ~
true_value: true
false_value: false
integer: 42
float: 3.14
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['null_value'], isNull);
        expect(result.data['tilde_null'], isNull);
        expect(result.data['true_value'], isTrue);
        expect(result.data['false_value'], isFalse);
        expect(result.data['integer'], equals(42));
        expect(result.data['float'], equals(3.14));
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
        expect(result.data['age'], equals(30));
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

      test('handles parse errors gracefully', () {
        const invalidYaml = '''
@invalid: yaml: structure
''';

        final jsonOutput = YAMLParser.toJSON(invalidYaml);

        expect(jsonOutput, contains('"success":false')); 
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
"numbers_123": "symbols_!@#\$%"
''';

        final result = YAMLParser.parse(yamlInput);

        expect(result.success, isTrue);
        expect(result.data['key with spaces'], equals('value'));
        expect(result.data['key:with:colons'], equals('another_value'));
        expect(result.data['unicode_key_🔥'], equals('unicode_value_⚡️'));
        expect(result.data['numbers_123'], equals('symbols_!@#\$%'));
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
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));

        print('Parsed large YAML (${buffer.length} chars) in ${stopwatch.elapsedMilliseconds}ms');
      });
    });
  });
}
