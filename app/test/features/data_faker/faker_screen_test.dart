import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/data_faker/faker_screen.dart';
import 'package:app/features/data_faker/faker_provider.dart';
import 'package:app/features/data_faker/faker_state.dart';

/// Test helpers and mock setup
class MockProviderScope extends StatelessWidget {
  const MockProviderScope({
    required this.child,
    this.overrides = const [],
    super.key,
  });

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: child,
      ),
    );
  }
}

void main() {
  group('FakerScreen', () {
    testWidgets('renders correctly with initial state', (tester) async {
      await tester.pumpWidget(
        const MockProviderScope(
          child: FakerScreen(),
        ),
      );

      // Verify basic elements are present
      expect(find.text('Important Disclaimer'), findsOneWidget);
      expect(find.text('Generation Options'), findsOneWidget);
      expect(find.text('Entity Template'), findsOneWidget);
      expect(find.text('Bulk Size'), findsOneWidget);

      // Verify default template is selected
      expect(find.text('Individual'), findsOneWidget);

      // Verify generate button is present
      expect(find.text('Generate Single Record'), findsOneWidget);
    });

    testWidgets('shows disclaimer card', (tester) async {
      await tester.pumpWidget(
        const MockProviderScope(
          child: FakerScreen(),
        ),
      );

      expect(find.text('Important Disclaimer'), findsOneWidget);
      expect(
        find.text('All generated data is completely synthetic and for testing purposes only.'),
        findsOneWidget,
      );
    });

    testWidgets('allows template selection', (tester) async {
      await tester.pumpWidget(
        const MockProviderScope(
          child: FakerScreen(),
        ),
      );

      // Find and tap company template
      await tester.tap(find.text('Company'));
      await tester.pumpAndSettle();

      // Should show company-specific description
      expect(find.textContaining('Business identifiers for private/public companies'), findsOneWidget);
    });

    testWidgets('allows bulk size selection', (tester) async {
      await tester.pumpWidget(
        const MockProviderScope(
          child: FakerScreen(),
        ),
      );

      // Initially should show single record
      expect(find.text('Generate Single Record'), findsOneWidget);

      // Find slider and change value
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Tap on different size option
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      // Should update button text
      expect(find.text('Generate 10 Records'), findsOneWidget);
    });

    testWidgets('shows advanced options in expansion tile', (tester) async {
      await tester.pumpWidget(
        const MockProviderScope(
          child: FakerScreen(),
        ),
      );

      // Find and expand advanced options
      await tester.tap(find.text('Advanced Options'));
      await tester.pumpAndSettle();

      // Should show seed options
      expect(find.text('Use Random Seed'), findsOneWidget);
      expect(find.text('Preferred State'), findsOneWidget);
    });

    testWidgets('shows error message when error occurs', (tester) async {
      const errorState = FakerState(
        errorMessage: 'Test error message',
      );

      await tester.pumpWidget(
        MockProviderScope(
          overrides: [
            fakerNotifierProvider.overrideWith(() => TestFakerNotifier(errorState)),
          ],
          child: const FakerScreen(),
        ),
      );

      expect(find.text('Test error message'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('shows results section when records are generated', (tester) async {
      final stateWithRecords = FakerState(
        generatedRecords: [
          {
            'template_type': 'individual',
            'pan': 'ABCDE1234F',
            'aadhaar': '123456789012',
            'state': 'Karnataka',
          }
        ],
        lastGenerationTimeMs: 150,
      );

      await tester.pumpWidget(
        MockProviderScope(
          overrides: [
            fakerNotifierProvider.overrideWith(() => TestFakerNotifier(stateWithRecords)),
          ],
          child: const FakerScreen(),
        ),
      );

      expect(find.text('Generated Results'), findsOneWidget);
      expect(find.text('1 Individual record generated in 150ms'), findsOneWidget);
      expect(find.text('Export Options'), findsOneWidget);
    });

    testWidgets('shows loading state during generation', (tester) async {
      const loadingState = FakerState(
        isGenerating: true,
        bulkSize: BulkSize.small,
      );

      await tester.pumpWidget(
        MockProviderScope(
          overrides: [
            fakerNotifierProvider.overrideWith(() => TestFakerNotifier(loadingState)),
          ],
          child: const FakerScreen(),
        ),
      );

      expect(find.text('Generating 10 Records...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('handles state selector dialog', (tester) async {
      await tester.pumpWidget(
        const MockProviderScope(
          child: FakerScreen(),
        ),
      );

      // Open advanced options
      await tester.tap(find.text('Advanced Options'));
      await tester.pumpAndSettle();

      // Tap on preferred state
      await tester.tap(find.text('Preferred State'));
      await tester.pumpAndSettle();

      // Should show state selection dialog
      expect(find.text('Select Preferred State'), findsOneWidget);
      expect(find.text('Karnataka'), findsOneWidget);
      expect(find.text('Tamil Nadu'), findsOneWidget);
    });

    group('Template-specific behavior', () {
      testWidgets('shows correct identifiers for individual template', (tester) async {
        await tester.pumpWidget(
          const MockProviderScope(
            child: FakerScreen(),
          ),
        );

        // Individual template should be selected by default
        expect(find.text('PAN'), findsOneWidget);
        expect(find.text('AADHAAR'), findsOneWidget);
        expect(find.text('UPI'), findsOneWidget);
      });

      testWidgets('shows correct identifiers for company template', (tester) async {
        await tester.pumpWidget(
          const MockProviderScope(
            child: FakerScreen(),
          ),
        );

        // Select company template
        await tester.tap(find.text('Company'));
        await tester.pumpAndSettle();

        expect(find.text('GSTIN'), findsOneWidget);
        expect(find.text('CIN'), findsOneWidget);
        expect(find.text('TAN'), findsOneWidget);
      });
    });

    group('Performance hints', () {
      testWidgets('shows fast generation hint for small datasets', (tester) async {
        await tester.pumpWidget(
          const MockProviderScope(
            child: FakerScreen(),
          ),
        );

        // Should show fast generation hint for single record
        expect(find.textContaining('Instant generation'), findsOneWidget);
      });

      testWidgets('shows slow generation warning for large datasets', (tester) async {
        await tester.pumpWidget(
          const MockProviderScope(
            child: FakerScreen(),
          ),
        );

        // Select large dataset
        await tester.tap(find.text('1000'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Slower generation'), findsOneWidget);
      });
    });
  });
}

/// Test implementation of FakerNotifier for mocking
class TestFakerNotifier extends FakerNotifier {
  TestFakerNotifier(this._state);

  final FakerState _state;

  @override
  FakerState build() => _state;
}