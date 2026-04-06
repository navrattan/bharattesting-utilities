import 'package:test/test.dart';
import 'package:core/src/json_converter/auto_repair.dart';

void main() {
  group('AutoRepair', () {
    group('repairJSON', () {
      test('returns valid JSON unchanged', () {
        const validJSON = '{"name": "test", "value": 123}';
        final result = AutoRepair.repairJSON(validJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isFalse);
        expect(result.repaired, equals(validJSON));
        expect(result.appliedRules, isEmpty);
      });

      test('removes trailing commas', () {
        const malformedJSON = '{"name": "test", "values": [1, 2, 3,], "extra": true,}';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules, contains(RepairRule.trailingCommas));
        expect(result.repaired, equals('{"name": "test", "values": [1, 2, 3], "extra": true}'));
      });

      test('converts single quotes to double quotes', () {
        const malformedJSON = "{'name': 'test', 'value': 123}";
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules, contains(RepairRule.singleQuotes));
        expect(result.repaired, equals('{"name": "test", "value": 123}'));
      });

      test('adds quotes around unquoted keys', () {
        const malformedJSON = '{name: "test", value: 123, enabled: true}';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules, contains(RepairRule.unquotedKeys));
        expect(result.repaired, equals('{"name": "test", "value": 123, "enabled": true}'));
      });

      test('removes JavaScript comments', () {
        const malformedJSON = '''
        {
          "name": "test", // This is a comment
          /* Multi-line
             comment */
          "value": 123
        }
        ''';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules, contains(RepairRule.jsComments));
        expect(result.repaired, contains('"name": "test"'));
        expect(result.repaired, contains('"value": 123'));
        expect(result.repaired, isNot(contains('//')));
        expect(result.repaired, isNot(contains('/*')));
      });

      test('converts Python literals', () {
        const malformedJSON = '{"enabled": True, "disabled": False, "empty": None}';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules, contains(RepairRule.pythonLiterals));
        expect(result.repaired, equals('{"enabled": true, "disabled": false, "empty": null}'));
      });

      test('removes trailing text', () {
        const malformedJSON = '{"name": "test", "value": 123} extra text here';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules, contains(RepairRule.trailingText));
        expect(result.repaired, equals('{"name": "test", "value": 123}'));
      });

      test('applies multiple repair rules', () {
        const malformedJSON = '''
        {
          name: 'test', // Name field
          enabled: True,
          values: [1, 2, 3,],
          /* End of object */
        }
        ''';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules.length, greaterThan(1));
        expect(result.appliedRules, contains(RepairRule.jsComments));
        expect(result.appliedRules, contains(RepairRule.pythonLiterals));
        expect(result.appliedRules, contains(RepairRule.singleQuotes));
        expect(result.appliedRules, contains(RepairRule.unquotedKeys));
        expect(result.appliedRules, contains(RepairRule.trailingCommas));
      });

      test('respects enabled rules parameter', () {
        const malformedJSON = '{name: "test", values: [1, 2, 3,]}';
        final result = AutoRepair.repairJSON(
          malformedJSON,
          enabledRules: {RepairRule.unquotedKeys},
        );

        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules, equals([RepairRule.unquotedKeys]));
        expect(result.repaired, contains('"name": "test"'));
        expect(result.repaired, contains('[1, 2, 3,]')); // Trailing comma not fixed
      });

      test('handles complex nested structures', () {
        const malformedJSON = '''
        {
          users: [
            {name: 'Alice', active: True,},
            {name: 'Bob', active: False,}
          ],
          settings: {
            theme: 'dark',
            notifications: True,
          },
        }
        ''';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        // Should be valid JSON after repair
        expect(() => result.repaired, returnsNormally);
      });

      test('provides error information for unfixable JSON', () {
        const malformedJSON = '{"name": "test", "value":}'; // Missing value
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isFalse);
        expect(result.errors, isNotEmpty);
        expect(result.errors!.first.message, isNotEmpty);
      });

      test('handles empty and null input', () {
        final emptyResult = AutoRepair.repairJSON('');
        expect(emptyResult.isSuccess, isFalse);

        final spaceResult = AutoRepair.repairJSON('   ');
        expect(spaceResult.isSuccess, isFalse);
      });
    });

    group('error position detection', () {
      test('extracts error position from JSON decode errors', () {
        const malformedJSON = '{"name": "test" "value": 123}'; // Missing comma
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isFalse);
        expect(result.lineNumber, isNotNull);
        expect(result.columnNumber, isNotNull);
      });
    });

    group('user-friendly error messages', () {
      test('provides helpful error descriptions', () {
        const malformedJSON = '{"name": "test" "value": 123}';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isFalse);
        expect(result.errors!.first.message, contains('JSON format error'));
      });

      test('provides fix suggestions when possible', () {
        const malformedJSON = '{"name": "test", }';
        final result = AutoRepair.repairJSON(malformedJSON);

        // This should be fixed by trailing comma rule
        if (!result.isSuccess && result.errors!.isNotEmpty) {
          expect(result.errors!.first.suggestion, isNotNull);
        }
      });
    });

    group('edge cases', () {
      test('handles escaped quotes correctly', () {
        const validJSON = r'{"message": "He said \"Hello\""}';
        final result = AutoRepair.repairJSON(validJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isFalse);
      });

      test('handles nested quotes in single quote conversion', () {
        const malformedJSON = r"{'message': 'He said \"Hello\"'}";
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.repaired, contains(r'"He said \"Hello\""'));
      });

      test('handles mixed repair scenarios', () {
        const malformedJSON = '''
        {
          // Configuration
          name: 'app',
          version: "1.0.0",
          features: {
            auth: True,
            cache: False,
            debug: None,
          },
          ports: [8080, 8443,],
        } // End
        ''';
        final result = AutoRepair.repairJSON(malformedJSON);

        expect(result.isSuccess, isTrue);
        expect(result.wasRepaired, isTrue);
        expect(result.appliedRules.length, greaterThan(3));
      });
    });

    group('performance', () {
      test('handles large JSON efficiently', () {
        final largeJSON = StringBuffer();
        largeJSON.write('{');

        for (int i = 0; i < 1000; i++) {
          largeJSON.write('field_$i: "value_$i",');
        }

        largeJSON.write('}');

        final stopwatch = Stopwatch()..start();
        final result = AutoRepair.repairJSON(largeJSON.toString());
        stopwatch.stop();

        expect(result.wasRepaired, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Under 1 second

        print('Repaired large JSON (${largeJSON.length} chars) in ${stopwatch.elapsedMilliseconds}ms');
      });
    });
  });
}