import 'package:test/test.dart';
import 'package:bharattesting_core/src/json_converter/json_formatter.dart';

void main() {
  group('JSONFormatter', () {
    group('prettify', () {
      test('formats simple JSON object with default options', () {
        const jsonInput = '{"name":"Alice","age":30,"active":true}';
        final result = JSONFormatter.prettify(jsonInput);

        expect(result.formatted, contains('\n'));
        expect(result.formatted, contains('  "name": "Alice"'));
        expect(result.formatted, contains('  "age": 30'));
        expect(result.formatted, contains('  "active": true'));
        expect(result.formattedSize, greaterThan(result.originalSize));
        expect(result.isCompressed, isFalse);
      });

      test('formats JSON array with indentation', () {
        const jsonInput = '[{"id":1,"name":"Alice"},{"id":2,"name":"Bob"}]';
        final result = JSONFormatter.prettify(jsonInput);

        expect(result.formatted, contains('[\n'));
        expect(result.formatted, contains('  {\n'));
        expect(result.formatted, contains('    "id": 1'));
        expect(result.formatted, contains('  }'));
        expect(result.formatted, contains('\n]'));
      });

      test('sorts keys when option enabled', () {
        const jsonInput = '{"zebra":"last","alpha":"first","beta":"middle"}';
        const options = JSONFormatOptions(sortKeys: true);
        final result = JSONFormatter.prettify(jsonInput, options);

        final lines = result.formatted.split('\n');
        final alphaLine = lines.indexWhere((line) => line.contains('"alpha"'));
        final betaLine = lines.indexWhere((line) => line.contains('"beta"'));
        final zebraLine = lines.indexWhere((line) => line.contains('"zebra"'));

        expect(alphaLine, lessThan(betaLine));
        expect(betaLine, lessThan(zebraLine));
      });

      test('adds trailing commas when option enabled', () {
        const jsonInput = '{"name":"Alice","age":30}';
        const options = JSONFormatOptions(trailingComma: true);
        final result = JSONFormatter.prettify(jsonInput, options);

        expect(result.formatted, contains('"age": 30,'));
        expect(result.formatted, endsWith(',\n}'));
      });

      test('formats compact arrays when option enabled', () {
        const jsonInput = '["a","b","c"]';
        const options = JSONFormatOptions(compactArrays: true, arrayWrapThreshold: 5);
        final result = JSONFormatter.prettify(jsonInput, options);

        expect(result.formatted, equals('["a", "b", "c"]'));
        expect(result.formatted, isNot(contains('\n')));
      });

      test('formats compact objects when option enabled', () {
        const jsonInput = '{"a":1,"b":2}';
        const options = JSONFormatOptions(compactObjects: true, objectWrapThreshold: 5);
        final result = JSONFormatter.prettify(jsonInput, options);

        expect(result.formatted, equals('{"a": 1, "b": 2}'));
        expect(result.formatted, isNot(contains('\n')));
      });

      test('respects maximum line length', () {
        const jsonInput = '{"very_long_key_name":"very_long_value_that_exceeds_limit","short":"ok"}';
        const options = JSONFormatOptions(
          compactObjects: true,
          maxLineLength: 30,
        );
        final result = JSONFormatter.prettify(jsonInput, options);

        // Should fall back to multiline when compact exceeds limit
        expect(result.formatted, contains('\n'));
      });

      test('uses custom indentation', () {
        const jsonInput = '{"name":"Alice","details":{"age":30}}';
        const options = JSONFormatOptions(indent: '    '); // 4 spaces
        final result = JSONFormatter.prettify(jsonInput, options);

        expect(result.formatted, contains('    "name": "Alice"'));
        expect(result.formatted, contains('        "age": 30')); // Nested 8 spaces
      });

      test('handles nested structures correctly', () {
        const jsonInput = '''
{
  "user": {
    "name": "Alice",
    "contacts": {
      "email": "alice@example.com",
      "phones": ["123-456-7890", "098-765-4321"]
    }
  },
  "settings": {
    "theme": "dark",
    "notifications": ["email", "sms"]
  }
}''';

        final result = JSONFormatter.prettify(jsonInput);

        expect(result.formatted, contains('  "user": {'));
        expect(result.formatted, contains('    "name": "Alice"'));
        expect(result.formatted, contains('      "email": "alice@example.com"'));
        expect(result.formatted, contains('      "phones": ['));
      });
    });

    group('minify', () {
      test('removes all unnecessary whitespace', () {
        const jsonInput = '''
{
  "name": "Alice",
  "age": 30,
  "hobbies": [
    "reading",
    "swimming"
  ]
}''';

        final result = JSONFormatter.minify(jsonInput);

        expect(result.formatted, equals('{"name":"Alice","age":30,"hobbies":["reading","swimming"]}'));
        expect(result.formattedSize, lessThan(result.originalSize));
        expect(result.isCompressed, isTrue);
        expect(result.metadata!['style'], equals('minified'));
        expect(result.metadata!['compressionRatio'], greaterThan(0));
      });

      test('handles already minified JSON', () {
        const jsonInput = '{"name":"Alice","age":30}';
        final result = JSONFormatter.minify(jsonInput);

        expect(result.formatted, equals(jsonInput));
        expect(result.formattedSize, equals(result.originalSize));
      });

      test('calculates compression ratio correctly', () {
        const jsonInput = '''
{
  "name"   :   "Alice"  ,
  "age"    :   30       ,
  "active" :   true
}''';

        final result = JSONFormatter.minify(jsonInput);
        final compressionRatio = result.metadata!['compressionRatio'] as double;

        expect(compressionRatio, greaterThan(0.5)); // Should compress by more than 50%
        expect(result.sizeChangeRatio, lessThan(0)); // Size decreased
      });
    });

    group('format with custom options', () {
      test('applies JavaScript-style formatting', () {
        const jsonInput = '{"name":"Alice","hobbies":["reading","coding"]}';
        final result = JSONFormatter.format(jsonInput, JSONFormatOptions.javascript);

        expect(result.formatted, contains('"hobbies": ["reading", "coding"]')); // Compact array
        expect(result.formatted, contains(',\n}')); // Trailing comma
      });

      test('applies verbose formatting', () {
        const jsonInput = '{"zebra":"animal","alpha":"letter","beta":"greek"}';
        final result = JSONFormatter.format(jsonInput, JSONFormatOptions.verbose);

        expect(result.formatted, contains('    ')); // 4-space indent
        expect(result.metadata!['sortKeys'], isTrue);

        // Should be sorted
        final lines = result.formatted.split('\n');
        final alphaIndex = lines.indexWhere((line) => line.contains('"alpha"'));
        final zebraIndex = lines.indexWhere((line) => line.contains('"zebra"'));
        expect(alphaIndex, lessThan(zebraIndex));
      });
    });

    group('normalize', () {
      test('converts to standard format', () {
        const malformedInput = '{"name":"Alice","age":30,}'; // Trailing comma

        // This would typically need repair first, but let's test with valid input
        const jsonInput = '{"name":"Alice","age":30}';
        final result = JSONFormatter.normalize(jsonInput);

        expect(result.formatted, contains('  "name": "Alice"'));
        expect(result.formatted, contains('  "age": 30'));
        expect(result.metadata!['style'], equals('normalized'));
        expect(result.metadata!['validationPassed'], isTrue);
      });
    });

    group('getStatistics', () {
      test('provides comprehensive statistics for valid JSON', () {
        const jsonInput = '''
{
  "name": "Alice",
  "age": 30,
  "scores": [95.5, 87.2, 92.1],
  "active": true,
  "metadata": null,
  "settings": {
    "theme": "dark",
    "count": 5
  }
}''';

        final stats = JSONFormatter.getStatistics(jsonInput);

        expect(stats['valid'], isTrue);
        expect(stats['size'], equals(jsonInput.length));
        expect(stats['minifiedSize'], lessThan(stats['size'] as int));

        final structure = stats['structure'] as Map<String, dynamic>;
        expect(structure['string'], equals(2)); // "Alice", "dark"
        expect(structure['integer'], equals(5)); // age:30, scores, count:5
        expect(structure['double'], equals(3)); // scores array
        expect(structure['boolean'], equals(1)); // active
        expect(structure['null'], equals(1)); // metadata
        expect(structure['object'], equals(2)); // root + settings
        expect(structure['array'], equals(1)); // scores
      });

      test('handles invalid JSON gracefully', () {
        const invalidInput = '{"name": "Alice", invalid}';
        final stats = JSONFormatter.getStatistics(invalidInput);

        expect(stats['valid'], isFalse);
        expect(stats['size'], equals(invalidInput.length));
        expect(stats['error'], isNotNull);
      });
    });

    group('detectStyle', () {
      test('detects minified style', () {
        const minifiedInput = '{"name":"Alice","age":30,"hobbies":["reading"]}';
        final style = JSONFormatter.detectStyle(minifiedInput);

        expect(style, equals('minified'));
      });

      test('detects standard style', () {
        const standardInput = '''
{
  "name": "Alice",
  "age": 30
}''';
        final style = JSONFormatter.detectStyle(standardInput);

        expect(style, equals('standard'));
      });

      test('detects JavaScript style', () {
        const jsInput = '''
{
  "name": "Alice",
  "age": 30,
}''';
        final style = JSONFormatter.detectStyle(jsInput);

        expect(style, equals('javascript'));
      });

      test('detects compact style', () {
        const compactInput = '''
{"name": "Alice",
"age": 30}''';
        final style = JSONFormatter.detectStyle(compactInput);

        expect(style, equals('compact'));
      });
    });

    group('convertStyle', () {
      test('converts between different styles', () {
        const jsonInput = '{"name":"Alice","age":30}';

        final minifiedResult = JSONFormatter.convertStyle(jsonInput, 'standard', 'minified');
        expect(minifiedResult.formatted, equals(jsonInput)); // Already minified

        final jsResult = JSONFormatter.convertStyle(jsonInput, 'minified', 'javascript');
        expect(jsResult.formatted, contains(',\n}'));

        final verboseResult = JSONFormatter.convertStyle(jsonInput, 'minified', 'verbose');
        expect(verboseResult.formatted, contains('    ')); // 4-space indent
      });
    });

    group('edge cases', () {
      test('handles empty objects and arrays', () {
        const emptyInput = '{"empty_obj":{},"empty_arr":[]}';
        final result = JSONFormatter.prettify(emptyInput);

        expect(result.formatted, contains('"empty_obj": {}'));
        expect(result.formatted, contains('"empty_arr": []'));
      });

      test('handles deeply nested structures', () {
        const deepInput = '{"a":{"b":{"c":{"d":{"e":"deep_value"}}}}}';
        final result = JSONFormatter.prettify(deepInput);

        expect(result.formatted, contains('          "e": "deep_value"')); // Deep indentation
      });

      test('handles special characters in strings', () {
        const specialInput = r'{"unicode":"🔥⚡️","quotes":"He said \"hello\"","newlines":"line1\nline2"}';
        final result = JSONFormatter.prettify(specialInput);

        expect(result.formatted, contains('🔥⚡️'));
        expect(result.formatted, contains(r'"He said \"hello\""'));
        expect(result.formatted, contains(r'"line1\nline2"'));
      });

      test('handles very large numbers', () {
        const numberInput = '{"big":9007199254740991,"small":-9007199254740991,"decimal":3.141592653589793}';
        final result = JSONFormatter.prettify(numberInput);

        expect(result.formatted, contains('9007199254740991'));
        expect(result.formatted, contains('-9007199254740991'));
        expect(result.formatted, contains('3.141592653589793'));
      });

      test('throws FormatException for invalid JSON', () {
        const invalidInput = '{"name": "Alice", invalid}';

        expect(() => JSONFormatter.prettify(invalidInput), throwsA(isA<FormatException>()));
        expect(() => JSONFormatter.minify(invalidInput), throwsA(isA<FormatException>()));
        expect(() => JSONFormatter.normalize(invalidInput), throwsA(isA<FormatException>()));
      });

      test('handles null and primitive values', () {
        const primitiveInput = 'null';
        const stringInput = '"hello world"';
        const numberInput = '42';
        const boolInput = 'true';

        expect(() => JSONFormatter.prettify(primitiveInput), returnsNormally);
        expect(() => JSONFormatter.prettify(stringInput), returnsNormally);
        expect(() => JSONFormatter.prettify(numberInput), returnsNormally);
        expect(() => JSONFormatter.prettify(boolInput), returnsNormally);
      });
    });

    group('compact formatting edge cases', () {
      test('does not compact arrays with complex elements', () {
        const complexArrayInput = '[{"name":"Alice"},{"name":"Bob"}]';
        const options = JSONFormatOptions(compactArrays: true);
        final result = JSONFormatter.prettify(complexArrayInput, options);

        expect(result.formatted, contains('\n')); // Should use multiline
      });

      test('does not compact objects with long string values', () {
        final longStringInput = '{"short":"ok","long":"${'A' * 30}"}';
        const options = JSONFormatOptions(compactObjects: true);
        final result = JSONFormatter.prettify(longStringInput, options);

        expect(result.formatted, contains('\n')); // Should use multiline
      });

      test('does not compact when keys are too long', () {
        final longKeyInput = '{"${'very_long_key_name' * 2}":"value"}';
        const options = JSONFormatOptions(compactObjects: true);
        final result = JSONFormatter.prettify(longKeyInput, options);

        expect(result.formatted, contains('\n')); // Should use multiline
      });
    });

    group('performance', () {
      test('handles large JSON files efficiently', () {
        final buffer = StringBuffer();
        buffer.write('{"items":[');

        for (int i = 0; i < 10000; i++) {
          if (i > 0) buffer.write(',');
          buffer.write('{"id":$i,"name":"Item $i","active":${i % 2 == 0}}');
        }

        buffer.write(']}');

        final stopwatch = Stopwatch()..start();
        final result = JSONFormatter.prettify(buffer.toString());
        stopwatch.stop();

        expect(result.isCompressed, isFalse);
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Under 5 seconds

        print('Formatted large JSON (${buffer.length} chars) in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('minification performance', () {
        final buffer = StringBuffer();
        buffer.write('{\n');

        for (int i = 0; i < 1000; i++) {
          if (i > 0) buffer.write(',\n');
          buffer.write('  "field_$i": {\n');
          buffer.write('    "value": $i,\n');
          buffer.write('    "text": "Item $i"\n');
          buffer.write('  }');
        }

        buffer.write('\n}');

        final stopwatch = Stopwatch()..start();
        final result = JSONFormatter.minify(buffer.toString());
        stopwatch.stop();

        expect(result.isCompressed, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Under 1 second

        print('Minified large JSON (${buffer.length} chars) in ${stopwatch.elapsedMilliseconds}ms');
        print('Compression ratio: ${((result.metadata!['compressionRatio'] as double) * 100).toStringAsFixed(1)}%');
      });

      test('deep nesting performance', () {
        String deepJSON = '"value"';
        for (int i = 0; i < 100; i++) {
          deepJSON = '{"level_$i":$deepJSON}';
        }

        final stopwatch = Stopwatch()..start();
        final result = JSONFormatter.prettify(deepJSON);
        stopwatch.stop();

        expect(result.formatted, isNotEmpty);
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Under 1 second

        print('Formatted deeply nested JSON (100 levels) in ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('metadata', () {
      test('provides useful metadata for prettify', () {
        const jsonInput = '{"name":"Alice","age":30}';
        final result = JSONFormatter.prettify(jsonInput);

        expect(result.metadata!['style'], equals('prettified'));
        expect(result.metadata!['indent'], equals('  '));
        expect(result.metadata!['sortKeys'], isFalse);
      });

      test('provides compression statistics for minify', () {
        const jsonInput = '''
{
  "name": "Alice",
  "age": 30
}''';
        final result = JSONFormatter.minify(jsonInput);

        expect(result.metadata!['style'], equals('minified'));
        expect(result.metadata!['compressionRatio'], isA<double>());
        expect(result.metadata!['compressionRatio'], greaterThan(0));
      });
    });

    group('predefined options', () {
      test('compact options work correctly', () {
        const jsonInput = '{"name":"Alice","age":30}';
        final result = JSONFormatter.format(jsonInput, JSONFormatOptions.compact);

        expect(result.formatted, contains('\n'));
        expect(result.metadata!['indent'], equals('  '));
      });

      test('standard options work correctly', () {
        const jsonInput = '{"name":"Alice","age":30}';
        final result = JSONFormatter.format(jsonInput, JSONFormatOptions.standard);

        expect(result.formatted, contains('  "name": "Alice"'));
      });

      test('verbose options work correctly', () {
        const jsonInput = '{"zebra":"last","alpha":"first"}';
        final result = JSONFormatter.format(jsonInput, JSONFormatOptions.verbose);

        expect(result.formatted, contains('    ')); // 4-space indent
        // Should be sorted
        expect(result.formatted.indexOf('alpha'), lessThan(result.formatted.indexOf('zebra')));
      });

      test('javascript options work correctly', () {
        const jsonInput = '{"name":"Alice","hobbies":["reading","coding"]}';
        final result = JSONFormatter.format(jsonInput, JSONFormatOptions.javascript);

        expect(result.formatted, contains('"hobbies": ["reading", "coding"]'));
        expect(result.formatted, endsWith(',\n}'));
      });
    });
  });
}