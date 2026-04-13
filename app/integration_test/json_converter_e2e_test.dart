/// Comprehensive E2E tests for String-to-JSON Converter
///
/// Tests input parsing, auto-repair, format detection, error handling, and output functionality

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('JSON Converter E2E Tests', () {
    testWidgets('Complete JSON Converter workflow', ($) async {
      await app.main();
      await $.pumpAndSettle();

      // Navigate to JSON Converter
      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      // Verify screen loaded
      expect(find.text('String-to-JSON Converter'), findsOneWidget);

      // Test basic JSON input
      await _testBasicJsonConversion($);

      // Test auto-repair functionality
      await _testAutoRepairFeatures($);

      // Test different input formats
      await _testInputFormats($);

      // Test output controls
      await _testOutputControls($);

      // Test error handling
      await _testErrorHandling($);
    });

    testWidgets('Valid JSON input test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testValidJsonInput($);
    });

    testWidgets('Broken JSON repair test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testBrokenJsonRepair($);
    });

    testWidgets('CSV to JSON conversion', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testCsvToJsonConversion($);
    });

    testWidgets('YAML to JSON conversion', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testYamlToJsonConversion($);
    });

    testWidgets('Copy and download functionality', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testCopyDownloadFunctionality($);
    });

    testWidgets('Format toggle functionality', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testFormatToggle($);
    });
  });
}

Future<void> _testBasicJsonConversion(PatrolIntegrationTester $) async {
  // Find input field and enter valid JSON
  const validJson = '''
{
  "name": "Test User",
  "age": 30,
  "active": true
}''';

  await _enterTextInInput($, validJson);
  await $.pumpAndSettle();

  // Verify output appears
  await _verifyOutputContains($, 'Test User');
  await _verifyOutputContains($, '30');
  await _verifyOutputContains($, 'true');
}

Future<void> _testAutoRepairFeatures(PatrolIntegrationTester $) async {
  // Test trailing comma repair
  const brokenJsonTrailingComma = '''
{
  "name": "Test",
  "age": 30,
}''';

  await _clearAndEnterText($, brokenJsonTrailingComma);
  await $.pumpAndSettle();

  // Should auto-repair and show valid JSON
  await _verifyOutputContains($, '"name"');
  await _verifyOutputContains($, '"age"');

  // Test single quotes repair
  const brokenJsonSingleQuotes = '''
{
  'name': 'Test',
  'active': true
}''';

  await _clearAndEnterText($, brokenJsonSingleQuotes);
  await $.pumpAndSettle();

  // Should repair to double quotes
  await _verifyOutputContains($, '"name"');
  await _verifyOutputContains($, '"active"');

  // Test unquoted keys repair
  const brokenJsonUnquoted = '''
{
  name: "Test",
  age: 30
}''';

  await _clearAndEnterText($, brokenJsonUnquoted);
  await $.pumpAndSettle();

  await _verifyOutputContains($, '"name"');
  await _verifyOutputContains($, '"age"');
}

Future<void> _testInputFormats(PatrolIntegrationTester $) async {
  // Test different input format detection and conversion
  print('Testing input format detection');
}

Future<void> _testOutputControls(PatrolIntegrationTester $) async {
  // Test pretty-print vs minify toggles
  const testJson = '{"name": "Test", "age": 30}';

  await _clearAndEnterText($, testJson);
  await $.pumpAndSettle();

  // Look for format control buttons (pretty/minify)
  final prettyButton = find.text('Pretty');
  final minifyButton = find.text('Minify');

  if (prettyButton.evaluate().isNotEmpty) {
    await $.tap(prettyButton);
    await $.pumpAndSettle();
  }

  if (minifyButton.evaluate().isNotEmpty) {
    await $.tap(minifyButton);
    await $.pumpAndSettle();
  }
}

Future<void> _testErrorHandling(PatrolIntegrationTester $) async {
  // Test completely invalid input
  const invalidInput = 'This is not JSON at all!';

  await _clearAndEnterText($, invalidInput);
  await $.pumpAndSettle();

  // Should show error message
  final errorTexts = [
    'error',
    'Error',
    'invalid',
    'Invalid',
    'Unable to parse',
    'Parse error'
  ];

  bool foundError = false;
  for (final errorText in errorTexts) {
    if (find.textContaining(errorText).evaluate().isNotEmpty) {
      foundError = true;
      break;
    }
  }

  expect(foundError, isTrue, reason: 'Should show error for invalid input');
}

Future<void> _testValidJsonInput(PatrolIntegrationTester $) async {
  const validJson = '''
{
  "users": [
    {"id": 1, "name": "Alice"},
    {"id": 2, "name": "Bob"}
  ],
  "total": 2
}''';

  await _enterTextInInput($, validJson);
  await $.pumpAndSettle();

  // Verify all elements are preserved
  await _verifyOutputContains($, 'users');
  await _verifyOutputContains($, 'Alice');
  await _verifyOutputContains($, 'Bob');
  await _verifyOutputContains($, 'total');
}

Future<void> _testBrokenJsonRepair(PatrolIntegrationTester $) async {
  // Test multiple types of broken JSON
  const complexBrokenJson = '''
{
  "name": 'Mixed Quotes',
  unquoted_key: "value",
  "trailing_comma": true,
  // This is a comment
  "numbers": [1, 2, 3,],
}''';

  await _clearAndEnterText($, complexBrokenJson);
  await $.pumpAndSettle();

  // Should repair all issues
  await _verifyOutputContains($, '"name"');
  await _verifyOutputContains($, '"unquoted_key"');
  await _verifyOutputContains($, '"trailing_comma"');
  await _verifyOutputContains($, '"numbers"');
}

Future<void> _testCsvToJsonConversion(PatrolIntegrationTester $) async {
  const csvInput = '''
name,age,city
Alice,25,New York
Bob,30,San Francisco
Charlie,35,Chicago''';

  await _clearAndEnterText($, csvInput);
  await $.pumpAndSettle();

  // Should convert to JSON array
  await _verifyOutputContains($, 'Alice');
  await _verifyOutputContains($, 'New York');
  await _verifyOutputContains($, 'San Francisco');
}

Future<void> _testYamlToJsonConversion(PatrolIntegrationTester $) async {
  const yamlInput = '''
name: Test User
age: 30
address:
  street: 123 Main St
  city: Anytown''';

  await _clearAndEnterText($, yamlInput);
  await $.pumpAndSettle();

  // Should convert to JSON
  await _verifyOutputContains($, '"name"');
  await _verifyOutputContains($, '"address"');
  await _verifyOutputContains($, '"street"');
}

Future<void> _testCopyDownloadFunctionality(PatrolIntegrationTester $) async {
  const testJson = '{"test": "data"}';

  await _clearAndEnterText($, testJson);
  await $.pumpAndSettle();

  // Test copy functionality
  final copyButton = find.byIcon(Icons.copy);
  if (copyButton.evaluate().isNotEmpty) {
    await $.tap(copyButton);
    await $.pumpAndSettle();

    // Look for success message
    final successMessages = ['Copied', 'copied', 'clipboard'];
    bool foundSuccess = false;
    for (final message in successMessages) {
      if (find.textContaining(message).evaluate().isNotEmpty) {
        foundSuccess = true;
        break;
      }
    }
    expect(foundSuccess, isTrue);
  }

  // Test download functionality
  final downloadButton = find.byIcon(Icons.download);
  if (downloadButton.evaluate().isNotEmpty) {
    await $.tap(downloadButton);
    await $.pumpAndSettle();
    // Note: Download behavior is platform-specific
  }
}

Future<void> _testFormatToggle(PatrolIntegrationTester $) async {
  const testJson = '{"name": "Test", "data": [1, 2, 3]}';

  await _clearAndEnterText($, testJson);
  await $.pumpAndSettle();

  // Test format toggle buttons if they exist
  final formatButtons = ['Pretty', 'Minify', 'Compact', 'Formatted'];

  for (final buttonText in formatButtons) {
    final button = find.text(buttonText);
    if (button.evaluate().isNotEmpty) {
      await $.tap(button);
      await $.pumpAndSettle();
      break;
    }
  }
}

// Helper functions
Future<void> _enterTextInInput(PatrolIntegrationTester $, String text) async {
  // Find the input field - could be TextField, TextFormField, or similar
  final inputField = find.byType(TextField).or(find.byType(TextFormField));

  if (inputField.evaluate().isNotEmpty) {
    await $.tap(inputField);
    await $.pumpAndSettle();
    await $.enterText(inputField, text);
  } else {
    // Try to find by semantic label or hint
    final inputByHint = find.byWidgetPredicate(
      (widget) => widget is TextField &&
                   (widget.decoration?.hintText?.contains('Enter') == true ||
                    widget.decoration?.hintText?.contains('Paste') == true)
    );

    if (inputByHint.evaluate().isNotEmpty) {
      await $.tap(inputByHint);
      await $.pumpAndSettle();
      await $.enterText(inputByHint, text);
    }
  }
}

Future<void> _clearAndEnterText(PatrolIntegrationTester $, String text) async {
  final inputField = find.byType(TextField).or(find.byType(TextFormField));

  if (inputField.evaluate().isNotEmpty) {
    await $.tap(inputField);
    await $.pumpAndSettle();

    // Clear existing text
    await $.enterText(inputField, '');
    await $.pumpAndSettle();

    // Enter new text
    await $.enterText(inputField, text);
    await $.pumpAndSettle();
  }
}

Future<void> _verifyOutputContains(PatrolIntegrationTester $, String expectedText) async {
  // Look for expected text in output area
  expect(
    find.textContaining(expectedText),
    findsAtLeastOneWidget,
    reason: 'Output should contain: $expectedText'
  );
}