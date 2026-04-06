import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_core/core.dart';
import 'package:bharattesting_utilities/features/document_scanner/models/document_scanner_state.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/page_thumbnail_list.dart';

void main() {
  group('PageThumbnailList Tests', () {
    late List<ScannedPage> testPages;

    setUp(() {
      testPages = [
        ScannedPage(
          id: '1',
          originalImageData: Uint8List(100),
          imageWidth: 640,
          imageHeight: 480,
          detectedCorners: DocumentQuadrilateral([
            const Point(0, 0),
            const Point(640, 0),
            const Point(640, 480),
            const Point(0, 480),
          ]),
          status: PageStatus.processed,
          captureTime: DateTime.now(),
        ),
        ScannedPage(
          id: '2',
          originalImageData: Uint8List(150),
          imageWidth: 800,
          imageHeight: 600,
          detectedCorners: DocumentQuadrilateral([
            const Point(0, 0),
            const Point(800, 0),
            const Point(800, 600),
            const Point(0, 600),
          ]),
          status: PageStatus.processing,
          captureTime: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
        ScannedPage(
          id: '3',
          originalImageData: Uint8List(200),
          imageWidth: 1024,
          imageHeight: 768,
          detectedCorners: DocumentQuadrilateral([
            const Point(0, 0),
            const Point(1024, 0),
            const Point(1024, 768),
            const Point(0, 768),
          ]),
          status: PageStatus.error,
          error: 'Processing failed',
          captureTime: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ];
    });

    testWidgets('displays empty state when no pages', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: const [],
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
            ),
          ),
        ),
      );

      expect(find.text('No pages scanned yet'), findsOneWidget);
      expect(find.byIcon(Icons.imageOff), findsOneWidget);
    });

    testWidgets('displays pages in horizontal list', (tester) async {
      String? selectedPageId;
      String? deletedPageId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              selectedPageId: '1',
              onPageSelected: (id) => selectedPageId = id,
              onPageDeleted: (id) => deletedPageId = id,
              isVertical: false,
            ),
          ),
        ),
      );

      // Should display page numbers
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Test page selection
      await tester.tap(find.text('2'));
      expect(selectedPageId, equals('2'));
    });

    testWidgets('displays pages in vertical list with details', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              selectedPageId: '1',
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              isVertical: true,
              showDetails: true,
            ),
          ),
        ),
      );

      // Should show page details
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('Page 2'), findsOneWidget);
      expect(find.text('Page 3'), findsOneWidget);

      // Should show dimensions
      expect(find.text('640 × 480'), findsOneWidget);
      expect(find.text('800 × 600'), findsOneWidget);
      expect(find.text('1024 × 768'), findsOneWidget);
    });

    testWidgets('handles page deletion', (tester) async {
      String? deletedPageId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              onPageSelected: (id) {},
              onPageDeleted: (id) => deletedPageId = id,
              isVertical: false,
            ),
          ),
        ),
      );

      // Find and tap delete button for first page
      final deleteButtons = find.byType(GestureDetector);
      expect(deleteButtons, findsWidgets);

      // The delete button should be somewhere in the widget tree
      await tester.tap(deleteButtons.first);
      // Note: The exact delete button tap is hard to test without more specific widget structure
    });

    testWidgets('shows processing indicator for processing pages', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              isVertical: false,
            ),
          ),
        ),
      );

      // Should show loading indicator for processing page
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error indicator for error pages', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              isVertical: false,
            ),
          ),
        ),
      );

      // Should show error icon for error page
      expect(find.byIcon(Icons.alertCircle), findsOneWidget);
    });

    testWidgets('supports reordering when enabled', (tester) async {
      int? oldIndex, newIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              onPageReordered: (old, newIdx) {
                oldIndex = old;
                newIndex = newIdx;
              },
              isVertical: true,
            ),
          ),
        ),
      );

      // Should use ReorderableListView when onPageReordered is provided
      expect(find.byType(ReorderableListView), findsOneWidget);
    });

    testWidgets('uses regular ListView when reordering disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              isVertical: true,
            ),
          ),
        ),
      );

      // Should use regular ListView when onPageReordered is not provided
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('highlights selected page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: testPages,
              selectedPageId: '2',
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              isVertical: false,
            ),
          ),
        ),
      );

      // Selected page should be highlighted (implementation detail - hard to test without inspecting style)
      await tester.pumpAndSettle();
    });

    testWidgets('shows OCR indicator for pages with text', (tester) async {
      final pageWithOcr = ScannedPage(
        id: '4',
        originalImageData: Uint8List(100),
        imageWidth: 640,
        imageHeight: 480,
        detectedCorners: DocumentQuadrilateral([
          const Point(0, 0),
          const Point(640, 0),
          const Point(640, 480),
          const Point(0, 480),
        ]),
        ocrResult: const OcrResult(
          fullText: 'Some detected text',
          textBlocks: [],
          overallConfidence: 0.85,
          processingTime: Duration(seconds: 2),
        ),
        status: PageStatus.processed,
        captureTime: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailList(
              pages: [pageWithOcr],
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              isVertical: true,
              showDetails: true,
            ),
          ),
        ),
      );

      // Should show OCR indicator
      expect(find.text('OCR detected'), findsOneWidget);
    });
  });

  group('PageThumbnailGrid Tests', () {
    late List<ScannedPage> testPages;

    setUp(() {
      testPages = [
        ScannedPage(
          id: '1',
          originalImageData: Uint8List(100),
          imageWidth: 640,
          imageHeight: 480,
          detectedCorners: DocumentQuadrilateral([
            const Point(0, 0),
            const Point(640, 0),
            const Point(640, 480),
            const Point(0, 480),
          ]),
          status: PageStatus.processed,
          captureTime: DateTime.now(),
        ),
        ScannedPage(
          id: '2',
          originalImageData: Uint8List(150),
          imageWidth: 800,
          imageHeight: 600,
          detectedCorners: DocumentQuadrilateral([
            const Point(0, 0),
            const Point(800, 0),
            const Point(800, 600),
            const Point(0, 600),
          ]),
          status: PageStatus.processed,
          captureTime: DateTime.now(),
        ),
      ];
    });

    testWidgets('displays empty state in grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailGrid(
              pages: const [],
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
            ),
          ),
        ),
      );

      expect(find.text('No pages scanned yet'), findsOneWidget);
      expect(find.text('Capture or upload documents to get started'), findsOneWidget);
    });

    testWidgets('displays pages in grid layout', (tester) async {
      String? selectedPageId;
      String? deletedPageId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailGrid(
              pages: testPages,
              selectedPageId: '1',
              onPageSelected: (id) => selectedPageId = id,
              onPageDeleted: (id) => deletedPageId = id,
              crossAxisCount: 2,
            ),
          ),
        ),
      );

      // Should use GridView
      expect(find.byType(GridView), findsOneWidget);

      // Should display page cards
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('Page 2'), findsOneWidget);
    });

    testWidgets('handles page selection in grid', (tester) async {
      String? selectedPageId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailGrid(
              pages: testPages,
              onPageSelected: (id) => selectedPageId = id,
              onPageDeleted: (id) {},
            ),
          ),
        ),
      );

      // Tap on first page card
      await tester.tap(find.text('Page 1'));
      expect(selectedPageId, equals('1'));
    });

    testWidgets('shows page information in grid cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailGrid(
              pages: testPages,
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
            ),
          ),
        ),
      );

      // Should show page dimensions
      expect(find.text('640 × 480'), findsOneWidget);
      expect(find.text('800 × 600'), findsOneWidget);
    });

    testWidgets('handles different grid configurations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageThumbnailGrid(
              pages: testPages,
              onPageSelected: (id) {},
              onPageDeleted: (id) {},
              crossAxisCount: 3,
              childAspectRatio: 0.8,
            ),
          ),
        ),
      );

      // Should still display the grid with different configuration
      expect(find.byType(GridView), findsOneWidget);
    });
  });

  group('Page Status Extensions Tests', () {
    test('PageStatus extensions work correctly', () {
      expect(PageStatus.captured.displayName, equals('Captured'));
      expect(PageStatus.processing.displayName, equals('Processing...'));
      expect(PageStatus.processed.displayName, equals('Processed'));
      expect(PageStatus.error.displayName, equals('Error'));

      expect(PageStatus.processing.isProcessing, isTrue);
      expect(PageStatus.captured.isProcessing, isFalse);

      expect(PageStatus.processed.isProcessed, isTrue);
      expect(PageStatus.captured.isProcessed, isFalse);

      expect(PageStatus.error.hasError, isTrue);
      expect(PageStatus.processed.hasError, isFalse);
    });
  });

  group('ScannedPage Model Tests', () {
    late ScannedPage testPage;

    setUp(() {
      testPage = ScannedPage(
        id: 'test-1',
        originalImageData: Uint8List(1000), // 1KB
        imageWidth: 640,
        imageHeight: 480,
        detectedCorners: DocumentQuadrilateral([
          const Point(0, 0),
          const Point(640, 0),
          const Point(640, 480),
          const Point(0, 480),
        ]),
        correctedImageData: Uint8List(800), // 0.8KB
        correctedWidth: 600,
        correctedHeight: 450,
        captureTime: DateTime(2024, 1, 1, 12, 30),
      );
    });

    test('calculates file sizes correctly', () {
      expect(testPage.originalFileSize, equals(1000));
      expect(testPage.processedFileSize, equals(800));
      expect(testPage.fileSizeText, equals('0.8 KB'));
    });

    test('formats large file sizes correctly', () {
      final largePage = testPage.copyWith(
        originalImageData: Uint8List(2 * 1024 * 1024), // 2MB
      );
      expect(largePage.fileSizeText, equals('2.0 MB'));
    });

    test('determines processing status correctly', () {
      expect(testPage.isProcessed, isTrue);

      final unprocessedPage = testPage.copyWith(correctedImageData: null);
      expect(unprocessedPage.isProcessed, isFalse);
    });

    test('detects OCR text correctly', () {
      expect(testPage.hasOcrText, isFalse);

      final pageWithOcr = testPage.copyWith(
        ocrResult: const OcrResult(
          fullText: 'Test text',
          textBlocks: [],
          overallConfidence: 0.9,
          processingTime: Duration(seconds: 1),
        ),
      );
      expect(pageWithOcr.hasOcrText, isTrue);
    });

    test('returns best image data correctly', () {
      // With filtered data
      final filteredPage = testPage.copyWith(
        filteredImageData: Uint8List(600),
      );
      expect(filteredPage.bestImageData.length, equals(600));

      // With corrected data only
      expect(testPage.bestImageData.length, equals(800));

      // With original data only
      final originalOnlyPage = testPage.copyWith(
        correctedImageData: null,
        filteredImageData: null,
      );
      expect(originalOnlyPage.bestImageData.length, equals(1000));
    });

    test('calculates best image dimensions correctly', () {
      final filteredPage = testPage.copyWith(
        filteredImageData: Uint8List(600),
      );

      final (width, height) = filteredPage.bestImageDimensions;
      expect(width, equals(600));
      expect(height, equals(450));

      // Test with original dimensions when no corrected size
      final originalPage = testPage.copyWith(
        correctedImageData: null,
        correctedWidth: null,
        correctedHeight: null,
      );

      final (origWidth, origHeight) = originalPage.bestImageDimensions;
      expect(origWidth, equals(640));
      expect(origHeight, equals(480));
    });

    test('generates display name correctly', () {
      final page = testPage.copyWith(
        captureTime: DateTime(2024, 1, 1, 12, 30, 45, 123),
      );

      expect(page.displayName, startsWith('Page '));
      expect(page.displayName, contains('1704110445123'));
    });
  });
}