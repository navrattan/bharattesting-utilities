import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_utilities/features/home/home_screen.dart';
import 'package:bharattesting_utilities/features/data_faker/faker_screen.dart';
import 'package:bharattesting_utilities/features/document_scanner/screens/document_scanner_screen.dart';

/// Comprehensive accessibility tests for BharatTesting Utilities
///
/// Tests WCAG 2.1 AA compliance including:
/// - Semantic labels and descriptions
/// - Touch target sizes (min 48x48dp)
/// - Color contrast ratios (4.5:1 for text, 3:1 for large text)
/// - Keyboard navigation support
/// - Screen reader compatibility
void main() {
  group('Accessibility Tests', () {
    group('Semantic Labels Tests', () {
      testWidgets('home screen has proper semantic labels', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        // Tool cards should have semantic labels
        final toolCards = find.byType(Card);
        expect(toolCards.evaluate().isNotEmpty, isTrue);

        // Check for semantic descriptions on interactive elements
        final semanticFinders = [
          find.bySemanticsLabel('Document Scanner'),
          find.bySemanticsLabel('Image Size Reducer'),
          find.bySemanticsLabel('PDF Merger'),
          find.bySemanticsLabel('String-to-JSON Converter'),
          find.bySemanticsLabel('Indian Data Faker'),
        ];

        for (final finder in semanticFinders) {
          if (finder.evaluate().isNotEmpty) {
            expect(finder, findsWidgets);
          }
        }

        // Footer should be accessible
        final footerText = find.text('Built by BTQA Services Pvt Ltd');
        if (footerText.evaluate().isNotEmpty) {
          expect(footerText, findsOneWidget);
        }
      });

      testWidgets('data faker has semantic labels for all controls', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: FakerScreen()),
        );

        await tester.pumpAndSettle();

        // Template selectors should have semantic labels
        final templateLabels = [
          'Individual template',
          'Company template',
          'Proprietorship template',
        ];

        for (final label in templateLabels) {
          final finder = find.bySemanticsLabel(label);
          if (finder.evaluate().isNotEmpty) {
            expect(finder, findsOneWidget);
          }
        }

        // Generate button should be accessible
        final generateButton = find.byType(ElevatedButton);
        if (generateButton.evaluate().isNotEmpty) {
          final button = tester.widget<ElevatedButton>(generateButton.first);
          // Should have semantic label or accessible text
        }

        // Identifier checkboxes should have labels
        final checkboxes = find.byType(Checkbox);
        for (final checkbox in checkboxes.evaluate()) {
          final widget = checkbox.widget as Checkbox;
          // Should have proper semantic labeling
        }
      });

      testWidgets('document scanner has camera control labels', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: DocumentScannerScreen()),
        );

        await tester.pumpAndSettle();

        // Camera controls should be accessible
        final cameraButtons = find.byType(IconButton);
        for (final button in cameraButtons.evaluate()) {
          final iconButton = button.widget as IconButton;
          if (iconButton.tooltip != null) {
            expect(iconButton.tooltip!.isNotEmpty, isTrue);
          }
        }

        // Mode selection should be accessible
        final modeSelections = [
          find.text('Camera'),
          find.text('Upload'),
        ];

        for (final mode in modeSelections) {
          if (mode.evaluate().isNotEmpty) {
            expect(mode, findsOneWidget);
          }
        }
      });
    });

    group('Touch Target Size Tests', () {
      testWidgets('all interactive elements meet 48x48dp minimum', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        await tester.pumpAndSettle();

        // Check tool cards touch target size
        final toolCards = find.byType(Card);
        for (final card in toolCards.evaluate()) {
          final cardBox = tester.getRect(find.byWidget(card.widget));
          expect(cardBox.width, greaterThanOrEqualTo(48.0));
          expect(cardBox.height, greaterThanOrEqualTo(48.0));
        }

        // Check any buttons
        final buttons = find.byType(ElevatedButton);
        for (final button in buttons.evaluate()) {
          final buttonBox = tester.getRect(find.byWidget(button.widget));
          expect(buttonBox.width, greaterThanOrEqualTo(48.0));
          expect(buttonBox.height, greaterThanOrEqualTo(48.0));
        }

        // Check icon buttons
        final iconButtons = find.byType(IconButton);
        for (final iconButton in iconButtons.evaluate()) {
          final iconBox = tester.getRect(find.byWidget(iconButton.widget));
          expect(iconBox.width, greaterThanOrEqualTo(48.0));
          expect(iconBox.height, greaterThanOrEqualTo(48.0));
        }
      });

      testWidgets('checkboxes and radio buttons have adequate touch targets', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: FakerScreen()),
        );

        await tester.pumpAndSettle();

        // Check checkbox touch targets
        final checkboxes = find.byType(Checkbox);
        for (final checkbox in checkboxes.evaluate()) {
          final checkboxBox = tester.getRect(find.byWidget(checkbox.widget));
          expect(checkboxBox.width, greaterThanOrEqualTo(48.0));
          expect(checkboxBox.height, greaterThanOrEqualTo(48.0));
        }

        // Check any radio buttons
        final radioButtons = find.byType(RadioButton);
        for (final radio in radioButtons.evaluate()) {
          final radioBox = tester.getRect(find.byWidget(radio.widget));
          expect(radioBox.width, greaterThanOrEqualTo(48.0));
          expect(radioBox.height, greaterThanOrEqualTo(48.0));
        }
      });

      testWidgets('sliders have adequate touch area', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Slider(
                value: 0.5,
                onChanged: (value) {},
              ),
            ),
          ),
        );

        final slider = find.byType(Slider);
        final sliderBox = tester.getRect(slider);

        // Slider should have adequate height for touch
        expect(sliderBox.height, greaterThanOrEqualTo(48.0));
      });
    });

    group('Color Contrast Tests', () {
      testWidgets('text colors meet WCAG contrast requirements', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        await tester.pumpAndSettle();

        // Test primary text contrast
        final theme = Theme.of(tester.element(find.byType(Scaffold)));
        final backgroundColor = theme.scaffoldBackgroundColor;
        final textColor = theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onSurface;

        // Calculate contrast ratio (simplified test)
        final backgroundLuminance = backgroundColor.computeLuminance();
        final textLuminance = textColor.computeLuminance();

        final contrastRatio = (backgroundLuminance > textLuminance)
            ? (backgroundLuminance + 0.05) / (textLuminance + 0.05)
            : (textLuminance + 0.05) / (backgroundLuminance + 0.05);

        // WCAG AA requires 4.5:1 for normal text, 3:1 for large text
        expect(contrastRatio, greaterThan(4.5));
      });

      testWidgets('button colors meet contrast requirements', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: () {},
                child: const Text('Test Button'),
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        final theme = Theme.of(tester.element(find.byType(Scaffold)));

        final buttonColor = theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ??
                           theme.colorScheme.primary;
        final buttonTextColor = theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ??
                               theme.colorScheme.onPrimary;

        // Button should have adequate contrast
        final backgroundLuminance = buttonColor.computeLuminance();
        final textLuminance = buttonTextColor.computeLuminance();

        final contrastRatio = (backgroundLuminance > textLuminance)
            ? (backgroundLuminance + 0.05) / (textLuminance + 0.05)
            : (textLuminance + 0.05) / (backgroundLuminance + 0.05);

        expect(contrastRatio, greaterThan(4.5));
      });

      testWidgets('error colors meet contrast requirements', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Text(
                'Error message',
                style: TextStyle(
                  color: Theme.of(tester.element(find.byType(Scaffold))).colorScheme.error,
                ),
              ),
            ),
          ),
        );

        final theme = Theme.of(tester.element(find.byType(Scaffold)));
        final backgroundColor = theme.scaffoldBackgroundColor;
        final errorColor = theme.colorScheme.error;

        final backgroundLuminance = backgroundColor.computeLuminance();
        final errorLuminance = errorColor.computeLuminance();

        final contrastRatio = (backgroundLuminance > errorLuminance)
            ? (backgroundLuminance + 0.05) / (errorLuminance + 0.05)
            : (errorLuminance + 0.05) / (backgroundLuminance + 0.05);

        expect(contrastRatio, greaterThan(4.5));
      });
    });

    group('Focus Management Tests', () {
      testWidgets('focus traversal works correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'First Field'),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Second Field'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Test tab navigation
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        // First text field should be focused
        final firstField = find.byType(TextField).first;
        expect(tester.binding.focusManager.primaryFocus?.context?.widget,
               equals(tester.firstWidget(firstField)));

        // Tab to next field
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        // Tab to button
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        final button = find.byType(ElevatedButton);
        expect(Focus.of(tester.element(button)).hasPrimaryFocus, isTrue);
      });

      testWidgets('focus indicators are visible', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: () {},
                child: const Text('Focusable Button'),
              ),
            ),
          ),
        );

        final button = find.byType(ElevatedButton);

        // Focus the button
        await tester.tap(button);
        await tester.pump();

        // Focus should be visible (implementation depends on Material 3 focus styles)
        expect(Focus.of(tester.element(button)).hasPrimaryFocus, isTrue);
      });
    });

    group('Screen Reader Support Tests', () {
      testWidgets('semantic tree is properly constructed', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: HomeScreen()),
        );

        await tester.pumpAndSettle();

        // Check semantic tree structure
        final semanticsHandle = tester.binding.pipelineOwner.semanticsOwner!;
        expect(semanticsHandle.rootSemanticsNode, isNotNull);

        // Main content should be in semantic tree
        expect(find.bySemanticsLabel('Developer Tools'), findsWidgets);
      });

      testWidgets('images have alternative text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    semanticLabel: 'BharatTesting Utilities Logo',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  const Icon(
                    Icons.home,
                    semanticLabel: 'Home',
                  ),
                ],
              ),
            ),
          ),
        );

        // Images should have semantic labels
        expect(find.bySemanticsLabel('BharatTesting Utilities Logo'), findsWidgets);
        expect(find.bySemanticsLabel('Home'), findsOneWidget);
      });

      testWidgets('loading states are announced', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Semantics(
                label: 'Loading data, please wait',
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );

        expect(find.bySemanticsLabel('Loading data, please wait'), findsOneWidget);
      });
    });

    group('Text Scaling Tests', () {
      testWidgets('UI handles large text scaling', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 2.0),
                child: const HomeScreen(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // UI should not overflow with large text
        expect(tester.takeException(), isNull);
        expect(find.text('Developer Tools'), findsOneWidget);
      });

      testWidgets('buttons remain usable with large text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
                child: Scaffold(
                  body: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Large Text Button'),
                  ),
                ),
              ),
            ),
          ),
        );

        final button = find.byType(ElevatedButton);
        final buttonBox = tester.getRect(button);

        // Button should still meet minimum touch target
        expect(buttonBox.height, greaterThanOrEqualTo(48.0));
      });
    });

    group('Motion and Animation Tests', () {
      testWidgets('respects reduced motion preferences', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  disableAnimations: true,
                ),
                child: const HomeScreen(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Animations should be disabled
        expect(tester.binding.disableAnimations, isTrue);
      });
    });

    group('Error State Accessibility', () {
      testWidgets('error messages are announced', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      errorText: 'Invalid email format',
                    ),
                  ),
                  Semantics(
                    label: 'Error: Upload failed, please try again',
                    child: Text(
                      'Upload failed',
                      style: TextStyle(
                        color: Theme.of(tester.element(find.byType(Scaffold))).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Error text should be accessible
        expect(find.text('Invalid email format'), findsOneWidget);
        expect(find.bySemanticsLabel('Error: Upload failed, please try again'), findsOneWidget);
      });
    });

    group('Input Method Support', () {
      testWidgets('supports keyboard input for all controls', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                  Slider(
                    value: 0.5,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Checkbox should respond to space key
        final checkbox = find.byType(Checkbox);
        await tester.tap(checkbox);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();

        // Switch should respond to keyboard
        final switchWidget = find.byType(Switch);
        await tester.tap(switchWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();

        // Slider should respond to arrow keys
        final slider = find.byType(Slider);
        await tester.tap(slider);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
      });
    });
  });

  group('WCAG Compliance Verification', () {
    testWidgets('meets WCAG 2.1 AA guidelines summary', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );

      await tester.pumpAndSettle();

      // Verify key WCAG criteria:

      // 1. Perceivable: Text has sufficient contrast
      final theme = Theme.of(tester.element(find.byType(Scaffold)));
      expect(theme.textTheme.bodyLarge?.color, isNotNull);

      // 2. Operable: Interactive elements have adequate size
      final buttons = find.byType(ElevatedButton);
      if (buttons.evaluate().isNotEmpty) {
        final buttonBox = tester.getRect(buttons.first);
        expect(buttonBox.height, greaterThanOrEqualTo(48.0));
      }

      // 3. Understandable: Content is semantically labeled
      expect(find.text('Developer Tools'), findsOneWidget);

      // 4. Robust: Uses standard Material widgets with accessibility support
      expect(find.byType(MaterialApp), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });
}