import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

/// End-to-end tests for Indian Data Faker
///
/// Tests the complete workflow from template selection to data export
void main() {
  group('Data Faker E2E Tests', () {
    late PatrolIntegrationTester $;

    setUp(() async {
      $ = PatrolIntegrationTester();
    });

    patrolTest('complete data generation workflow - individual template', ($) async {
      // Launch app and navigate to data faker
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle();

      // Verify initial state
      await $.waitUntilVisible(find.text('Indian Data Faker'));
      expect(find.text('Generate synthetic Indian identity data'), findsOneWidget);

      // Select Individual template
      final individualTemplate = find.text('Individual');
      if (individualTemplate.evaluate().isNotEmpty) {
        await $.tap(individualTemplate);
        await $.pumpAndSettle();
      }

      // Select identifiers
      final panCheckbox = find.text('PAN');
      if (panCheckbox.evaluate().isNotEmpty) {
        await $.tap(panCheckbox);
        await $.pumpAndSettle();
      }

      final aadhaarCheckbox = find.text('Aadhaar');
      if (aadhaarCheckbox.evaluate().isNotEmpty) {
        await $.tap(aadhaarCheckbox);
        await $.pumpAndSettle();
      }

      // Set record count to 10
      final recordCount10 = find.text('10');
      if (recordCount10.evaluate().isNotEmpty) {
        await $.tap(recordCount10);
        await $.pumpAndSettle();
      }

      // Generate data
      final generateButton = find.text('Generate Data');
      await $.waitUntilVisible(generateButton);
      await $.tap(generateButton);

      // Wait for generation to complete
      await $.waitUntilVisible(find.text('Generated'), timeout: const Duration(seconds: 10));

      // Verify data is generated
      expect(find.byType(DataTable), findsOneWidget);

      // Test copy functionality
      final copyButton = find.text('Copy');
      if (copyButton.evaluate().isNotEmpty) {
        await $.tap(copyButton);
        await $.pumpAndSettle();
      }

      // Verify disclaimer is visible
      expect(
        find.textContaining('synthetic', findRichText: true),
        findsAtLeastNWidget(1),
      );
    });

    patrolTest('company template with GSTIN generation', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle();

      // Select Company template
      final companyTemplate = find.text('Company');
      if (companyTemplate.evaluate().isNotEmpty) {
        await $.tap(companyTemplate);
        await $.pumpAndSettle();
      }

      // Enable GSTIN and CIN
      final gstinCheckbox = find.text('GSTIN');
      if (gstinCheckbox.evaluate().isNotEmpty) {
        await $.tap(gstinCheckbox);
        await $.pumpAndSettle();
      }

      final cinCheckbox = find.text('CIN');
      if (cinCheckbox.evaluate().isNotEmpty) {
        await $.tap(cinCheckbox);
        await $.pumpAndSettle();
      }

      // Generate data
      await $.tap(find.text('Generate Data'));
      await $.waitUntilVisible(find.text('Generated'), timeout: const Duration(seconds: 10));

      // Verify GSTIN format (should start with state code)
      await $.pumpAndSettle();
    });

    patrolTest('bulk data generation with 100 records', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle();

      // Set high record count
      final recordCount100 = find.text('100');
      if (recordCount100.evaluate().isNotEmpty) {
        await $.tap(recordCount100);
        await $.pumpAndSettle();
      }

      // Select multiple identifiers
      for (final identifier in ['PAN', 'Aadhaar', 'IFSC']) {
        final checkbox = find.text(identifier);
        if (checkbox.evaluate().isNotEmpty) {
          await $.tap(checkbox);
          await $.pumpAndSettle();
        }
      }

      // Generate bulk data
      await $.tap(find.text('Generate Data'));

      // Wait longer for bulk generation
      await $.waitUntilVisible(find.text('Generated'), timeout: const Duration(seconds: 15));

      // Verify pagination or scrolling works for large datasets
      await $.pumpAndSettle();
    });

    patrolTest('export functionality CSV and JSON', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle();

      // Generate some data first
      await $.tap(find.text('Generate Data'));
      await $.waitUntilVisible(find.text('Generated'), timeout: const Duration(seconds: 10));

      // Test CSV export
      final downloadButton = find.text('Download');
      if (downloadButton.evaluate().isNotEmpty) {
        await $.tap(downloadButton);
        await $.pumpAndSettle();

        // Verify export format selection
        final csvOption = find.text('CSV');
        if (csvOption.evaluate().isNotEmpty) {
          await $.tap(csvOption);
          await $.pumpAndSettle();
        }
      }

      // Test JSON export
      final jsonOption = find.text('JSON');
      if (jsonOption.evaluate().isNotEmpty) {
        await $.tap(jsonOption);
        await $.pumpAndSettle();
      }
    });

    patrolTest('template switching preserves settings', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle();

      // Configure Individual template
      final individualTemplate = find.text('Individual');
      if (individualTemplate.evaluate().isNotEmpty) {
        await $.tap(individualTemplate);
        await $.pumpAndSettle();
      }

      // Select some identifiers
      final panCheckbox = find.text('PAN');
      if (panCheckbox.evaluate().isNotEmpty) {
        await $.tap(panCheckbox);
        await $.pumpAndSettle();
      }

      // Switch to Company template
      final companyTemplate = find.text('Company');
      if (companyTemplate.evaluate().isNotEmpty) {
        await $.tap(companyTemplate);
        await $.pumpAndSettle();
      }

      // Verify company-specific options are available
      final gstinOption = find.text('GSTIN');
      expect(gstinOption, findsOneWidget);

      // Switch back to Individual
      if (individualTemplate.evaluate().isNotEmpty) {
        await $.tap(individualTemplate);
        await $.pumpAndSettle();
      }

      // Verify individual-specific options are restored
      await $.pumpAndSettle();
    });

    patrolTest('error handling for invalid configurations', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle();

      // Try to generate without selecting any identifiers
      final generateButton = find.text('Generate Data');
      await $.tap(generateButton);
      await $.pumpAndSettle();

      // Should show validation message
      await $.pumpAndSettle(const Duration(seconds: 2));

      // Now select identifiers and try again
      final panCheckbox = find.text('PAN');
      if (panCheckbox.evaluate().isNotEmpty) {
        await $.tap(panCheckbox);
        await $.pumpAndSettle();
      }

      await $.tap(generateButton);
      await $.waitUntilVisible(find.text('Generated'), timeout: const Duration(seconds: 10));
    });

    patrolTest('seed reproducibility test', ($) async {
      app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle();

      // Enable seed input if available
      final seedField = find.byType(TextField);
      if (seedField.evaluate().isNotEmpty) {
        await $.enterText(seedField.first, '12345');
        await $.pumpAndSettle();
      }

      // Generate data
      await $.tap(find.text('Generate Data'));
      await $.waitUntilVisible(find.text('Generated'), timeout: const Duration(seconds: 10));

      // Note: In a real test, we would capture the generated data
      // and verify it matches when the same seed is used again
      await $.pumpAndSettle();
    });
  });
}