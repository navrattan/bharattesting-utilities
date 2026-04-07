import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_utilities/features/json_converter/json_converter_screen.dart';
import 'package:bharattesting_utilities/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('JsonConverterScreen', () {
    Widget createTestWidget() {
      return ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          home: const JsonConverterScreen(),
        ),
      );
    }

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify basic elements are present
      expect(find.text('String-to-JSON Converter'), findsOneWidget);
      expect(find.text('Input'), findsOneWidget);
      expect(find.text('Output (JSON)'), findsOneWidget);
      expect(find.text('Auto-repair'), findsOneWidget);
      expect(find.text('Prettify'), findsOneWidget);
    });

    testWidgets('displays examples drawer when button tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find and tap the Examples button
      await tester.tap(find.text('Examples'));
      await tester.pumpAndSettle();

      // Verify drawer is shown with examples
      expect(find.text('Examples'), findsWidgets);
      expect(find.text('Malformed JSON'), findsOneWidget);
      expect(find.text('CSV Data'), findsOneWidget);
    });

    testWidgets('shows help dialog when help button tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find and tap the help button
      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pumpAndSettle();

      // Verify help dialog is shown
      expect(find.text('String to JSON Converter'), findsOneWidget);
      expect(find.text('Features:'), findsOneWidget);
      expect(find.text('Auto-Repair Rules:'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('input editor accepts text input', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find the input text field
      final inputField = find.byType(TextField).first;

      // Enter some text
      await tester.enterText(inputField, '{"test": "value"}');
      await tester.pumpAndSettle();

      // Verify the text was entered
      expect(find.text('{"test": "value"}'), findsOneWidget);
    });

    testWidgets('toggle buttons work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find toggle buttons
      final autoRepairButton = find.text('Auto-repair');
      final prettifyButton = find.text('Prettify');

      // Tap auto-repair toggle
      await tester.tap(autoRepairButton);
      await tester.pumpAndSettle();

      // Tap prettify toggle
      await tester.tap(prettifyButton);
      await tester.pumpAndSettle();

      // Buttons should still be present (toggled state)
      expect(find.text('Auto-repair'), findsOneWidget);
      expect(find.text('Prettify'), findsOneWidget);
    });

    testWidgets('action buttons are present', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify action buttons
      expect(find.byIcon(Icons.content_paste), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.text('Process'), findsOneWidget);
    });
  });
}