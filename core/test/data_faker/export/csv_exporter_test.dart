import 'package:test/test.dart';
import 'package:bharattesting_core/src/data_faker/export/csv_exporter.dart';

void main() {
  group('CSVExporter', () {
    final testRecords = [
      {'id': 1, 'name': 'Alice', 'city': 'Mumbai'},
      {'id': 2, 'name': 'Bob', 'city': 'Delhi'},
    ];

    test('export returns non-empty string', () {
      final result = CSVExporter.export(testRecords);
      expect(result, isA<String>());
      expect(result, isNotEmpty);
      expect(result, contains('id,name,city'));
      expect(result, contains('Alice'));
    });

    test('export handles empty records', () {
      final result = CSVExporter.export([]);
      expect(result, isEmpty);
    });
  });
}
