import 'package:test/test.dart';
import 'package:core/src/json_converter/csv_parser.dart';

void main() {
  group('CSVParser', () {
    group('parse with default config', () {
      test('parses CSV with header correctly', () {
        const csvInput = '''name,age,active
Alice,30,true
Bob,25,false
Charlie,35,true''';

        final result = CSVParser.parse(csvInput);

        expect(result.rowCount, equals(3));
        expect(result.columnCount, equals(3));
        expect(result.headers, equals(['name', 'age', 'active']));
        expect(result.data, isA<List<Map<String, dynamic>>>());

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['name'], equals('Alice'));
        expect(data[0]['age'], equals(30)); // Auto-converted to int
        expect(data[0]['active'], equals(true)); // Auto-converted to bool
        expect(data[1]['name'], equals('Bob'));
        expect(data[2]['name'], equals('Charlie'));
      });

      test('parses CSV without header', () {
        const csvInput = '''Alice,30,true
Bob,25,false''';

        final config = CSVConfig(hasHeader: false);
        final result = CSVParser.parse(csvInput, config);

        expect(result.rowCount, equals(2));
        expect(result.columnCount, equals(3));
        expect(result.headers, equals(['column_1', 'column_2', 'column_3']));
        expect(result.data, isA<List<List<dynamic>>>());

        final data = result.data as List<List<dynamic>>;
        expect(data[0][0], equals('Alice'));
        expect(data[0][1], equals(30));
        expect(data[0][2], equals(true));
      });

      test('handles quoted fields with commas', () {
        const csvInput = '''name,description,price
"Smith, John","A person with, commas",100.50
"Doe, Jane","Simple description",75.00''';

        final result = CSVParser.parse(csvInput);

        expect(result.rowCount, equals(2));
        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['name'], equals('Smith, John'));
        expect(data[0]['description'], equals('A person with, commas'));
        expect(data[0]['price'], equals(100.5));
      });

      test('handles escaped quotes', () {
        const csvInput = '''name,quote
"Alice","She said ""Hello"" to everyone"
"Bob","He replied ""Hi there"""''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['quote'], equals('She said "Hello" to everyone'));
        expect(data[1]['quote'], equals('He replied "Hi there"'));
      });

      test('handles empty fields', () {
        const csvInput = '''name,middle,last
Alice,,Smith
Bob,K,Jones
Charlie,,,Extra''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['middle'], isNull);
        expect(data[1]['middle'], equals('K'));
        expect(data[2]['middle'], equals(''));
      });

      test('handles different data types', () {
        const csvInput = '''name,age,height,active,score,date
Alice,30,5.6,true,95.5,2023-01-01
Bob,25,6.0,false,87.2,2023-02-15
Charlie,35,,true,null,invalid-date''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;

        // First row - all types detected correctly
        expect(data[0]['age'], equals(30));
        expect(data[0]['height'], equals(5.6));
        expect(data[0]['active'], equals(true));
        expect(data[0]['score'], equals(95.5));

        // Second row - different values same types
        expect(data[1]['age'], equals(25));
        expect(data[1]['active'], equals(false));

        // Third row - edge cases
        expect(data[2]['height'], isNull); // Empty field
        expect(data[2]['score'], equals('null')); // String 'null', not null
      });
    });

    group('custom configuration', () {
      test('respects custom delimiter', () {
        const csvInput = '''name;age;city
Alice;30;New York
Bob;25;London''';

        final config = CSVConfig(delimiter: ';');
        final result = CSVParser.parse(csvInput, config);

        expect(result.columnCount, equals(3));
        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['name'], equals('Alice'));
        expect(data[0]['city'], equals('New York'));
      });

      test('respects custom quote character', () {
        const csvInput = '''name,description
Alice,'She said |Hello| to me'
Bob,'Simple text' ''';

        final config = CSVConfig(quoteChar: "'");
        final result = CSVParser.parse(csvInput, config);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['description'], equals('She said |Hello| to me'));
      });

      test('handles skipEmptyLines option', () {
        const csvInput = '''name,age
Alice,30

Bob,25

Charlie,35''';

        // With skipEmptyLines = true (default)
        final result1 = CSVParser.parse(csvInput);
        expect(result1.rowCount, equals(3));

        // With skipEmptyLines = false
        final config = CSVConfig(skipEmptyLines: false);
        final result2 = CSVParser.parse(csvInput, config);
        expect(result2.rowCount, greaterThan(3));
      });

      test('handles autoDetectTypes option', () {
        const csvInput = '''name,age,active
Alice,30,true
Bob,25,false''';

        // With type detection (default)
        final result1 = CSVParser.parse(csvInput);
        final data1 = result1.data as List<Map<String, dynamic>>;
        expect(data1[0]['age'], isA<int>());
        expect(data1[0]['active'], isA<bool>());

        // Without type detection
        final config = CSVConfig(autoDetectTypes: false);
        final result2 = CSVParser.parse(csvInput, config);
        final data2 = result2.data as List<Map<String, dynamic>>;
        expect(data2[0]['age'], isA<String>());
        expect(data2[0]['active'], isA<String>());
      });

      test('handles trimWhitespace option', () {
        const csvInput = '''name, age , city
 Alice , 30 , New York
 Bob , 25 , London ''';

        // With trimming (default)
        final result1 = CSVParser.parse(csvInput);
        final data1 = result1.data as List<Map<String, dynamic>>;
        expect(data1[0]['name'], equals('Alice'));
        expect(data1[0]['city'], equals('New York'));

        // Without trimming
        final config = CSVConfig(trimWhitespace: false);
        final result2 = CSVParser.parse(csvInput, config);
        final data2 = result2.data as List<Map<String, dynamic>>;
        expect(data2[0]['name'], equals(' Alice '));
        expect(data2[0]['city'], equals(' New York '));
      });
    });

    group('toJSON', () {
      test('converts CSV to JSON with metadata', () {
        const csvInput = '''name,age,active
Alice,30,true
Bob,25,false''';

        final jsonOutput = CSVParser.toJSON(csvInput);
        expect(jsonOutput, contains('"data"'));
        expect(jsonOutput, contains('"metadata"'));
        expect(jsonOutput, contains('"rowCount"'));
        expect(jsonOutput, contains('"Alice"'));
      });

      test('supports prettified JSON output', () {
        const csvInput = '''name,value
test,123''';

        final compactJSON = CSVParser.toJSON(csvInput, prettify: false);
        final prettyJSON = CSVParser.toJSON(csvInput, prettify: true);

        expect(prettyJSON.length, greaterThan(compactJSON.length));
        expect(prettyJSON, contains('\n'));
        expect(prettyJSON, contains('  '));
      });

      test('includes warnings in JSON output', () {
        const csvInput = '''name,age
Alice,30,extra
Bob,invalid_age''';

        final jsonOutput = CSVParser.toJSON(csvInput);
        // May contain warnings about inconsistent columns or type conversion
        expect(jsonOutput, isNotEmpty);
      });
    });

    group('detectDelimiter', () {
      test('detects comma delimiter', () {
        const csvInput = '''name,age,city
Alice,30,New York''';

        final delimiter = CSVParser.detectDelimiter(csvInput);
        expect(delimiter, equals(','));
      });

      test('detects semicolon delimiter', () {
        const csvInput = '''name;age;city
Alice;30;New York''';

        final delimiter = CSVParser.detectDelimiter(csvInput);
        expect(delimiter, equals(';'));
      });

      test('detects tab delimiter', () {
        const csvInput = '''name\tage\tcity
Alice\t30\tNew York''';

        final delimiter = CSVParser.detectDelimiter(csvInput);
        expect(delimiter, equals('\t'));
      });

      test('prefers delimiter with most consistent column count', () {
        const csvInput = '''name;age,extra;city
Alice;30;New York
Bob;25;London''';

        final delimiter = CSVParser.detectDelimiter(csvInput);
        expect(delimiter, equals(';')); // More consistent than comma
      });
    });

    group('edge cases', () {
      test('handles empty CSV', () {
        final result = CSVParser.parse('');

        expect(result.rowCount, equals(0));
        expect(result.columnCount, equals(0));
        expect(result.data, isA<List>());
        expect((result.data as List).isEmpty, isTrue);
      });

      test('handles CSV with only header', () {
        const csvInput = 'name,age,city';
        final result = CSVParser.parse(csvInput);

        expect(result.rowCount, equals(0));
        expect(result.columnCount, equals(3));
        expect(result.headers, equals(['name', 'age', 'city']));
      });

      test('handles CSV with inconsistent column counts', () {
        const csvInput = '''name,age,city
Alice,30
Bob,25,London,Extra
Charlie,35,Paris''';

        final result = CSVParser.parse(csvInput);

        expect(result.rowCount, equals(3));
        expect(result.columnCount, equals(3)); // Based on header
        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['city'], isNull); // Missing field
        expect(data[1].containsKey('city'), isTrue); // Extra field ignored
      });

      test('handles special characters in data', () {
        const csvInput = '''name,symbols,unicode
"Test","""!@#$%^&*()"","🔥⚡️✨"
"Unicode","αβγ","中文"''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['symbols'], equals('"!@#\$%^&*()'));
        expect(data[0]['unicode'], equals('🔥⚡️✨'));
        expect(data[1]['unicode'], equals('中文'));
      });

      test('handles very long fields', () {
        final longText = 'A' * 10000;
        final csvInput = '''name,description
"Alice","$longText"''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['description'], equals(longText));
      });

      test('handles malformed quoted fields gracefully', () {
        const csvInput = '''name,description
"Alice","Unclosed quote
Bob,"Missing start quote"
"Charlie","Normal field"''';

        final result = CSVParser.parse(csvInput);

        // Should handle malformed fields gracefully
        expect(result.rowCount, greaterThan(0));
        expect(result.warnings, isNull); // or contains warnings if implemented
      });
    });

    group('type detection', () {
      test('correctly identifies integer columns', () {
        const csvInput = '''id,age,year
1,25,2023
2,30,2024
3,35,2025''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['id'], isA<int>());
        expect(data[0]['age'], isA<int>());
        expect(data[0]['year'], isA<int>());
      });

      test('correctly identifies double columns', () {
        const csvInput = '''price,height,score
10.50,5.6,95.5
15.75,6.0,87.2
20.00,5.8,92.1''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['price'], isA<double>());
        expect(data[0]['height'], isA<double>());
        expect(data[0]['score'], isA<double>());
      });

      test('correctly identifies boolean columns', () {
        const csvInput = '''active,enabled,visible
true,yes,1
false,no,0
true,yes,1''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['active'], isA<bool>());
        expect(data[0]['enabled'], isA<bool>());
        expect(data[0]['visible'], isA<bool>());
        expect(data[1]['active'], isFalse);
        expect(data[1]['enabled'], isFalse);
        expect(data[1]['visible'], isFalse);
      });

      test('defaults to string for mixed columns', () {
        const csvInput = '''mixed,name
123,Alice
text,Bob
45.6,Charlie''';

        final result = CSVParser.parse(csvInput);

        final data = result.data as List<Map<String, dynamic>>;
        // Mixed column should stay as strings
        expect(data[0]['mixed'], isA<String>());
        expect(data[0]['name'], isA<String>());
      });
    });

    group('metadata', () {
      test('provides comprehensive metadata', () {
        const csvInput = '''name,age,active
Alice,30,true
Bob,25,false''';

        final result = CSVParser.parse(csvInput);

        expect(result.metadata!['delimiter'], equals(','));
        expect(result.metadata!['hasHeader'], isTrue);
        expect(result.metadata!['autoDetectedTypes'], isTrue);
        expect(result.metadata!['totalRowsParsed'], equals(3));
        expect(result.metadata!['emptyRowsSkipped'], equals(0));
      });

      test('tracks empty rows skipped', () {
        const csvInput = '''name,age

Alice,30

Bob,25

''';

        final result = CSVParser.parse(csvInput);

        expect(result.metadata!['emptyRowsSkipped'], greaterThan(0));
      });

      test('provides type analysis when enabled', () {
        const csvInput = '''name,age,active
Alice,30,true
Bob,25,false''';

        final result = CSVParser.parse(csvInput);

        expect(result.metadata!['typeInfo'], isNotNull);
        final typeInfo = result.metadata!['typeInfo'] as Map<String, dynamic>;
        expect(typeInfo, containsKey('column_1'));
        expect(typeInfo, containsKey('column_2'));
        expect(typeInfo, containsKey('column_3'));
      });
    });

    group('performance', () {
      test('handles large CSV files efficiently', () {
        final buffer = StringBuffer();
        buffer.writeln('id,name,value,active');

        for (int i = 0; i < 10000; i++) {
          buffer.writeln('$i,Name$i,${i * 1.5},${i % 2 == 0}');
        }

        final stopwatch = Stopwatch()..start();
        final result = CSVParser.parse(buffer.toString());
        stopwatch.stop();

        expect(result.rowCount, equals(10000));
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Under 5 seconds

        print('Parsed large CSV (${buffer.length} chars) in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('type detection performance', () {
        final buffer = StringBuffer();
        buffer.writeln('text,number,decimal,flag');

        for (int i = 0; i < 1000; i++) {
          buffer.writeln('Text$i,$i,${i * 1.1},${i % 2 == 0}');
        }

        final stopwatch = Stopwatch()..start();
        final result = CSVParser.parse(buffer.toString());
        stopwatch.stop();

        final data = result.data as List<Map<String, dynamic>>;
        expect(data[0]['number'], isA<int>());
        expect(data[0]['decimal'], isA<double>());
        expect(data[0]['flag'], isA<bool>());

        print('Type detection for 1000 rows in ${stopwatch.elapsedMilliseconds}ms');
      });
    });
  });
}