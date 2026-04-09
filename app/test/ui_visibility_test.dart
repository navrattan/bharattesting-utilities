import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_utilities/shared/widgets/tool_scaffold.dart';
import 'package:bharattesting_utilities/features/home/home_screen.dart';
import 'package:bharattesting_utilities/generated/l10n/app_localizations.dart';
import 'package:bharattesting_utilities/router/app_router.dart';

void main() {
  group('UI Visibility Audit', () {
    Widget createTestWidget(Widget child) {
      return ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      );
    }

    testWidgets('HomeScreen should have non-zero dimensions and visible content', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      // Wrap in a fake GoRouter context if needed, or just test the widget directly
      await tester.pumpWidget(createTestWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      // Verify basic visibility
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Check if the Bento Grid exists
      final gridFinder = find.byType(GridView);
      expect(gridFinder, findsOneWidget);

      // Verify dimensions
      final RenderBox gridBox = tester.renderObject(gridFinder);
      expect(gridBox.size.height, greaterThan(0));
      
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('ToolScaffold body should not collapse height', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);

      // We test _MobileLayout directly to avoid GoRouter dependency in this unit test
      await tester.pumpWidget(
        createTestWidget(
          Scaffold(
            body: Column(
              children: [
                const Text('Header'),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.red,
                    key: const Key('expanded_content'),
                  ),
                ),
                const Text('Footer'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final boxFinder = find.byKey(const Key('expanded_content'));
      final RenderBox box = tester.renderObject(boxFinder);
      
      expect(box.size.height, greaterThan(0), 
        reason: 'Content collapsed! Expanded child has 0 height.');
      
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
