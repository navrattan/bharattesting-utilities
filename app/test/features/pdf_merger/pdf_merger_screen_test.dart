import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_utilities/features/pdf_merger/pdf_merger_screen.dart';
import 'package:bharattesting_utilities/features/pdf_merger/models/pdf_merger_state.dart';
import 'package:bharattesting_utilities/features/pdf_merger/providers/pdf_merger_provider.dart';
import 'package:bharattesting_core/core.dart';

void main() {
  group('PdfMergerScreen Widget Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = ProviderScope(
        child: MaterialApp(
          home: const PdfMergerScreen(),
        ),
      );
    });

    testWidgets('should render all main components', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Check for main title
      expect(find.text('PDF Merger'), findsOneWidget);

      // Check for drop zone when no files loaded
      expect(find.text('Drop PDF files or click to browse'), findsOneWidget);

      // Check for action buttons in app bar
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should show responsive layout on different screen sizes', (tester) async {
      // Test mobile layout
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // On mobile, should show tabs
      expect(find.byType(TabBarView), findsOneWidget);

      // Test desktop layout
      tester.view.physicalSize = const Size(1200, 800);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // On desktop, should show side-by-side layout
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('should show document list when PDFs are loaded', (tester) async {
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => TestPdfMergerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show documents and pages
      expect(find.text('Loaded Documents'), findsOneWidget);
      expect(find.text('document1'), findsOneWidget);
      expect(find.text('document2'), findsOneWidget);
    });

    testWidgets('should show page grid when PDFs have pages', (tester) async {
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => TestPdfMergerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show page thumbnails
      expect(find.text('Page 1'), findsAtLeastNWidgets(1));
      expect(find.text('Page 2'), findsAtLeastNWidgets(1));
    });

    testWidgets('should show processing overlay during merge', (tester) async {
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => ProcessingPdfMergerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show processing overlay
      expect(find.text('Processing PDF Merge'), findsOneWidget);
      expect(find.text('75% Complete'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle clear all confirmation', (tester) async {
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => TestPdfMergerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap clear all button
      final clearButton = find.byIcon(Icons.clear_all);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Should show confirmation dialog
      expect(find.text('Clear All Documents?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
    });

    testWidgets('should show advanced settings when toggled', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find and tap advanced settings toggle
      final settingsButton = find.byIcon(Icons.settings_outlined);
      expect(settingsButton, findsOneWidget);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Should update icon to indicate active state
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should handle empty state correctly', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Should show empty state
      expect(find.text('No PDF Files Loaded'), findsOneWidget);
      expect(find.text('Choose PDF Files'), findsOneWidget);
    });

    testWidgets('should show password dialog when encryption enabled', (tester) async {
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => PasswordDialogPdfMergerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show password dialog
      expect(find.text('Set PDF Password'), findsOneWidget);
      expect(find.text('Password'), findsAtLeastNWidgets(1));
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should handle tablet layout correctly', (tester) async {
      // Set tablet size
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => TestPdfMergerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show tablet layout with side panels
      expect(find.byType(VerticalDivider), findsOneWidget);
    });
  });

  group('PdfMergerScreen Integration Tests', () {
    testWidgets('should handle merge button press', (tester) async {
      final notifier = TestPdfMergerNotifier();
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => notifier),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap merge button
      final mergeButton = find.text('Merge PDFs');
      expect(mergeButton, findsOneWidget);
      await tester.tap(mergeButton);
      await tester.pump();

      // Verify merge was called
      expect(notifier.mergePdfsCalled, isTrue);
    });

    testWidgets('should handle page selection and actions', (tester) async {
      final notifier = TestPdfMergerNotifier();
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => notifier),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find a page card
      final pageCard = find.text('Page 1').first;
      expect(pageCard, findsOneWidget);

      // Tap on page to select it
      await tester.tap(pageCard);
      await tester.pump();

      // Verify page was selected
      expect(notifier.selectPageCalled, isTrue);
    });

    testWidgets('should handle document removal', (tester) async {
      final notifier = TestPdfMergerNotifier();
      final container = ProviderContainer(
        overrides: [
          pdfMergerProvider.overrideWith(() => notifier),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const PdfMergerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find document removal button
      final removeButton = find.byIcon(Icons.close).first;
      expect(removeButton, findsOneWidget);
      await tester.tap(removeButton);
      await tester.pump();

      // Verify document removal was called
      expect(notifier.removeDocumentCalled, isTrue);
    });
  });
}

// Test notifiers for mocking different states
class TestPdfMergerNotifier extends PdfMerger {
  bool mergePdfsCalled = false;
  bool selectPageCalled = false;
  bool removeDocumentCalled = false;

  @override
  PdfMergerState build() {
    return PdfMergerState(
      documents: [
        PdfDocument(
          id: '1',
          fileName: 'document1.pdf',
          data: Uint8List(100),
          fileSize: 100,
          pageCount: 2,
          status: DocumentStatus.loaded,
        ),
        PdfDocument(
          id: '2',
          fileName: 'document2.pdf',
          data: Uint8List(200),
          fileSize: 200,
          pageCount: 3,
          status: DocumentStatus.loaded,
        ),
      ],
      pages: [
        PdfPageThumbnail(
          id: 'page1',
          documentId: '1',
          pageNumber: 0,
          globalIndex: 0,
          dimensions: PageDimensions.a4(),
          status: ThumbnailStatus.ready,
        ),
        PdfPageThumbnail(
          id: 'page2',
          documentId: '1',
          pageNumber: 1,
          globalIndex: 1,
          dimensions: PageDimensions.a4(),
          status: ThumbnailStatus.ready,
        ),
      ],
    );
  }

  @override
  Future<void> mergePdfs() async {
    mergePdfsCalled = true;
  }

  @override
  void selectPage(String? pageId) {
    selectPageCalled = true;
  }

  @override
  void removeDocument(String documentId) {
    removeDocumentCalled = true;
  }

  // Implement other required methods with no-op
  @override
  Future<void> addDocumentsFromPicker() async {}

  @override
  Future<void> addDocumentsFromDrop(List<PlatformFile> files) async {}

  @override
  void removePage(String pageId) {}

  @override
  void reorderPages(int fromIndex, int toIndex) {}

  @override
  Future<void> rotatePage(String pageId, PageRotation rotation) async {}

  @override
  void duplicatePage(String pageId) {}

  @override
  void selectDocument(String? documentId) {}

  @override
  void toggleEncryption() {}

  @override
  void updateEncryptionPassword(String password) {}

  @override
  void updateMergeOptions(PdfMergeOptions options) {}

  @override
  void updatePermissions(PdfPermissions permissions) {}

  @override
  void toggleAdvancedSettings() {}

  @override
  void setPasswordDialogVisible(bool visible) {}

  @override
  Future<void> downloadMergedPdf() async {}

  @override
  void clearAll() {}

  @override
  MergeStatistics calculateStatistics() {
    return const MergeStatistics();
  }
}

class ProcessingPdfMergerNotifier extends PdfMerger {
  @override
  PdfMergerState build() {
    return const PdfMergerState(
      isProcessing: true,
      processingProgress: 75,
      pages: [
        PdfPageThumbnail(
          id: 'page1',
          documentId: '1',
          pageNumber: 0,
          globalIndex: 0,
          dimensions: PageDimensions(width: 595, height: 842),
          status: ThumbnailStatus.ready,
        ),
      ],
    );
  }
}

class PasswordDialogPdfMergerNotifier extends PdfMerger {
  @override
  PdfMergerState build() {
    return const PdfMergerState(
      showPasswordDialog: true,
      enableEncryption: true,
    );
  }
}