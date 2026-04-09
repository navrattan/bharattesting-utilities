import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/export/json_exporter.dart';
import 'dart:convert';

void main() {
  group('JSONExporter', () {
    final testRecords = [
      {'id': 1, 'name': 'Alice'},
      {'id': 2, 'name': 'Bob'},
    ];

    test('export returns valid JSON string', () {
      final result = JSONExporter.export(testRecords);
      expect(result, isA<String>());
      expect(result, isNotEmpty);
      
      final decoded = jsonDecode(result);
      expect(decoded, isA<List>());
      expect(decoded.length, equals(2));
    });

    test('export supports prettify option', () {
      final compact = JSONExporter.export(testRecords, prettify: false);
      final pretty = JSONExporter.export(testRecords, prettify: true);
      
      expect(pretty.length, greaterThan(compact.length));
      expect(pretty, contains('\n'));
    });
  });
}
