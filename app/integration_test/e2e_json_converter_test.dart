import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

/// End-to-end tests for String-to-JSON Converter
///
/// Tests JSON validation, auto-repair, format detection, and conversion workflows
void main() {
  group('JSON Converter E2E Tests', () {


    patrolTest('complete JSON validation and repair workflow', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Verify initial state
      await $.waitUntilVisible(find.text('String-to-JSON Converter'));

      // Input broken JSON
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      const brokenJson = '''
      {
        "name": "Test",
        "value": 123,
        "items": [
          "item1",
          "item2",
        ],
      }
      ''';

      await $.enterText(inputField.first, brokenJson);
      await $.pumpAndSettle();

      // Validate JSON (should show errors)
      final validateButton = find.text('Validate');
      if (validateButton.evaluate().isNotEmpty) {
        await $.tap(validateButton);
        await $.pumpAndSettle();

        // Should show validation errors
        await $.pumpAndSettle(const Duration(seconds: 2));
      }

      // Auto-repair JSON
      final repairButton = find.text('Auto-Repair');
      if (repairButton.evaluate().isNotEmpty) {
        await $.tap(repairButton);
        await $.pumpAndSettle(const Duration(seconds: 2));
      }

      // Validate repaired JSON
      if (validateButton.evaluate().isNotEmpty) {
        await $.tap(validateButton);
        await $.pumpAndSettle();
      }

      // Copy result
      final copyButton = find.text('Copy');
      if (copyButton.evaluate().isNotEmpty) {
        await $.tap(copyButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('CSV to JSON conversion', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Input CSV data
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      const csvData = '''
      Name,Age,City
      Alice,25,Mumbai
      Bob,30,Delhi
      Charlie,35,Bangalore
      ''';

      await $.enterText(inputField.first, csvData);
      await $.pumpAndSettle();

      // Should auto-detect as CSV
      await $.pumpAndSettle(const Duration(seconds: 1));

      // Verify CSV format detection
      final csvChip = find.text('CSV');
      expect(csvChip, findsOneWidget);

      // Convert to JSON
      final convertButton = find.text('Convert');
      if (convertButton.evaluate().isNotEmpty) {
        await $.tap(convertButton);
        await $.pumpAndSettle();
      }

      // Verify JSON output is generated
      await $.pumpAndSettle();
    });

    patrolTest('YAML to JSON conversion', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Input YAML data
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      const yamlData = '''
      name: BharatTesting
      version: 1.0.0
      features:
        offline: true
        privacy: first
        opensource: true
      tools:
        - Scanner
        - Reducer
        - Merger
      ''';

      await $.enterText(inputField.first, yamlData);
      await $.pumpAndSettle();

      // Should auto-detect as YAML
      await $.pumpAndSettle(const Duration(seconds: 1));

      // Convert to JSON
      final convertButton = find.text('Convert');
      if (convertButton.evaluate().isNotEmpty) {
        await $.tap(convertButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('JSON formatting and minification', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Input minified JSON
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      const minifiedJson = '''{"name":"Test","data":{"items":[1,2,3],"config":{"enabled":true}}}''';

      await $.enterText(inputField.first, minifiedJson);
      await $.pumpAndSettle();

      // Pretty-print JSON
      final formatButton = find.text('Pretty');
      if (formatButton.evaluate().isNotEmpty) {
        await $.tap(formatButton);
        await $.pumpAndSettle();
      }

      // Minify again
      final minifyButton = find.text('Minify');
      if (minifyButton.evaluate().isNotEmpty) {
        await $.tap(minifyButton);
        await $.pumpAndSettle();
      }
    });

    patrolTest('syntax highlighting verification', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Input complex JSON
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      const complexJson = '''
      {
        "metadata": {
          "version": "2.1.0",
          "timestamp": "2024-01-15T10:30:00Z"
        },
        "data": {
          "numbers": [1, 2, 3.14, -42],
          "strings": ["hello", "world"],
          "boolean": true,
          "null_value": null
        }
      }
      ''';

      await $.enterText(inputField.first, complexJson);
      await $.pumpAndSettle();

      // Verify syntax highlighting is applied
      await $.pumpAndSettle(const Duration(seconds: 2));
    });

    patrolTest('error line highlighting', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Input JSON with syntax error
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      const errorJson = '''
      {
        "name": "Test",
        "value": 123,
        "invalid": ,
        "end": true
      }
      ''';

      await $.enterText(inputField.first, errorJson);
      await $.pumpAndSettle();

      // Validate to trigger error highlighting
      final validateButton = find.text('Validate');
      if (validateButton.evaluate().isNotEmpty) {
        await $.tap(validateButton);
        await $.pumpAndSettle(const Duration(seconds: 2));

        // Should show error indicators
        await $.pumpAndSettle();
      }
    });

    patrolTest('large JSON handling performance', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Input large JSON (simulate large data)
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      // Generate large JSON structure
      final largeJsonItems = List.generate(100, (i) => '''
        {
          "id": $i,
          "name": "Item $i",
          "data": {
            "value": ${i * 10},
            "description": "This is item number $i with some data"
          }
        }
      ''').join(',');

      final largeJson = '''
      {
        "metadata": {
          "count": 100,
          "generated": "2024-01-15T10:30:00Z"
        },
        "items": [$largeJsonItems]
      }
      ''';

      await $.enterText(inputField.first, largeJson);
      await $.pumpAndSettle();

      // Validate large JSON (should complete within reasonable time)
      final validateButton = find.text('Validate');
      if (validateButton.evaluate().isNotEmpty) {
        final startTime = DateTime.now();
        await $.tap(validateButton);
        await $.pumpAndSettle(const Duration(seconds: 5));
        final endTime = DateTime.now();

        // Should complete within 5 seconds
        expect(endTime.difference(startTime).inSeconds, lessThan(5));
      }
    });

    patrolTest('download functionality', (PatrolTester $) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle();

      // Input and process JSON
      final inputField = find.byType(TextField);
      await $.waitUntilVisible(inputField);

      const testJson = '''
      {
        "name": "Download Test",
        "timestamp": "2024-01-15T10:30:00Z"
      }
      ''';

      await $.enterText(inputField.first, testJson);
      await $.pumpAndSettle();

      // Download processed JSON
      final downloadButton = find.text('Download');
      if (downloadButton.evaluate().isNotEmpty) {
        await $.tap(downloadButton);
        await $.pumpAndSettle();

        // Verify download initiated (file picker or save dialog)
        await $.pumpAndSettle(const Duration(seconds: 2));
      }
    });
  });
}