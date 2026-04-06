import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:bharattesting_core/core.dart';

void main() {
  group('PdfPageManipulator', () {
    late List<PdfPageData> testPages;

    setUp(() {
      testPages = [
        PdfPageData(
          pageNumber: 1,
          dimensions: PageDimensions.a4(),
          lastModified: DateTime.now(),
        ),
        PdfPageData(
          pageNumber: 2,
          dimensions: PageDimensions.letter(),
          rotation: PageRotation.rotate90,
          lastModified: DateTime.now(),
        ),
        PdfPageData(
          pageNumber: 3,
          dimensions: PageDimensions.a4(),
          lastModified: DateTime.now(),
        ),
      ];
    });

    group('Page Rotation', () {
      test('should rotate page correctly', () async {
        final originalPage = testPages.first;
        final rotatedPage = await PdfPageManipulator.rotatePage(
          originalPage,
          PageRotation.rotate90,
        );

        expect(rotatedPage.rotation, equals(PageRotation.rotate90));
        expect(rotatedPage.pageNumber, equals(originalPage.pageNumber));
        expect(rotatedPage.lastModified.isAfter(originalPage.lastModified), isTrue);
      });

      test('should handle multiple rotations correctly', () async {
        var page = testPages.first;

        // Rotate 90 degrees
        page = await PdfPageManipulator.rotatePage(page, PageRotation.rotate90);
        expect(page.rotation, equals(PageRotation.rotate90));

        // Rotate another 90 degrees (total 180)
        page = await PdfPageManipulator.rotatePage(page, PageRotation.rotate90);
        expect(page.rotation, equals(PageRotation.rotate180));

        // Rotate another 180 degrees (total 360, should be 0)
        page = await PdfPageManipulator.rotatePage(page, PageRotation.rotate180);
        expect(page.rotation, equals(PageRotation.none));
      });

      test('should rotate dimensions for 90/270 degree rotations', () async {
        final originalPage = PdfPageData(
          pageNumber: 1,
          dimensions: const PageDimensions(width: 100, height: 200),
          lastModified: DateTime.now(),
        );

        final rotated90 = await PdfPageManipulator.rotatePage(
          originalPage,
          PageRotation.rotate90,
        );

        expect(rotated90.dimensions.width, equals(200));
        expect(rotated90.dimensions.height, equals(100));

        final rotated180 = await PdfPageManipulator.rotatePage(
          originalPage,
          PageRotation.rotate180,
        );

        expect(rotated180.dimensions.width, equals(100));
        expect(rotated180.dimensions.height, equals(200));
      });

      test('should rotate multiple pages in batch', () async {
        final rotatedPages = await PdfPageManipulator.rotatePages(
          testPages,
          [0, 2], // Rotate pages 1 and 3
          PageRotation.rotate90,
        );

        expect(rotatedPages.length, equals(testPages.length));
        expect(rotatedPages[0].rotation, equals(PageRotation.rotate90));
        expect(rotatedPages[1].rotation, equals(PageRotation.rotate90)); // Already rotated
        expect(rotatedPages[2].rotation, equals(PageRotation.rotate90));
      });

      test('should ignore invalid indices in batch rotation', () async {
        final rotatedPages = await PdfPageManipulator.rotatePages(
          testPages,
          [-1, 0, 10], // Invalid indices
          PageRotation.rotate90,
        );

        expect(rotatedPages.length, equals(testPages.length));
        expect(rotatedPages[0].rotation, equals(PageRotation.rotate90));
        expect(rotatedPages[1].rotation, equals(PageRotation.rotate90)); // Unchanged
        expect(rotatedPages[2].rotation, equals(PageRotation.none)); // Unchanged
      });

      test('should handle no rotation gracefully', () async {
        final originalPage = testPages.first;
        final unchangedPage = await PdfPageManipulator.rotatePage(
          originalPage,
          PageRotation.none,
        );

        expect(unchangedPage, equals(originalPage));
      });
    });

    group('Page Deletion', () {
      test('should delete pages by indices', () {
        final result = PdfPageManipulator.deletePages(testPages, [1]); // Delete page 2

        expect(result.length, equals(2));
        expect(result[0].pageNumber, equals(1));
        expect(result[1].pageNumber, equals(3));
      });

      test('should delete multiple pages', () {
        final result = PdfPageManipulator.deletePages(testPages, [0, 2]); // Delete pages 1 and 3

        expect(result.length, equals(1));
        expect(result[0].pageNumber, equals(2));
      });

      test('should handle empty deletion list', () {
        final result = PdfPageManipulator.deletePages(testPages, []);

        expect(result.length, equals(testPages.length));
        expect(result, equals(testPages));
      });

      test('should ignore invalid indices', () {
        final result = PdfPageManipulator.deletePages(testPages, [-1, 10]);

        expect(result.length, equals(testPages.length));
        expect(result, equals(testPages));
      });

      test('should handle deleting all pages', () {
        final result = PdfPageManipulator.deletePages(testPages, [0, 1, 2]);

        expect(result.length, equals(0));
      });
    });

    group('Page Reordering', () {
      test('should reorder pages correctly', () {
        final result = PdfPageManipulator.reorderPages(testPages, 0, 2); // Move page 1 to position 3

        expect(result.length, equals(testPages.length));
        expect(result[0].pageNumber, equals(2)); // Original page 2
        expect(result[1].pageNumber, equals(3)); // Original page 3
        expect(result[2].pageNumber, equals(1)); // Original page 1
      });

      test('should handle moving to earlier position', () {
        final result = PdfPageManipulator.reorderPages(testPages, 2, 0); // Move page 3 to position 1

        expect(result.length, equals(testPages.length));
        expect(result[0].pageNumber, equals(3)); // Original page 3
        expect(result[1].pageNumber, equals(1)); // Original page 1
        expect(result[2].pageNumber, equals(2)); // Original page 2
      });

      test('should handle same position move', () {
        final result = PdfPageManipulator.reorderPages(testPages, 1, 1); // No change

        expect(result, equals(testPages));
      });

      test('should handle invalid indices', () {
        final result1 = PdfPageManipulator.reorderPages(testPages, -1, 1);
        final result2 = PdfPageManipulator.reorderPages(testPages, 1, 10);

        expect(result1, equals(testPages));
        expect(result2, equals(testPages));
      });

      test('should reorder by array', () {
        final newOrder = [2, 0, 1]; // Page 3, Page 1, Page 2
        final result = PdfPageManipulator.reorderPagesByArray(testPages, newOrder);

        expect(result.length, equals(testPages.length));
        expect(result[0].pageNumber, equals(3));
        expect(result[1].pageNumber, equals(1));
        expect(result[2].pageNumber, equals(2));
      });

      test('should validate reorder array', () {
        expect(
          () => PdfPageManipulator.reorderPagesByArray(testPages, [0, 1]), // Too short
          throwsA(isA<PageManipulationException>()),
        );

        expect(
          () => PdfPageManipulator.reorderPagesByArray(testPages, [0, 0, 1]), // Duplicate
          throwsA(isA<PageManipulationException>()),
        );

        expect(
          () => PdfPageManipulator.reorderPagesByArray(testPages, [0, 1, 3]), // Invalid index
          throwsA(isA<PageManipulationException>()),
        );
      });
    });

    group('Page Extraction', () {
      test('should extract page range', () {
        final result = PdfPageManipulator.extractPageRange(testPages, 1, 2);

        expect(result.length, equals(2));
        expect(result[0].pageNumber, equals(2));
        expect(result[1].pageNumber, equals(3));
      });

      test('should extract single page', () {
        final result = PdfPageManipulator.extractPageRange(testPages, 1, 1);

        expect(result.length, equals(1));
        expect(result[0].pageNumber, equals(2));
      });

      test('should extract all pages', () {
        final result = PdfPageManipulator.extractPageRange(testPages, 0, 2);

        expect(result.length, equals(testPages.length));
        expect(result, equals(testPages));
      });

      test('should validate range parameters', () {
        expect(
          () => PdfPageManipulator.extractPageRange(testPages, -1, 1),
          throwsA(isA<PageManipulationException>()),
        );

        expect(
          () => PdfPageManipulator.extractPageRange(testPages, 1, 0),
          throwsA(isA<PageManipulationException>()),
        );

        expect(
          () => PdfPageManipulator.extractPageRange(testPages, 0, 10),
          throwsA(isA<PageManipulationException>()),
        );
      });
    });

    group('Page Duplication', () {
      test('should duplicate page after original', () {
        final result = PdfPageManipulator.duplicatePage(testPages, 1);

        expect(result.length, equals(4));
        expect(result[1].pageNumber, equals(2)); // Original
        expect(result[2].pageNumber, equals(3)); // Duplicate (renumbered)
        expect(result[2].isDuplicate, isTrue);
      });

      test('should duplicate page before original', () {
        final result = PdfPageManipulator.duplicatePage(testPages, 1, insertAfter: false);

        expect(result.length, equals(4));
        expect(result[1].pageNumber, equals(2)); // Duplicate (renumbered)
        expect(result[1].isDuplicate, isTrue);
        expect(result[2].pageNumber, equals(3)); // Original (renumbered)
      });

      test('should validate page index for duplication', () {
        expect(
          () => PdfPageManipulator.duplicatePage(testPages, -1),
          throwsA(isA<PageManipulationException>()),
        );

        expect(
          () => PdfPageManipulator.duplicatePage(testPages, 10),
          throwsA(isA<PageManipulationException>()),
        );
      });
    });

    group('Blank Page Insertion', () {
      test('should insert blank page at position', () {
        final result = PdfPageManipulator.insertBlankPage(testPages, 1);

        expect(result.length, equals(4));
        expect(result[1].isBlank, isTrue);
        expect(result[1].pageNumber, equals(2)); // Renumbered
        expect(result[1].dimensions, equals(PageDimensions.a4())); // Default
      });

      test('should insert blank page with custom dimensions', () {
        const customDimensions = PageDimensions(width: 500, height: 600);
        final result = PdfPageManipulator.insertBlankPage(
          testPages,
          0,
          dimensions: customDimensions,
        );

        expect(result.length, equals(4));
        expect(result[0].isBlank, isTrue);
        expect(result[0].dimensions, equals(customDimensions));
      });

      test('should validate insert index', () {
        expect(
          () => PdfPageManipulator.insertBlankPage(testPages, -1),
          throwsA(isA<PageManipulationException>()),
        );

        expect(
          () => PdfPageManipulator.insertBlankPage(testPages, 10),
          throwsA(isA<PageManipulationException>()),
        );
      });
    });

    group('Statistics Calculation', () {
      test('should calculate statistics correctly', () {
        final stats = PdfPageManipulator.calculateStatistics(testPages);

        expect(stats.totalPages, equals(3));
        expect(stats.rotatedPages, equals(1)); // One page has rotation
        expect(stats.orientationCounts[PageOrientation.portrait], equals(3));
        expect(stats.uniqueDimensions.length, equals(2)); // A4 and Letter
        expect(stats.predominantOrientation, equals(PageOrientation.portrait));
        expect(stats.hasConsistentDimensions, isFalse);
      });

      test('should handle empty page list', () {
        final stats = PdfPageManipulator.calculateStatistics([]);

        expect(stats.totalPages, equals(0));
        expect(stats.rotatedPages, equals(0));
        expect(stats.orientationCounts, isEmpty);
        expect(stats.uniqueDimensions, isEmpty);
        expect(stats.predominantOrientation, isNull);
        expect(stats.totalArea, equals(0));
        expect(stats.averageArea, equals(0));
      });

      test('should identify consistent dimensions', () {
        final consistentPages = [
          PdfPageData(
            pageNumber: 1,
            dimensions: PageDimensions.a4(),
            lastModified: DateTime.now(),
          ),
          PdfPageData(
            pageNumber: 2,
            dimensions: PageDimensions.a4(),
            lastModified: DateTime.now(),
          ),
        ];

        final stats = PdfPageManipulator.calculateStatistics(consistentPages);
        expect(stats.hasConsistentDimensions, isTrue);
      });
    });

    group('Data Classes', () {
      test('PdfPageData should create correctly', () {
        final page = PdfPageData(
          pageNumber: 1,
          dimensions: PageDimensions.a4(),
          lastModified: DateTime.now(),
        );

        expect(page.pageNumber, equals(1));
        expect(page.orientation, equals(PageOrientation.portrait));
        expect(page.isModified, isFalse);
        expect(page.isBlank, isFalse);
        expect(page.isDuplicate, isFalse);
      });

      test('PdfPageData should create blank page', () {
        final blankPage = PdfPageData.createBlank();

        expect(blankPage.isBlank, isTrue);
        expect(blankPage.pageNumber, equals(0));
        expect(blankPage.dimensions, equals(PageDimensions.a4()));
      });

      test('PdfPageData should support copyWith', () {
        final original = testPages.first;
        final modified = original.copyWith(
          pageNumber: 10,
          rotation: PageRotation.rotate180,
        );

        expect(modified.pageNumber, equals(10));
        expect(modified.rotation, equals(PageRotation.rotate180));
        expect(modified.dimensions, equals(original.dimensions));
      });

      test('PageDimensions should calculate properties correctly', () {
        const dimensions = PageDimensions(width: 100, height: 200);

        expect(dimensions.area, equals(20000));
        expect(dimensions.aspectRatio, equals(0.5));
      });

      test('PageDimensions should have factory methods', () {
        final a4 = PageDimensions.a4();
        final letter = PageDimensions.letter();

        expect(a4.width, closeTo(595.276, 0.001));
        expect(a4.height, closeTo(841.89, 0.001));
        expect(letter.width, equals(612));
        expect(letter.height, equals(792));
      });

      test('PageRotation should handle degrees correctly', () {
        expect(PageRotation.none.degrees, equals(0));
        expect(PageRotation.rotate90.degrees, equals(90));
        expect(PageRotation.rotate180.degrees, equals(180));
        expect(PageRotation.rotate270.degrees, equals(270));

        expect(PageRotation.fromDegrees(0), equals(PageRotation.none));
        expect(PageRotation.fromDegrees(90), equals(PageRotation.rotate90));
        expect(PageRotation.fromDegrees(180), equals(PageRotation.rotate180));
        expect(PageRotation.fromDegrees(270), equals(PageRotation.rotate270));
        expect(PageRotation.fromDegrees(360), equals(PageRotation.none));
        expect(PageRotation.fromDegrees(450), equals(PageRotation.rotate90));
      });
    });

    group('Error Handling', () {
      test('PageManipulationException should provide useful information', () {
        const exception = PageManipulationException('Test error');

        expect(exception.message, equals('Test error'));
        expect(exception.toString(), contains('Test error'));
      });
    });

    group('Edge Cases', () {
      test('should handle very large page collections', () {
        final largePageList = List.generate(1000, (index) => PdfPageData(
          pageNumber: index + 1,
          dimensions: PageDimensions.a4(),
          lastModified: DateTime.now(),
        ));

        // Should not throw for large collections
        final stats = PdfPageManipulator.calculateStatistics(largePageList);
        expect(stats.totalPages, equals(1000));

        // Should handle reordering efficiently
        final reordered = PdfPageManipulator.reorderPages(largePageList, 0, 999);
        expect(reordered.length, equals(1000));
      });

      test('should maintain page metadata through operations', () {
        final pageWithMetadata = testPages.first.copyWith(
          metadata: {'custom': 'value', 'source': 'test'},
        );

        final rotated = await PdfPageManipulator.rotatePage(
          pageWithMetadata,
          PageRotation.rotate90,
        );

        expect(rotated.metadata, equals(pageWithMetadata.metadata));
      });

      test('should handle mixed orientations correctly', () {
        final mixedPages = [
          PdfPageData(
            pageNumber: 1,
            dimensions: const PageDimensions(width: 100, height: 200), // Portrait
            lastModified: DateTime.now(),
          ),
          PdfPageData(
            pageNumber: 2,
            dimensions: const PageDimensions(width: 200, height: 100), // Landscape
            lastModified: DateTime.now(),
          ),
          PdfPageData(
            pageNumber: 3,
            dimensions: const PageDimensions(width: 150, height: 150), // Square
            lastModified: DateTime.now(),
          ),
        ];

        final stats = PdfPageManipulator.calculateStatistics(mixedPages);

        expect(stats.orientationCounts[PageOrientation.portrait], equals(1));
        expect(stats.orientationCounts[PageOrientation.landscape], equals(1));
        expect(stats.orientationCounts[PageOrientation.square], equals(1));
        expect(stats.predominantOrientation, isNotNull);
      });
    });
  });
}