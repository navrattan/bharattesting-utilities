import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_core/core.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/document_overlay_widget.dart';

void main() {
  group('DocumentOverlayWidget Tests', () {
    late DocumentQuadrilateral testQuadrilateral;

    setUp(() {
      testQuadrilateral = DocumentQuadrilateral([
        const Point(100, 100), // top-left
        const Point(300, 100), // top-right
        const Point(300, 400), // bottom-right
        const Point(100, 400), // bottom-left
      ]);
    });

    testWidgets('renders document overlay with quadrilateral', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: false,
                stabilityScore: 0.5,
              ),
            ),
          ),
        ),
      );

      // Should render the custom painter
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('shows corner handles when enabled', (tester) async {
      int cornerMoved = -1;
      Offset? movedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: true,
                showCornerHandles: true,
                onCornerMoved: (index, position) {
                  cornerMoved = index;
                  movedPosition = position;
                },
              ),
            ),
          ),
        ),
      );

      // Should show corner handle containers
      expect(find.byType(GestureDetector), findsNWidgets(4)); // 4 corner handles

      // Test corner dragging
      await tester.drag(find.byType(GestureDetector).first, const Offset(10, 10));
      expect(cornerMoved, equals(0)); // First corner
      expect(movedPosition, isNotNull);
    });

    testWidgets('hides corner handles by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: false,
                showCornerHandles: false,
              ),
            ),
          ),
        ),
      );

      // Should not show corner handles when disabled
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('animates stability changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: false,
                stabilityScore: 0.3,
              ),
            ),
          ),
        ),
      );

      // Initial state
      await tester.pumpAndSettle();

      // Update to stable state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: true,
                stabilityScore: 0.95,
              ),
            ),
          ),
        ),
      );

      // Should animate the change
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
    });

    testWidgets('handles quadrilateral changes', (tester) async {
      const initialQuad = DocumentQuadrilateral([
        Point(50, 50),
        Point(250, 50),
        Point(250, 350),
        Point(50, 350),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: initialQuad,
                isStable: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Update quadrilateral
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('shows different states for stability', (tester) async {
      // Test unstable state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: false,
                stabilityScore: 0.3,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test stable state with high score
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: DocumentOverlayWidget(
                quadrilateral: testQuadrilateral,
                isStable: true,
                stabilityScore: 0.95,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    });
  });

  group('DocumentOverlayPainter Tests', () {
    late DocumentQuadrilateral testQuad;
    late DocumentOverlayPainter painter;

    setUp(() {
      testQuad = DocumentQuadrilateral([
        const Point(100, 100),
        const Point(300, 100),
        const Point(300, 400),
        const Point(100, 400),
      ]);
    });

    testWidgets('painter shouldRepaint works correctly', (tester) async {
      final painter1 = DocumentOverlayPainter(
        quadrilateral: testQuad,
        isStable: false,
        stabilityScore: 0.5,
        showCornerHandles: false,
        pulseScale: 1.0,
        stabilityOpacity: 1.0,
      );

      final painter2 = DocumentOverlayPainter(
        quadrilateral: testQuad,
        isStable: true, // Different stability
        stabilityScore: 0.5,
        showCornerHandles: false,
        pulseScale: 1.0,
        stabilityOpacity: 1.0,
      );

      final painter3 = DocumentOverlayPainter(
        quadrilateral: testQuad,
        isStable: false,
        stabilityScore: 0.5,
        showCornerHandles: false,
        pulseScale: 1.0,
        stabilityOpacity: 1.0,
      );

      // Should repaint when properties differ
      expect(painter1.shouldRepaint(painter2), isTrue);

      // Should not repaint when properties are the same
      expect(painter1.shouldRepaint(painter3), isFalse);
    });
  });

  group('CornerPositions Tests', () {
    test('provides correct default positions', () {
      expect(CornerPositions.defaultA4Portrait, hasLength(4));
      expect(CornerPositions.defaultA4Landscape, hasLength(4));
      expect(CornerPositions.defaultSquare, hasLength(4));

      // Test that positions are reasonable
      final portrait = CornerPositions.defaultA4Portrait;
      expect(portrait[0].dx < portrait[1].dx, isTrue); // top-left < top-right X
      expect(portrait[0].dy < portrait[3].dy, isTrue); // top-left < bottom-left Y
    });
  });

  group('DetectionThresholds Tests', () {
    test('has reasonable threshold values', () {
      expect(DetectionThresholds.minConfidence, lessThan(DetectionThresholds.goodConfidence));
      expect(DetectionThresholds.goodConfidence, lessThan(DetectionThresholds.excellentConfidence));

      expect(DetectionThresholds.minStability, lessThan(DetectionThresholds.goodStability));
      expect(DetectionThresholds.goodStability, lessThan(DetectionThresholds.excellentStability));

      expect(DetectionThresholds.minArea, greaterThan(0));
      expect(DetectionThresholds.maxSkew, greaterThan(0));
    });
  });

  group('DetectionColors Tests', () {
    test('getColorForConfidence returns appropriate colors', () {
      expect(DetectionColors.getColorForConfidence(0.1), equals(DetectionColors.searching));
      expect(DetectionColors.getColorForConfidence(0.5), equals(DetectionColors.found));
      expect(DetectionColors.getColorForConfidence(0.8), equals(DetectionColors.good));
      expect(DetectionColors.getColorForConfidence(0.95), equals(DetectionColors.excellent));
    });

    test('getColorForStability returns appropriate colors', () {
      expect(DetectionColors.getColorForStability(0.2), equals(DetectionColors.searching));
      expect(DetectionColors.getColorForStability(0.6), equals(DetectionColors.found));
      expect(DetectionColors.getColorForStability(0.85), equals(DetectionColors.good));
      expect(DetectionColors.getColorForStability(0.98), equals(DetectionColors.excellent));
    });

    test('all color constants are defined', () {
      expect(DetectionColors.searching, isA<Color>());
      expect(DetectionColors.found, isA<Color>());
      expect(DetectionColors.good, isA<Color>());
      expect(DetectionColors.excellent, isA<Color>());
      expect(DetectionColors.error, isA<Color>());
    });
  });
}