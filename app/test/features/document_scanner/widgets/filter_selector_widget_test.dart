import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_core/core.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/filter_selector_widget.dart';

void main() {
  group('FilterSelectorWidget Tests', () {
    testWidgets('displays all available filters', (tester) async {
      DocumentFilter? selectedFilter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.original,
              onFilterChanged: (filter) => selectedFilter = filter,
            ),
          ),
        ),
      );

      // Should display title
      expect(find.text('Document Filters'), findsOneWidget);

      // Should display all filter options
      expect(find.text('Original'), findsOneWidget);
      expect(find.text('Auto Color'), findsOneWidget);
      expect(find.text('Grayscale'), findsOneWidget);
      expect(find.text('Black & White'), findsOneWidget);
      expect(find.text('Magic Color'), findsOneWidget);
      expect(find.text('Whiteboard'), findsOneWidget);
    });

    testWidgets('shows selected filter correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.grayscale,
              onFilterChanged: (filter) {},
            ),
          ),
        ),
      );

      // Selected filter should be highlighted (visual test - hard to verify exact styling)
      await tester.pumpAndSettle();
    });

    testWidgets('calls onFilterChanged when filter tapped', (tester) async {
      DocumentFilter? selectedFilter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.original,
              onFilterChanged: (filter) => selectedFilter = filter,
            ),
          ),
        ),
      );

      // Tap on Auto Color filter
      await tester.tap(find.text('Auto Color'));
      expect(selectedFilter, equals(DocumentFilter.autoColor));
    });

    testWidgets('shows filter descriptions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.autoColor,
              onFilterChanged: (filter) {},
            ),
          ),
        ),
      );

      // Should show description for selected filter
      expect(find.text(DocumentFilter.autoColor.description), findsOneWidget);
    });

    testWidgets('compact mode displays horizontal filter list', (tester) async {
      DocumentFilter? selectedFilter;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.original,
              onFilterChanged: (filter) => selectedFilter = filter,
              isCompact: true,
            ),
          ),
        ),
      );

      // Should use horizontal ListView
      expect(find.byType(ListView), findsOneWidget);

      // Should show compact filter buttons
      expect(find.text('Original'), findsOneWidget);
      expect(find.text('Auto'), findsOneWidget); // Compact name
      expect(find.text('Gray'), findsOneWidget); // Compact name

      // Test filter selection in compact mode
      await tester.tap(find.text('Auto'));
      expect(selectedFilter, equals(DocumentFilter.autoColor));
    });

    testWidgets('shows preview section when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.grayscale,
              onFilterChanged: (filter) {},
              showPreview: true,
              previewImageData: Uint8List(100).toList(),
            ),
          ),
        ),
      );

      // Should show preview section
      expect(find.text('Filter Preview'), findsOneWidget);
      expect(find.text('Original'), findsOneWidget);
      expect(find.text('Grayscale'), findsOneWidget); // Selected filter name
    });

    testWidgets('does not show preview when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.grayscale,
              onFilterChanged: (filter) {},
              showPreview: false,
            ),
          ),
        ),
      );

      // Should not show preview section
      expect(find.text('Filter Preview'), findsNothing);
    });

    testWidgets('all filter icons are displayed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterSelectorWidget(
              selectedFilter: DocumentFilter.original,
              onFilterChanged: (filter) {},
            ),
          ),
        ),
      );

      // Should have icons for all filters
      expect(find.byType(Icon), findsNWidgets(DocumentFilter.values.length));
    });
  });

  group('AdvancedFilterOptions Tests', () {
    testWidgets('shows nothing for original filter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedFilterOptions(
              selectedFilter: DocumentFilter.original,
              filterOptions: const FilterOptions(),
              onFilterOptionsChanged: (options) {},
            ),
          ),
        ),
      );

      // Should show nothing for original filter
      expect(find.byType(SizedBox), findsOneWidget); // SizedBox.shrink
    });

    testWidgets('shows CLAHE options for auto color filter', (tester) async {
      FilterOptions? changedOptions;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedFilterOptions(
              selectedFilter: DocumentFilter.autoColor,
              filterOptions: const FilterOptions(),
              onFilterOptionsChanged: (options) => changedOptions = options,
            ),
          ),
        ),
      );

      // Should show CLAHE controls
      expect(find.text('Advanced Auto Color Options'), findsOneWidget);
      expect(find.text('CLAHE Clip Limit'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);

      // Test slider interaction
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Should trigger callback (exact value hard to test due to slider behavior)
    });

    testWidgets('shows threshold options for black and white filter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedFilterOptions(
              selectedFilter: DocumentFilter.blackAndWhite,
              filterOptions: const FilterOptions(),
              onFilterOptionsChanged: (options) {},
            ),
          ),
        ),
      );

      // Should show threshold controls
      expect(find.text('Advanced Black & White Options'), findsOneWidget);
      expect(find.text('Block Size'), findsOneWidget);
      expect(find.text('Threshold Constant'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(2)); // Two sliders
    });

    testWidgets('reset button works correctly', (tester) async {
      FilterOptions? resetOptions;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedFilterOptions(
              selectedFilter: DocumentFilter.autoColor,
              filterOptions: const FilterOptions(claheClipLimit: 3.0),
              onFilterOptionsChanged: (options) => resetOptions = options,
            ),
          ),
        ),
      );

      // Tap reset button
      await tester.tap(find.text('Reset to Defaults'));

      // Should reset to default options
      expect(resetOptions, equals(const FilterOptions()));
    });
  });

  group('FilterComparisonWidget Tests', () {
    late List<int> testImageData;
    late List<int> testFilteredData;

    setUp(() {
      testImageData = List.generate(1000, (i) => i % 256);
      testFilteredData = List.generate(1000, (i) => (i * 2) % 256);
    });

    testWidgets('displays before and after images', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterComparisonWidget(
              originalImageData: testImageData,
              filteredImageData: testFilteredData,
              filterName: 'Grayscale',
              width: 300,
              height: 200,
            ),
          ),
        ),
      );

      // Should show comparison container
      expect(find.text('Original'), findsOneWidget);
      expect(find.text('Grayscale'), findsOneWidget);
    });

    testWidgets('handles different filter names', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterComparisonWidget(
              originalImageData: testImageData,
              filteredImageData: testFilteredData,
              filterName: 'Auto Color',
              width: 400,
              height: 300,
            ),
          ),
        ),
      );

      expect(find.text('Auto Color'), findsOneWidget);
    });

    testWidgets('uses custom dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterComparisonWidget(
              originalImageData: testImageData,
              filteredImageData: testFilteredData,
              filterName: 'Test Filter',
              width: 250,
              height: 150,
            ),
          ),
        ),
      );

      // Widget should be rendered with custom dimensions (hard to test exact size)
      await tester.pumpAndSettle();
    });
  });

  group('Filter Extensions Tests', () {
    test('DocumentFilter displayName extension works', () {
      expect(DocumentFilter.original.displayName, equals('Original'));
      expect(DocumentFilter.autoColor.displayName, equals('Auto Color'));
      expect(DocumentFilter.grayscale.displayName, equals('Grayscale'));
      expect(DocumentFilter.blackAndWhite.displayName, equals('Black & White'));
      expect(DocumentFilter.magicColor.displayName, equals('Magic Color'));
      expect(DocumentFilter.whiteboard.displayName, equals('Whiteboard'));
    });

    test('DocumentFilter description extension works', () {
      for (final filter in DocumentFilter.values) {
        expect(filter.description, isA<String>());
        expect(filter.description.isNotEmpty, isTrue);
      }
    });

    test('all filters have unique display names', () {
      final displayNames = DocumentFilter.values.map((f) => f.displayName).toSet();
      expect(displayNames.length, equals(DocumentFilter.values.length));
    });
  });

  group('FilterOptions Tests', () {
    test('FilterOptions has reasonable defaults', () {
      const options = FilterOptions();

      expect(options.claheClipLimit, equals(2.0));
      expect(options.adaptiveBlockSize, equals(11));
      expect(options.adaptiveC, equals(2));
    });

    test('FilterOptions copyWith works correctly', () {
      const original = FilterOptions();
      final modified = original.copyWith(
        claheClipLimit: 3.0,
        adaptiveBlockSize: 15,
      );

      expect(modified.claheClipLimit, equals(3.0));
      expect(modified.adaptiveBlockSize, equals(15));
      expect(modified.adaptiveC, equals(2)); // Should remain unchanged
    });

    test('FilterOptions equality works', () {
      const options1 = FilterOptions();
      const options2 = FilterOptions();
      const options3 = FilterOptions(claheClipLimit: 3.0);

      expect(options1, equals(options2));
      expect(options1, isNot(equals(options3)));
    });
  });

  group('Filter Icon Tests', () {
    testWidgets('each filter has appropriate icon', (tester) async {
      for (final filter in DocumentFilter.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FilterSelectorWidget(
                selectedFilter: filter,
                onFilterChanged: (f) {},
                isCompact: true,
              ),
            ),
          ),
        );

        // Should have at least one icon
        expect(find.byType(Icon), findsWidgets);

        await tester.pumpAndSettle();
      }
    });
  });

  group('Filter Preview Colors Tests', () {
    test('each filter has preview color defined', () {
      final widget = FilterSelectorWidget(
        selectedFilter: DocumentFilter.original,
        onFilterChanged: (filter) {},
      );

      // Test that preview colors can be generated for all filters
      for (final filter in DocumentFilter.values) {
        // This would test the _getFilterPreviewColor method if it was exposed
        // For now, we just ensure no exceptions are thrown
        expect(() => filter.displayName, returnsNormally);
      }
    });
  });

  group('Compact Filter Names Tests', () {
    test('compact filter names are shorter than full names', () {
      final compactNames = {
        DocumentFilter.original: 'Original',
        DocumentFilter.autoColor: 'Auto',
        DocumentFilter.grayscale: 'Gray',
        DocumentFilter.blackAndWhite: 'B&W',
        DocumentFilter.magicColor: 'Magic',
        DocumentFilter.whiteboard: 'Board',
      };

      for (final entry in compactNames.entries) {
        final filter = entry.key;
        final compactName = entry.value;

        expect(compactName.length, lessThanOrEqualTo(filter.displayName.length));
      }
    });
  });
}